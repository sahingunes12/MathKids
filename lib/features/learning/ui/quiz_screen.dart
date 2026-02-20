import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../../core/widgets/bouncy_button.dart';
import '../../../core/widgets/cloud_card.dart';
import '../../gamification/models/exercise.dart';
import '../../gamification/providers/gamification_service.dart';
import '../models/module.dart';
import '../providers/exercise_generator.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String moduleId;

  const QuizScreen({super.key, required this.moduleId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> with TickerProviderStateMixin {
  late LearningModule _module;
  late Exercise _currentExercise;
  final List<Exercise> _sessionExercises = [];
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  AnimationController? _bgController;
  Animation<Color?>? _bgColorAnimation;

  @override
  void initState() {
    super.initState();
    _module = allModules.firstWhere((m) => m.id == widget.moduleId);
    _generateNewExercise();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _bgController?.dispose();
    super.dispose();
  }

  void _setupBgAnimation(Color targetColor) {
    _bgColorAnimation = ColorTween(
      begin: AppColors.background,
      end: targetColor,
    ).animate(_bgController!)
      ..addListener(() {
        setState(() {});
      });
  }

  void _flashBg(Color color) {
    _setupBgAnimation(color.withAlpha(50));
    _bgController?.forward(from: 0).then((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _bgController?.reverse();
      });
    });
  }

  void _generateNewExercise() {
    setState(() {
      _currentExercise = ExerciseGenerator.generate(_module.exerciseType, _module.maxNumber);
    });
  }

  void _onAnswer(String answer) {
    final isCorrect = _currentExercise.answer == answer;

    if (isCorrect) {
      _correctAnswers++;
      _flashBg(AppColors.correct);
      ref.read(gamificationServiceProvider.notifier).onCorrectAnswer(_module.starsPerCorrect);
    } else {
      _wrongAnswers++;
      _flashBg(AppColors.wrong);
      ref.read(gamificationServiceProvider.notifier).onWrongAnswer(
            Exercise(
              id: _currentExercise.id,
              question: _currentExercise.question,
              answer: _currentExercise.answer,
              options: _currentExercise.options,
            ),
          );
    }

    _sessionExercises.add(_currentExercise.copyWith(isCorrect: isCorrect));

    if (_sessionExercises.length >= 10) {
      _showSummary();
    } else {
      _generateNewExercise();
    }
  }

  void _showSummary() {
    final allCorrect = _wrongAnswers == 0;
    if (allCorrect) {
      ref.read(gamificationServiceProvider.notifier).onPerfectSession();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(allCorrect ? 'Harika İş!' : 'Alıştırma Tamamlandı'),
        content: Text('$_correctAnswers doğru, $_wrongAnswers yanlış cevap verdin.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back from quiz screen
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _sessionExercises.length / 10.0;

    return Scaffold(
      backgroundColor: _bgColorAnimation?.value ?? AppColors.background,
      appBar: AppBar(
        title: Text(_module.title, style: AppTextStyles.h2),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.background,
            color: AppColors.primary,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentExercise.question,
                  style: AppTextStyles.h1.copyWith(fontSize: 48, color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: _currentExercise.options.map((option) {
                return BouncyButton(
                  onPressed: () => _onAnswer(option),
                  child: CloudCard(
                    child: Text(option, style: AppTextStyles.h2),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

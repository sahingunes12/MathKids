import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../../core/widgets/bouncy_button.dart';
import '../../gamification/providers/gamification_service.dart';
import '../../gamification/widgets/feedback_overlay.dart';
import '../../../core/services/audio_service.dart';
import '../models/module.dart';
import '../models/exercise.dart';
import '../providers/quiz_provider.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String moduleId;

  const QuizScreen({super.key, required this.moduleId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  late QuizNotifier _quizNotifier;
  late ConfettiController _confettiController;
  bool _starsAwarded = false;

  @override
  void initState() {
    super.initState();
    final module = allModules.firstWhere((m) => m.id == widget.moduleId);
    _quizNotifier = QuizNotifier(module: module);
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _onAnswer(int answer) {
    _quizNotifier.answerQuestion(answer);

    final isCorrect = answer == _quizNotifier.state.currentExercise.correctAnswer;
    
    // Update global stats
    ref.read(gamificationServiceProvider.notifier).updateStats(isCorrect: isCorrect);

    if (isCorrect) {
      _confettiController.play();
      ref.read(audioServiceProvider.notifier).playCorrect();
    } else {
      ref.read(audioServiceProvider.notifier).playWrong();
    }

    // Auto-advance after 1.2 seconds
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      _quizNotifier.nextQuestion();

      // Award stars when quiz finishes
      if (_quizNotifier.state.isFinished && !_starsAwarded) {
        _starsAwarded = true;
        final stars = _quizNotifier.earnedStars;
        if (stars > 0) {
          ref.read(gamificationServiceProvider.notifier).addStars(stars);
          ref.read(audioServiceProvider.notifier).playVictory();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _quizNotifier,
      builder: (context, _) {
        final state = _quizNotifier.state;

        if (state.exercises.isEmpty) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state.isFinished) {
          return _buildResultScreen(state);
        }

        return _buildQuizScreen(state);
      },
    );
  }

  Widget _buildQuizScreen(QuizState state) {
    final exercise = state.currentExercise;

    return FeedbackOverlay(
      confettiController: _confettiController,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            '${state.currentIndex + 1} / ${state.totalQuestions}',
            style: AppTextStyles.h3,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                // Progress bar
                _buildProgressBar(state),
                const SizedBox(height: 32),

                // Question card
                _buildQuestionCard(exercise).animate().fadeIn().scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1.0, 1.0),
                    ),

                const Spacer(),

                // Answer choices
                _buildChoices(exercise, state),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(QuizState state) {
    final progress = (state.currentIndex) / state.totalQuestions;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 10,
        backgroundColor: Colors.white,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }

  Widget _buildQuestionCard(exercise) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: _buildQuestion(exercise),
    );
  }

  Widget _buildQuestion(Exercise exercise) {
    if (exercise.type == ExerciseType.counting) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(exercise.questionText, style: AppTextStyles.h2),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: List<Widget>.generate(exercise.operandA, (index) {
              return Icon(
                exercise.questionIcon ?? Icons.star_rounded,
                size: 64,
                color: exercise.questionColor ?? AppColors.primary,
              ).animate().scale(delay: Duration(milliseconds: 100 * index));
            }),
          ),
        ],
      );
    } else if (exercise.type == ExerciseType.shapes) {
      final shapes = [Icons.circle, Icons.square_rounded, Icons.change_history_rounded, Icons.star_rounded];
      final shapeIcon = shapes[exercise.correctAnswer % shapes.length];
      
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(exercise.questionText, style: AppTextStyles.h2),
          const SizedBox(height: 24),
          Icon(
             shapeIcon,
             size: 120,
             color: exercise.questionColor ?? Colors.purpleAccent,
          ).animate().scale().shimmer(),
        ],
      );
    }

    return Text(
      exercise.questionText,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 52,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -1,
      ),
    );
  }

  Widget _buildChoices(exercise, QuizState state) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.2,
      children: exercise.choices.map<Widget>((choice) {
        Widget content;
        if (exercise.type == ExerciseType.shapes) {
           final shapes = [Icons.circle, Icons.square_rounded, Icons.change_history_rounded, Icons.star_rounded];
           content = Icon(
             shapes[choice % shapes.length],
             size: 40,
             color: state.selectedAnswer == choice || (state.isAnswered && choice == exercise.correctAnswer) 
               ? Colors.white 
               : AppColors.textPrimary,
           );
        } else {
           content = Text(
            '$choice',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: state.selectedAnswer == choice || (state.isAnswered && choice == exercise.correctAnswer)
                  ? Colors.white
                  : AppColors.textPrimary,
            ),
          );
        }

        return _ChoiceButton(
          value: choice,
          correctAnswer: exercise.correctAnswer,
          selectedAnswer: state.selectedAnswer,
          onTap: state.isAnswered ? null : () => _onAnswer(choice),
          child: content,
        );
      }).toList(),
    );
  }

  Widget _buildResultScreen(QuizState state) {
    final stars = _quizNotifier.earnedStars;
    final total = state.totalQuestions;
    final correct = state.correctCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  correct == total ? '🎉 Harika!' : correct >= total ~/ 2 ? '👍 İyi!' : '💪 Devam Et!',
                  style: const TextStyle(fontSize: 48),
                ).animate().scale(),

                const SizedBox(height: 24),

                Text(
                  '$correct / $total doğru',
                  style: AppTextStyles.h1,
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('⭐', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 8),
                    Text(
                      '+$stars Yıldız',
                      style: AppTextStyles.h2.copyWith(color: AppColors.secondary),
                    ),
                  ],
                ).animate().fadeIn(delay: 400.ms).moveY(begin: 20, end: 0),

                const SizedBox(height: 48),

                BouncyButton(
                  onPressed: () {
                    _starsAwarded = false;
                    _quizNotifier.resetQuiz();
                  },
                  child: const Text('Tekrar'),
                ).animate().fadeIn(delay: 600.ms),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Çıkış',
                    style: AppTextStyles.bodyMedium,
                  ),
                ).animate().fadeIn(delay: 700.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final int value;
  final int correctAnswer;
  final int? selectedAnswer;
  final VoidCallback? onTap;
  final Widget? child; // Custom child for shapes

  const _ChoiceButton({
    required this.value,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedAnswer == value;
    final isAnswered = selectedAnswer != null;
    final isCorrect = value == correctAnswer;

    Color bgColor = Colors.white;
    Color textColor = AppColors.textPrimary;

    if (isAnswered) {
      if (isCorrect) {
        bgColor = AppColors.correct;
        textColor = Colors.white;
      } else if (isSelected) {
        bgColor = AppColors.wrong;
        textColor = Colors.white;
      }
    }

    return GestureDetector(
      onTap: isAnswered ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: child ?? Text(
            '$value',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

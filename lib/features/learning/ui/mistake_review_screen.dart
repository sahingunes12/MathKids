import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../../core/widgets/bouncy_button.dart';
import '../../gamification/providers/gamification_service.dart';
import '../../../core/services/audio_service.dart';
import '../models/exercise.dart';

class MistakeReviewScreen extends ConsumerStatefulWidget {
  const MistakeReviewScreen({super.key});

  @override
  ConsumerState<MistakeReviewScreen> createState() => _MistakeReviewScreenState();
}

class _MistakeReviewScreenState extends ConsumerState<MistakeReviewScreen> {
  late List<Map<String, dynamic>> _mistakes;
  int _currentIndex = 0;
  bool _isAnswered = false;
  int? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _mistakes = List.from(ref.read(gamificationServiceProvider).mistakes);
  }

  void _onAnswer(int answer, Exercise exercise) {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswer = answer;
      _isAnswered = true;
    });

    final isCorrect = answer == exercise.correctAnswer;

    if (isCorrect) {
      ref.read(audioServiceProvider.notifier).playCorrect();
      
      // Remove from mistakes
      // We need to match the original map structure to remove it
      final currentMap = _mistakes[_currentIndex];
      ref.read(gamificationServiceProvider.notifier).clearMistake(currentMap);
      
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!mounted) return;
        setState(() {
          _mistakes.removeAt(_currentIndex);
          // Don't increment index, as list shifted
          // If empty, exit
          if (_mistakes.isEmpty) {
            Navigator.of(context).pop();
          } else if (_currentIndex >= _mistakes.length) {
            _currentIndex = 0;
          }
          _isAnswered = false;
          _selectedAnswer = null;
        });
      });
    } else {
      ref.read(audioServiceProvider.notifier).playWrong();
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!mounted) return;
        setState(() {
          _isAnswered = false;
          _selectedAnswer = null;
          // Move to next to prevent getting stuck
          if (_currentIndex < _mistakes.length - 1) {
             _currentIndex++;
          } else {
             _currentIndex = 0;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_mistakes.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Hata yok! Harikasın! 🎉', style: AppTextStyles.h2)),
      );
    }

    final mistakeData = _mistakes[_currentIndex];
    // Reconstruct Exercise object
    // Note: stored data is minimal, we need to regenerate choices or store them?
    // Storing them is better, but earlier we decided minimal storage.
    // Let's regenerate choices dynamically for now.
    final type = ExerciseType.values.firstWhere((e) => e.toString() == mistakeData['type']);
    final a = mistakeData['a'] as int;
    final b = mistakeData['b'] as int;
    final answer = mistakeData['answer'] as int;
    
    // Generate choices similar to generator
    final Set<int> choicesSet = {answer};
    int attempt = 0;
    while(choicesSet.length < 4 && attempt < 20) {
      choicesSet.add(answer + (attempt % 5 == 0 ? attempt : -attempt));
      attempt++;
    }
    // Fill with dummy if needed
    while(choicesSet.length < 4) {
      choicesSet.add(choicesSet.last + 1);
    }
    final choices = choicesSet.toList()..shuffle();

    final exercise = Exercise(
      type: type,
      operandA: a,
      operandB: b,
      correctAnswer: answer,
      choices: choices,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Hataları Gözden Geçir (${_mistakes.length})', style: AppTextStyles.h3),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Text(
                  exercise.questionText,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2,
                children: exercise.choices.map((choice) {
                   final isSelected = _selectedAnswer == choice;
                   Color color = Colors.white;
                   if (_isAnswered) {
                     if (choice == exercise.correctAnswer) color = AppColors.correct;
                     else if (isSelected) color = AppColors.wrong;
                   }
                   
                   return BouncyButton(
                     onPressed: () => _onAnswer(choice, exercise),
                     color: color,
                     child: Text(
                       '$choice', 
                       style: TextStyle(
                         fontSize: 24, 
                         fontWeight: FontWeight.bold,
                         color: _isAnswered && (choice == exercise.correctAnswer || isSelected) ? Colors.white : AppColors.textPrimary
                       ),
                     ),
                   );
                }).toList(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

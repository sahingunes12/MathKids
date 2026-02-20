import 'dart:async';
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
import '../providers/exercise_generator.dart';
import '../models/module.dart';
import '../models/exercise.dart';

class TimeAttackScreen extends ConsumerStatefulWidget {
  const TimeAttackScreen({super.key});

  @override
  ConsumerState<TimeAttackScreen> createState() => _TimeAttackScreenState();
}

class _TimeAttackScreenState extends ConsumerState<TimeAttackScreen> {
  final _generator = ExerciseGenerator();
  late Exercise _currentExercise;
  late ConfettiController _confettiController;
  
  // Game State
  int _score = 0;
  int _timeLeft = 60; // 60 seconds
  Timer? _timer;
  bool _isPlaying = false;
  bool _isGameOver = false;
  int? _selectedAnswer;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _startGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  void _startGame() {
    _timer?.cancel();
    setState(() {
      _score = 0;
      _timeLeft = 60;
      _isPlaying = true;
      _isGameOver = false;
      _generateNextQuestion();
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _endGame();
      }
    });
  }

  void _endGame() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _isGameOver = true;
    });
    
    // Calculate rewards (e.g., 1 star for every 5 points)
    final starsEarned = (_score / 5).floor();
    if (starsEarned > 0) {
      ref.read(gamificationServiceProvider.notifier).addStars(starsEarned);
      ref.read(audioServiceProvider.notifier).playVictory();
      _confettiController.play();
    }
  }

  void _generateNextQuestion() {
    // Randomly pick an operation type for variety
    final types = [ExerciseType.addition, ExerciseType.subtraction];
    final randomType = types[DateTime.now().millisecond % types.length];
    
    // Create a temporary module config for generation
    final config = LearningModule(
      id: 'time_attack',
      title: 'Time Attack',
      subtitle: '',
      icon: Icons.timer,
      color: Colors.red,
      exerciseType: randomType,
      maxNumber: 10 + (_score ~/ 2), // Increase difficulty as score increases
      starsPerCorrect: 0,
      requiredStars: 0,
    );
    
    setState(() {
      _currentExercise = _generator.generate(config);
      _selectedAnswer = null;
      _isAnswered = false;
    });
  }

  void _onAnswer(int answer) {
    if (_isAnswered || _isGameOver) return;
    
    setState(() {
      _selectedAnswer = answer;
      _isAnswered = true;
    });

    final isCorrect = answer == _currentExercise.correctAnswer;
    
    if (isCorrect) {
      ref.read(audioServiceProvider.notifier).playCorrect();
      setState(() => _score++);
      
      // Bonus time for every 5 correct answers?
      if (_score % 5 == 0) {
        setState(() => _timeLeft += 5);
      }
    } else {
      ref.read(audioServiceProvider.notifier).playWrong();
      // Record mistake for review later
      ref.read(gamificationServiceProvider.notifier).recordMistake({
        'type': _currentExercise.type.toString(),
        'a': _currentExercise.operandA,
        'b': _currentExercise.operandB,
        'answer': _currentExercise.correctAnswer,
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      // Penalty time?
      setState(() {
        if (_timeLeft > 2) _timeLeft -= 2;
      });
    }

    // Quick delay before next question
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && !_isGameOver) {
        _generateNextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isGameOver) {
      return _buildGameOverScreen();
    }

    return FeedbackOverlay(
      confettiController: _confettiController,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer_rounded, color: Colors.red),
              const SizedBox(width: 8),
              Text('$_timeLeft sn', style: AppTextStyles.h2.copyWith(color: _timeLeft < 10 ? Colors.red : AppColors.textPrimary)),
            ],
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                child: Text('Puan: $_score', style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Question Card
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Text(
                      _currentExercise.questionText,
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ).animate(key: ValueKey(_currentExercise)).scale(duration: 200.ms, curve: Curves.easeOutBack),
                ),
                
                const SizedBox(height: 32),
                
                // Choices
                Expanded(
                  flex: 3,
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: _currentExercise.choices.map((choice) {
                      return _ChoiceButton(
                        value: choice,
                        correctAnswer: _currentExercise.correctAnswer,
                        selectedAnswer: _selectedAnswer,
                        onTap: () => _onAnswer(choice),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverScreen() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Süre Bitti!', style: AppTextStyles.h1.copyWith(fontSize: 40)),
              const SizedBox(height: 24),
              Text('Toplam Puan', style: AppTextStyles.bodyMedium),
              Text('$_score', style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: AppColors.primary)),
              
              const SizedBox(height: 48),
              
              BouncyButton(
                onPressed: _startGame,
                child: const Text('Tekrar Oyna'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Çıkış', style: AppTextStyles.bodyMedium),
              ),
            ],
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
  final VoidCallback onTap;

  const _ChoiceButton({
    required this.value,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.onTap,
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
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$value',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

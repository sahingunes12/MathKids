import 'package:flutter/foundation.dart';
import '../models/exercise.dart';
import '../models/module.dart';
import 'exercise_generator.dart';

const int questionsPerQuiz = 5;

@immutable
class QuizState {
  final List<Exercise> exercises;
  final int currentIndex;
  final int correctCount;
  final int? selectedAnswer; // null = not answered yet
  final bool isFinished;

  const QuizState({
    required this.exercises,
    this.currentIndex = 0,
    this.correctCount = 0,
    this.selectedAnswer,
    this.isFinished = false,
  });

  Exercise get currentExercise => exercises[currentIndex];
  bool get isAnswered => selectedAnswer != null;
  bool get isLastQuestion => currentIndex >= exercises.length - 1;
  int get totalQuestions => exercises.length;

  QuizState copyWith({
    List<Exercise>? exercises,
    int? currentIndex,
    int? correctCount,
    int? selectedAnswer,
    bool? isFinished,
    bool clearSelectedAnswer = false,
  }) {
    return QuizState(
      exercises: exercises ?? this.exercises,
      currentIndex: currentIndex ?? this.currentIndex,
      correctCount: correctCount ?? this.correctCount,
      selectedAnswer: clearSelectedAnswer ? null : (selectedAnswer ?? this.selectedAnswer),
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

class QuizNotifier extends ChangeNotifier {
  QuizState _state;
  final LearningModule module;
  final _generator = ExerciseGenerator();

  QuizNotifier({required this.module})
      : _state = const QuizState(
          exercises: [],
        ) {
    _initQuiz();
  }

  QuizState get state => _state;

  void _initQuiz() {
    final exercises = List.generate(
      questionsPerQuiz,
      (_) => _generator.generate(module),
    );
    _state = QuizState(exercises: exercises);
    notifyListeners();
  }

  void answerQuestion(int answer) {
    if (_state.isAnswered) return;

    final isCorrect = answer == _state.currentExercise.correctAnswer;
    _state = _state.copyWith(
      selectedAnswer: answer,
      correctCount: isCorrect ? _state.correctCount + 1 : _state.correctCount,
    );
    notifyListeners();
  }

  void nextQuestion() {
    if (!_state.isAnswered) return;

    if (_state.isLastQuestion) {
      _state = _state.copyWith(isFinished: true);
    } else {
      _state = _state.copyWith(
        currentIndex: _state.currentIndex + 1,
        clearSelectedAnswer: true,
      );
    }
    notifyListeners();
  }

  void resetQuiz() {
    _initQuiz();
  }

  int get earnedStars => _state.correctCount * module.starsPerCorrect;
}

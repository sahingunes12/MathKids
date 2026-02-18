import 'dart:math';
import '../models/exercise.dart';
import '../models/module.dart';

class ExerciseGenerator {
  final Random _random = Random();

  Exercise generate(LearningModule module) {
    int a, b, answer;

    if (module.exerciseType == ExerciseType.addition) {
      a = _random.nextInt(module.maxNumber) + 1;
      b = _random.nextInt(module.maxNumber - a + 1) + 1;
      answer = a + b;
    } else if (module.exerciseType == ExerciseType.subtraction) {
      // Subtraction: ensure result >= 0
      a = _random.nextInt(module.maxNumber) + 1;
      b = _random.nextInt(a) + 1;
      answer = a - b;
    } else {
      // Multiplication
      // For kids, limiting multipliers to smaller set if maxNumber is small
      a = _random.nextInt(module.maxNumber ~/ 2) + 2;
      b = _random.nextInt(5) + 2; 
      answer = a * b;
    }

    final choices = _generateChoices(answer, module.maxNumber);

    return Exercise(
      type: module.exerciseType,
      operandA: a,
      operandB: b,
      correctAnswer: answer,
      choices: choices,
    );
  }

  List<int> _generateChoices(int correct, int maxNumber) {
    final Set<int> choiceSet = {correct};

    while (choiceSet.length < 4) {
      int wrong = correct + _random.nextInt(5) - 2;
      if (wrong < 0) wrong = 0;
      if (wrong > maxNumber * 2) wrong = maxNumber * 2;
      if (wrong != correct) choiceSet.add(wrong);
    }

    final list = choiceSet.toList()..shuffle(_random);
    return list;
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import '../models/exercise.dart';

class ExerciseGenerator {
  static Exercise generate(ExerciseType type, int maxNumber) {
    final random = Random();
    int num1, num2;

    switch (type) {
      case ExerciseType.addition:
        num1 = random.nextInt(maxNumber + 1);
        num2 = random.nextInt(maxNumber + 1 - num1);
        return Exercise(
          question: '$num1 + $num2',
          answer: (num1 + num2).toString(),
        );
      case ExerciseType.subtraction:
        num1 = random.nextInt(maxNumber + 1);
        num2 = random.nextInt(num1 + 1);
        return Exercise(
          question: '$num1 - $num2',
          answer: (num1 - num2).toString(),
        );
      case ExerciseType.multiplication:
        num1 = random.nextInt(10) + 1;
        num2 = random.nextInt(10) + 1;
        return Exercise(
          question: '$num1 × $num2',
          answer: (num1 * num2).toString(),
        );
      case ExerciseType.division:
        num2 = random.nextInt(9) + 1;
        final result = random.nextInt(10) + 1;
        num1 = num2 * result;
        return Exercise(
          question: '$num1 ÷ $num2',
          answer: result.toString(),
        );
      case ExerciseType.shapes:
        const shapes = ['Daire', 'Kare', 'Üçgen', 'Dikdörtgen'];
        final shape = shapes[random.nextInt(shapes.length)];
        return Exercise(
          question: 'Bu hangi şekil?', // Placeholder, will be replaced by image
          answer: shape,
          options: shapes,
        );
      case ExerciseType.counting:
        final count = random.nextInt(maxNumber) + 1;
        return Exercise(
          question: 'Kaç tane nesne var?', // Placeholder
          answer: count.toString(),
          options: List.generate(4, (i) => (count + i - 1).toString())..shuffle(),
        );
      default:
        throw UnimplementedError('Exercise type $type not implemented.');
    }
  }
}

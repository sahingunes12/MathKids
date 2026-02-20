import 'dart:math';
import 'package:flutter/material.dart';
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
    } else if (module.exerciseType == ExerciseType.multiplication) {
      // Multiplication
      // Adjusted to use maxNumber as the limit for the result or operands based on difficulty
      if (module.maxNumber <= 10) {
        // Easy mode: simple tables 1-10
        a = _random.nextInt(9) + 2; // 2 to 10
        b = _random.nextInt(9) + 2; // 2 to 10
      } else {
        // Hard mode: up to maxNumber
        a = _random.nextInt(8) + 3; // 3 to 10
        b = _random.nextInt(module.maxNumber - 5) + 5; // Mixed
      }
      answer = a * b;
    } else if (module.exerciseType == ExerciseType.counting) {
      // Counting 1-5
      final count = _random.nextInt(module.maxNumber) + 1;
      a = count; // a represents the count
      b = 0; // unused
      answer = count;
      
      // Question Icon (e.g. apple, star, etc)
      final icons = [Icons.star_rounded, Icons.favorite_rounded, Icons.pets_rounded, Icons.emoji_events_rounded, Icons.face_rounded];
      // We can pass this via Exercise optional params if we add them, 
      // or just determistically pick based on 'a' or random.
      // For now, let's update Exercise model in previous step to hold this?
      // Yes, we did.
    } else if (module.exerciseType == ExerciseType.shapes) {
       // Shapes: 0=Circle, 1=Square, 2=Triangle, 3=Star
       // Answer is the index of the shape to identify
       answer = _random.nextInt(4);
       a = 0; b=0; 
    } else {
      // Division
      // Ensure integer result: a = b * answer
      b = _random.nextInt(9) + 2; // Divisor 2 to 10
      answer = _random.nextInt(9) + 2; // Quotient 2 to 10
      a = b * answer; // Dividend
    }

    // Generate Choices
    final choices = <int>{};
    choices.add(answer);

    while (choices.length < 4) {
      if (module.exerciseType == ExerciseType.counting) {
         int wrong = _random.nextInt(module.maxNumber) + 1;
         if (wrong != answer) choices.add(wrong);
      } else if (module.exerciseType == ExerciseType.shapes) {
         int wrong = _random.nextInt(4);
         choices.add(wrong);
      } else {
        // ... existing logic for numbers
        final offset = _random.nextInt(10) - 5; // -5 to +5
        final wrong = answer + offset;
        if (wrong > 0 && wrong != answer) {
          choices.add(wrong);
        }
      }
    }

    return Exercise(
      type: module.exerciseType,
      operandA: a,
      operandB: b,
      correctAnswer: answer,
      choices: choices.toList()..shuffle(_random),
      // Random icon/color for counting/shapes
      questionIcon: module.exerciseType == ExerciseType.counting 
          ? [Icons.star_rounded, Icons.favorite_rounded, Icons.pets_rounded, Icons.emoji_nature_rounded][_random.nextInt(4)] 
          : null,
      questionColor: module.exerciseType == ExerciseType.counting || module.exerciseType == ExerciseType.shapes
          ? [Colors.redAccent, Colors.blueAccent, Colors.green, Colors.orange][_random.nextInt(4)]
          : null,
    );
  }

}

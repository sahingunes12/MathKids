import 'package:flutter/material.dart';

enum ExerciseType { addition, subtraction, multiplication, division, counting, shapes }

class Exercise {
  final ExerciseType type;
  final int operandA;
  final int operandB;
  final int correctAnswer;
  final List<int> choices;
  // Visual support
  final IconData? questionIcon;
  final Color? questionColor;

  const Exercise({
    required this.type,
    required this.operandA,
    required this.operandB,
    required this.correctAnswer,
    required this.choices,
    this.questionIcon,
    this.questionColor,
  });

  String get questionText {
    final op = switch (type) {
      ExerciseType.addition => '+',
      ExerciseType.subtraction => '−',
      ExerciseType.multiplication => '×',
      ExerciseType.division => '÷',
      ExerciseType.counting => '?', // Special handling in UI
      ExerciseType.shapes => '?',   // Special handling in UI
    };
    
    if (type == ExerciseType.counting) return 'Kaç tane var?';
    if (type == ExerciseType.shapes) return 'Bu hangi şekil?';
    
    return '$operandA $op $operandB = ?';
  }
}

enum ExerciseType { addition, subtraction, multiplication }

class Exercise {
  final ExerciseType type;
  final int operandA;
  final int operandB;
  final int correctAnswer;
  final List<int> choices;

  const Exercise({
    required this.type,
    required this.operandA,
    required this.operandB,
    required this.correctAnswer,
    required this.choices,
  });

  String get questionText {
    final op = switch (type) {
      ExerciseType.addition => '+',
      ExerciseType.subtraction => '−',
      ExerciseType.multiplication => '×',
    };
    return '$operandA $op $operandB = ?';
  }
}

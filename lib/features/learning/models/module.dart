import 'package:flutter/material.dart';
import 'exercise.dart';

class LearningModule {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final ExerciseType exerciseType;
  final int maxNumber;
  final int starsPerCorrect;
  final int requiredStars;

  const LearningModule({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.exerciseType,
    required this.maxNumber,
    this.starsPerCorrect = 1,
    this.requiredStars = 0,
  });
}

final List<LearningModule> allModules = [
  const LearningModule(
    id: 'addition_easy',
    title: 'Modul 1: Zahlen',
    subtitle: 'Addition bis 10',
    icon: Icons.add_circle_rounded,
    color: Color(0xFF6EC6FF),
    exerciseType: ExerciseType.addition,
    maxNumber: 10,
    starsPerCorrect: 1,
    requiredStars: 0,
  ),
  const LearningModule(
    id: 'subtraction_easy',
    title: 'Modul 2: Minus',
    subtitle: 'Subtraktion bis 10',
    icon: Icons.remove_circle_rounded,
    color: Color(0xFFFF8A65),
    exerciseType: ExerciseType.subtraction,
    maxNumber: 10,
    starsPerCorrect: 1,
    requiredStars: 10,
  ),
  const LearningModule(
    id: 'addition_hard',
    title: 'Modul 3: Große Zahlen',
    subtitle: 'Addition bis 20',
    icon: Icons.add_box_rounded,
    color: Color(0xFF81C784),
    exerciseType: ExerciseType.addition,
    maxNumber: 20,
    starsPerCorrect: 2,
    requiredStars: 30,
  ),
  const LearningModule(
    id: 'multiplication_easy',
    title: 'Modul 4: Malnehmen',
    subtitle: 'Einmaleins Grundlagen',
    icon: Icons.close_rounded,
    color: Colors.purple,
    exerciseType: ExerciseType.multiplication,
    maxNumber: 10,
    starsPerCorrect: 3,
    requiredStars: 50,
  ),
  const LearningModule(
    id: 'multiplication_hard',
    title: 'Modul 5: Profi-Mal',
    subtitle: 'Schweres Einmaleins',
    icon: Icons.grid_view_rounded,
    color: Colors.indigo,
    exerciseType: ExerciseType.multiplication,
    maxNumber: 20,
    starsPerCorrect: 5,
    requiredStars: 80,
  ),
];

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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
    title: 'Modül 1: Sayılar',
    subtitle: '10\'a kadar Toplama',
    icon: PhosphorIconsRegular.pencilLine,
    color: Color(0xFFFFB74D), // Orange
    exerciseType: ExerciseType.addition,
    maxNumber: 10,
    starsPerCorrect: 1,
    requiredStars: 0,
  ),
  const LearningModule(
    id: 'subtraction_easy',
    title: 'Modül 2: Çıkarma',
    subtitle: '10\'a kadar Çıkarma',
    icon: PhosphorIconsRegular.minus,
    color: Color(0xFFFF5252), // Red Accent
    exerciseType: ExerciseType.subtraction,
  maxNumber: 10,
    starsPerCorrect: 1,
    requiredStars: 10,
  ),
  const LearningModule(
    id: 'addition_hard',
    title: 'Modül 3: Büyük Sayılar',
    subtitle: '20\'ye kadar Toplama',
    icon: PhosphorIconsRegular.plus,
    color: Color(0xFF66BB6A), // Green
    exerciseType: ExerciseType.addition,
    maxNumber: 20,
    starsPerCorrect: 2,
    requiredStars: 30,
  ),
  const LearningModule(
    id: 'multiplication_easy',
    title: 'Modül 4: Çarpma',
    subtitle: 'Çarpım Tablosu (Kolay)',
    icon: PhosphorIconsRegular.x,
    color: Color(0xFFE040FB), // Purple Accent
    exerciseType: ExerciseType.multiplication,
    maxNumber: 10,
    starsPerCorrect: 3,
    requiredStars: 50,
  ),
  const LearningModule(
    id: 'division_easy',
    title: 'Modül 5: Bölme',
    subtitle: 'Bölme İşlemi (Kolay)',
    icon: PhosphorIconsRegular.divide,
    color: Color(0xFFFF4081), // Pink Accent
    exerciseType: ExerciseType.division,
    maxNumber: 20,
    starsPerCorrect: 4,
    requiredStars: 70,
  ),
  // Kindergarten Modules
  const LearningModule(
    id: 'counting_easy',
    title: 'Anaokulu: Sayma',
    subtitle: 'Kaç tane var?',
    icon: PhosphorIconsRegular.numberOne,
    color: Color(0xFF009688), // Teal
    exerciseType: ExerciseType.counting,
    maxNumber: 5,
    starsPerCorrect: 2,
    requiredStars: 0,
  ),
  const LearningModule(
    id: 'shapes_basic',
    title: 'Anaokulu: Şekiller',
    subtitle: 'Şekilleri Tanı',
    icon: PhosphorIconsRegular.shapes,
    color: Color(0xFFFFAB00), // Amber Accent
    exerciseType: ExerciseType.shapes,
    maxNumber: 4,
    starsPerCorrect: 2,
    requiredStars: 0,
  ),
  const LearningModule(
    id: 'multiplication_hard',
    title: 'Modül 6: Usta Çarpma',
    subtitle: 'Çarpım Tablosu (Zor)',
    icon: PhosphorIconsFill.xCircle,
    color: Color(0xFF3D5AFE), // Indigo Accent
    exerciseType: ExerciseType.multiplication,
    maxNumber: 20,
    starsPerCorrect: 5,
    requiredStars: 100,
  ),
];

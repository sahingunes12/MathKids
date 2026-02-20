import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../../core/widgets/bouncy_button.dart';
import '../../../core/widgets/cloud_card.dart';
import '../../gamification/models/exercise.dart';
import '../../gamification/providers/gamification_service.dart';

class MistakeReviewScreen extends ConsumerStatefulWidget {
  const MistakeReviewScreen({super.key});

  @override
  ConsumerState<MistakeReviewScreen> createState() => _MistakeReviewScreenState();
}

class _MistakeReviewScreenState extends ConsumerState<MistakeReviewScreen> {
  PageController? _pageController;
  List<Exercise> _mistakes = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _mistakes = ref.read(gamificationServiceProvider.notifier).getMistakes();
    if (_mistakes.isNotEmpty) {
      _pageController = PageController();
    } else {
      // Handle case with no mistakes - perhaps show a message and pop.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('İncelenecek hata bulunmuyor!')),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void _onAnswer(String answer) {
    final isCorrect = _mistakes[_currentIndex].answer == answer;
    if (isCorrect) {
      ref.read(gamificationServiceProvider.notifier).clearMistake(_mistakes[_currentIndex].id);
      _showFeedback(true);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (_currentIndex == _mistakes.length - 1) {
          Navigator.of(context).pop();
        } else {
          _pageController?.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
      });
    } else {
      _showFeedback(false);
    }
  }

  void _showFeedback(bool isCorrect) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Harika! Bu sefer doğru.' : 'Tekrar dene!'),
        backgroundColor: isCorrect ? AppColors.correct : AppColors.wrong,
        duration: const Duration(milliseconds: 700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_mistakes.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Hataları Gözden Geçir', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _mistakes.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final exercise = _mistakes[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(exercise.question, style: AppTextStyles.h1.copyWith(fontSize: 48)),
                    const SizedBox(height: 48),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 16,
                        children: exercise.options.map((option) {
                          return BouncyButton(
                            onPressed: () => _onAnswer(option),
                            child: CloudCard(
                              child: Text(option, style: AppTextStyles.h2),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_currentIndex + 1} / ${_mistakes.length}',
                  style: AppTextStyles.bodyMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

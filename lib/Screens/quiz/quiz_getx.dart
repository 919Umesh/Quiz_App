import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'quiz_repo.dart';
import '../../Models/quiz_model.dart';

class GetQuizController extends GetxController {
  final isLoading = true.obs;
  final quizList = <QuestionModel>[].obs;
  final currentQuestionIndex = 0.obs;
  final selectedOptionIndex = (-1).obs;
  final showAnswer = false.obs;
  final PageController pageController = PageController();
  final score = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuizList();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Future<void> fetchQuizList() async {
    try {
      isLoading.value = true;
      final QuestionsResponseModel response = await getQuizRepository.getQuiz();

      if (response.status == 200) {
        quizList.assignAll(response.questions);
        debugPrint('Fetched ${quizList.length} questions');
      } else {
        Get.snackbar(
          'Error',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error fetching quiz: $e");
      Get.snackbar(
        'Error',
        'Failed to load questions. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectOption(int index) {
    if (!showAnswer.value) {
      selectedOptionIndex.value = index;
    }
  }

  void checkAnswer() {
    if (selectedOptionIndex.value != -1) {
      showAnswer.value = true;
      final currentQuestion = quizList[currentQuestionIndex.value];
      final selectedOption = currentQuestion.options[selectedOptionIndex.value];
      if (selectedOption.isCorrect) {
        score.value++;
      }
    }
  }

  void resetSelectedOption() {
    selectedOptionIndex.value = -1;
    showAnswer.value = false;
    debugPrint('Reset selected option and answer visibility');
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < quizList.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      currentQuestionIndex.value++;
      resetSelectedOption();
    }
  }

  String getScorePercentage() {
    if (quizList.isEmpty) return '0%';
    return '${((score.value / quizList.length) * 100).toStringAsFixed(1)}%';
  }

  void restartQuiz() {
    currentQuestionIndex.value = 0;
    score.value = 0;
    resetSelectedOption();
    pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

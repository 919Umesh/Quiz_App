import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quiz_getx.dart';
import '../../Models/quiz_model.dart';

class GetQuizPage extends GetView<GetQuizController> {
  const GetQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title:  Text(
          'Quiz',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        actions: [
          Obx(() => Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Score: ${controller.getScorePercentage()}',
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          )),
        ],
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            ),
          );
        }

        if (controller.quizList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No questions available',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchQuizList,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return PageView.builder(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.quizList.length,
          onPageChanged: (index) {
            controller.currentQuestionIndex.value = index;
            controller.resetSelectedOption();
          },
          itemBuilder: (context, index) {
            final question = controller.quizList[index];
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: (index + 1) / controller.quizList.length,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Question ${index + 1}/${controller.quizList.length}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        question.question,
                       style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,

                       ),
                        // style: const TextStyle(
                        //   fontSize: 18,
                        //   fontWeight: FontWeight.bold,
                        //   color: Colors.black87,
                        // ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ...question.options.asMap().entries.map((entry) {
                      return Obx(() => _buildOptionItem(entry.key, entry.value, index));
                    }),
                    const SizedBox(height: 20),
                    Obx(() {
                      if (!controller.showAnswer.value) {
                        return _buildCheckAnswerButton();
                      } else if (index < controller.quizList.length - 1) {
                        return _buildNextButton();
                      } else {
                        return _buildFinishButton();
                      }
                    }),

                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildOptionItem(int index, OptionModel option, int questionIndex) {
    final isSelected = controller.selectedOptionIndex.value == index &&
        controller.currentQuestionIndex.value == questionIndex;
    final showResult = controller.showAnswer.value &&
        controller.currentQuestionIndex.value == questionIndex;

    Color getOptionColor() {
      if (!isSelected && !showResult) return Colors.white;
      if (showResult && option.isCorrect) return Colors.green.shade50;
      if (showResult && isSelected && !option.isCorrect) return Colors.red.shade50;
      return Colors.deepPurple.shade50;
    }

    Color getBorderColor() {
      if (!isSelected && !showResult) return Colors.grey.shade300;
      if (showResult && option.isCorrect) return Colors.green;
      if (showResult && isSelected && !option.isCorrect) return Colors.red;
      return Colors.deepPurple;
    }

    return GestureDetector(
      onTap: () => controller.selectOption(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: getOptionColor(),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: getBorderColor(),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option.text,
                style: TextStyle(
                  fontSize: 16,
                  color: showResult && option.isCorrect
                      ? Colors.green
                      : Colors.black87,
                  fontWeight: isSelected || (showResult && option.isCorrect)
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            if (showResult && option.isCorrect)
              const Icon(Icons.check_circle, color: Colors.green)
            else if (showResult && isSelected && !option.isCorrect)
              const Icon(Icons.cancel, color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckAnswerButton() {
    return GestureDetector(
      onTap: controller.selectedOptionIndex.value != -1
          ? () => controller.checkAnswer()
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: controller.selectedOptionIndex.value != -1
              ? Colors.deepPurple
              : Colors.grey,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Check Answer',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(
                controller.selectedOptionIndex.value != -1 ? 1 : 0.7,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: () => controller.nextQuestion(),
      child: Container(
        width: double.infinity, // Full width
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: controller.selectedOptionIndex.value != -1
              ? Colors.deepPurple
              : Colors.grey, // Disabled state color
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Next Question',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(
                controller.selectedOptionIndex.value != -1 ? 1 : 0.7,
              ), // Adjust text opacity based on enabled/disabled
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFinishButton() {
    return GestureDetector(
      onTap: () => controller.restartQuiz(),
      child: Container(
        width: double.infinity, // Full width
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: controller.selectedOptionIndex.value != -1
              ? Colors.deepPurple
              : Colors.grey, // Disabled state color
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Finish Quiz',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(
                controller.selectedOptionIndex.value != -1 ? 1 : 0.7,
              ), // Adjust text opacity based on enabled/disabled
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:club_app/controllers/loading_controller.dart';
import 'package:club_app/models/feedback_model.dart';
import 'package:club_app/widgets/app_widgets/rating_bar.dart';
import 'package:club_app/widgets/dialogue_widgets/suggestion_dialogue.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/colors.dart';
import '../controllers/feedback_controller.dart';
import '../widgets/loading_widget.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key, required this.feedbackForm});

  final FeedbackModel feedbackForm;

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final pageController = PageController();
  final feedbackController = Get.put(FeedbackController());
  final loadingController = Get.put(LoadingController());

  var pageIndex = 0;
  List<int> sliderValues = [];
  List<String> ratingTexts = [];
  List<Color> ratingTextColors = [];

  @override
  void initState() {
    super.initState();
    sliderValues = List.filled(widget.feedbackForm.questions.length, 0);
    ratingTexts =
        List.filled(widget.feedbackForm.questions.length, 'Pull the slider');
    ratingTextColors = List.filled(widget.feedbackForm.questions.length,
        Theme.of(Get.context!).primaryColor);
  }

  void uploadFeedback(context, suggestionText) async {
    loadingController.toggleLoading();
    final result = await feedbackController.uploadFeedback(
        widget.feedbackForm.id, sliderValues, suggestionText);
    loadingController.toggleLoading();
    if (result['status'] == 'error') {
      CustomSnackBar.show(context,
          message: result['message'], color: Colors.red);
    } else {
      CustomSnackBar.show(context,
          message: result['message'], color: Colors.green);
    }
    Navigator.of(context).pop();
  }

  void changeRating(int index, int value) {
    setState(() {
      sliderValues[index] = value;
      switch (value.toInt()) {
        case 0:
          ratingTexts[index] = 'Pull the slider';
          ratingTextColors[index] = Theme.of(Get.context!).primaryColor;
          break;
        case 1:
          ratingTexts[index] = 'Very bad';
          ratingTextColors[index] = Colors.red;
          break;
        case 2:
          ratingTexts[index] = 'Bad';
          ratingTextColors[index] = Colors.deepOrangeAccent;
          break;
        case 3:
          ratingTexts[index] = 'Average';
          ratingTextColors[index] = Colors.orange;
          break;
        case 4:
          ratingTexts[index] = 'Good';
          ratingTextColors[index] = Colors.amber;
          break;
        case 5:
          ratingTexts[index] = 'Excellent';
          ratingTextColors[index] = Colors.green;
          break;
        default:
          ratingTexts[index] = 'Pull the slider';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              title: const Text('Feedback'),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonWidget(
                    onPressed: () {
                      if (sliderValues.any((value) => value == 0)) {
                        CustomSnackBar.show(context,
                            message: 'Please rate all questions', color: Colors.red);
                        return;
                      }
                      showDialog(
                          context: context,
                          builder: (dialogueContext) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SuggestionDialogue(
                                onSubmit: (suggestionText) {
                                  uploadFeedback(context, suggestionText);
                                },
                              ),
                            );
                          });
                      // uploadFeedback(context);
                    },
                    buttonText: 'Submit',
                    isNegative: false,
                    isColorInverted: true,
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.feedbackForm.eventName,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widget.feedbackForm.questions
                      .asMap()
                      .map((index, question) => MapEntry(
                          index,
                          InkWell(
                            customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            onTap: () {
                              pageController.animateToPage(index,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease);
                              setState(() {
                                pageIndex = index;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: pageIndex == index
                                    ? Theme.of(context).primaryColor
                                    : currentColors.oppositeColor
                                        .withOpacity(0.1),
                              ),
                              height: 10,
                              width: MediaQuery.of(context).size.width /
                                  (widget.feedbackForm.questions.length + 2),
                            ),
                          )))
                      .values
                      .toList(),
                ),
                Expanded(
                  child: PageView.builder(
                    onPageChanged: (index) {
                      setState(() {
                        pageIndex = index;
                      });
                    },
                    controller: pageController,
                    itemCount: widget.feedbackForm.questions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Question ${pageIndex + 1}',
                                    style: TextStyle(
                                        color: currentColors.oppositeColor
                                            .withOpacity(0.8),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    widget
                                        .feedbackForm.questions[index].question,
                                    style: TextStyle(
                                        color: currentColors.oppositeColor
                                            .withOpacity(0.8),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))),
                          ),
                          const SizedBox(height: 170),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(ratingTexts[index],
                                    style: TextStyle(
                                        color: ratingTextColors[index],
                                        fontSize: 40,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 30),
                                RatingBar(
                                  onRatingChanged: (value) {
                                    changeRating(index, value.toInt());
                                  },
                                  initialRating: sliderValues[index].toDouble(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            )),
        Obx(() {
          return Container(
            child: loadingController.isLoading.value ? LoadingWidget() : null,
          );
        }),
      ],
    );
  }
}

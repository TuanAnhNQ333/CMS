import 'package:club_app/models/feedback_model.dart';
import 'package:club_app/widgets/app_widgets/rating_stat_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/feedback_controller.dart';

class FeedbackResponsePage extends StatelessWidget {
  FeedbackResponsePage({super.key, required this.feedbackId});

  final String feedbackId;

  final feedbackController = Get.put(FeedbackController());

  FeedbackModel get feedback => feedbackController.feedbackList
      .where((feedback) => feedback.id == feedbackId)
      .first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Response'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    feedback.eventName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                )),
            feedback.comments.isEmpty ? Container() :
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  maxHeight: 250,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Suggestions',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: feedback.comments
                              .map((suggestion) => Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(suggestion),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: feedback.questions
                  .map((question) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  question.question,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text('Ratings',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                RatingStatWidget(
                                  ratings: question.rating,
                                )
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:club_app/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/feedback_controller.dart';
import '../controllers/loading_controller.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/loading_widget.dart';

class CreateFeedbackPage extends StatefulWidget {
  const CreateFeedbackPage(
      {super.key, required this.eventId, required this.clubId});

  final String eventId;
  final String clubId;

  @override
  State<CreateFeedbackPage> createState() => _CreateFeedbackPageState();
}

class _CreateFeedbackPageState extends State<CreateFeedbackPage> {
  List<Widget> questionList = [];

  List<TextEditingController> questionControllers = [];
  final feedbackController = Get.put(FeedbackController());
  final loadingController = Get.put(LoadingController());

  Future<void> submitForm(context) async {
    loadingController.toggleLoading();
    if(questionControllers.any((element) => element.text.isEmpty)){
      CustomSnackBar.show(context,
          message: 'Please fill all the fields', color: Colors.red);
      loadingController.toggleLoading();
      return;
    }
    final result = await feedbackController.createFeedbackForm(widget.eventId,
        widget.clubId, questionControllers.map((e) => e.text).toList());
    loadingController.toggleLoading();
    result['status'] == 'error'
        ? CustomSnackBar.show(context,
        message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
        message: result['message'], color: Colors.green);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Create Feedback'),
            actions: [
              const SizedBox(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonWidget(
                    onPressed: () {
                      submitForm(context);
                    }, buttonText: 'Submit',
                    isColorInverted: true,
                    isNegative: false),
              )
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonWidget(
                        onPressed: () {
                          setState(() {
                            var questionController = TextEditingController();
                            questionControllers.add(questionController);
                            questionList.add(Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.4)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 5),
                                  child: TextFormField(
                                    maxLines: 1,
                                    controller: questionController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ));
                          });
                        },
                        preceedingIcon: Icons.add,
                        buttonText: 'Add Question',
                        isNegative: false),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: questionList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Question ${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                      child: Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          questionList.removeAt(index);
                                          questionControllers[index].dispose();
                                          questionControllers.removeAt(index);
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(3.0),
                                        child: Icon(
                                          size: 20,
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            questionList[index],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        Obx(() {
          return Container(
            child: loadingController.isLoading.value ? LoadingWidget() : null,
          );
        }),
      ],
    );
  }
}

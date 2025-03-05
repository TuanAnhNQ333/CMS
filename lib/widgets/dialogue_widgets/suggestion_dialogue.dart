import 'package:club_app/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class SuggestionDialogue extends StatelessWidget {
  SuggestionDialogue({super.key, required this.onSubmit});

  final Function(String suggestionText) onSubmit;

  final TextEditingController suggestionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Suggestions",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border:
                          Border.all(color: Theme.of(context).primaryColor.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 5),
                          child: TextFormField(
                            controller: suggestionController,
                            // initialValue: club.description,
                            maxLines: 5,
                            minLines: 2,
                            decoration: const InputDecoration(
                              hintText: 'Write your suggestions here (*optional)',
                              border: InputBorder.none,
                              // hintText: '${club.name}',
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ButtonWidget(onPressed: (){
                        onSubmit(suggestionController.text);
                        Navigator.pop(context);
                      }, buttonText: 'Submit', isNegative: false)
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

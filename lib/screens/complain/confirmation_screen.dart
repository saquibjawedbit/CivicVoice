import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/images/footer.png",
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo-1.png"),
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 191, 245, 251),
                        border: Border(
                          left: BorderSide(
                            color: Color.fromARGB(126, 56, 31, 251),
                            width: 1.8,
                          ),
                          right: BorderSide(
                            color: Color.fromARGB(126, 56, 31, 251),
                            width: 1.8,
                          ),
                          bottom: BorderSide(
                            color: Color.fromARGB(126, 56, 31, 251),
                            width: 1.8,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(31, 0, 0, 0),
                            offset: Offset(0, 5),
                          )
                        ]),
                    padding:
                        const EdgeInsets.symmetric(vertical: 36, horizontal: 8),
                    child: Column(
                      children: [
                        _blueText(context,
                            "You’re Complaint has been successfully filled !"),
                        const SizedBox(
                          height: 12,
                        ),
                        _blueText(context,
                            "We will notify you as soon as there is any update  !"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Text _blueText(BuildContext context, String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 24,
      ),
    );
  }
}

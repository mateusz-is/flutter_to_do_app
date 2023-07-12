import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: (Text(
          'Wykonał Mateusz Tobiasz. Email: mateusz.tobiasz@wsei.microsoft.edu.pl',
          overflow: TextOverflow.clip,
        )),
      ),
    );
  }
}

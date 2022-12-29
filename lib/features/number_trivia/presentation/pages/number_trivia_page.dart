import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: const [
            SizedBox(
              height: 10,
            ),
            // Top Half
            NumberTriviaDisplay(),
            SizedBox(
              height: 20,
            ),
            // Bottom Half
            NumberTriviaForm(),
          ],
        ),
      ),
    );
  }
}

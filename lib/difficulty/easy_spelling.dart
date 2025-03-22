import 'dart:math';

import 'package:flutter/material.dart';

class EasySpelling extends StatefulWidget {
  const EasySpelling({super.key});

  @override
  _EasySpellingState createState() => _EasySpellingState();
}

class _EasySpellingState extends State<EasySpelling> {
  int _currentSlideIndex = 0;
  bool _isNextPressed = false;
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _questions = List.generate(10, (index) => _generateQuestion());

  static Map<String, dynamic> _generateQuestion() {
    final words = ['cat', 'dog', 'sun', 'bat', 'rat', 'hat', 'pen', 'cup', 'box', 'car'];
    final word = words[Random().nextInt(words.length)];
    final shuffledWord = String.fromCharCodes(word.runes.toList()..shuffle());
    return {'question': 'Arrange the letters to form the word: "$shuffledWord"', 'correctAnswer': word};
  }

  final Map<int, String> _userAnswers = {};

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentSlideIndex];
    final progress = (_currentSlideIndex + 1) / (_questions.length + 1);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Image.asset('assets/images/back.png', width: 30, height: 30),
        ),
        title: const Text('Easy Spelling'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Arrange the Word',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        question['question'],
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _textController,
                        decoration: const InputDecoration(hintText: 'Enter your word here'),
                        textCapitalization: TextCapitalization.characters,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _userAnswers[_currentSlideIndex] = _textController.text;
                            if (_currentSlideIndex < _questions.length - 1) {
                              _currentSlideIndex++;
                              _textController.clear();
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ResultPage(userAnswers: _userAnswers, questions: _questions),
                                ),
                              );
                            }
                          });
                        },
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final Map<int, String> userAnswers;
  final List<Map<String, dynamic>> questions;

  const ResultPage({required this.userAnswers, required this.questions, super.key});

  @override
  Widget build(BuildContext context) {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i]['correctAnswer']) {
        score++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Image.asset('assets/images/back.png', width: 30, height: 30),
        ),
        title: const Text('Results'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              LinearProgressIndicator(
                value: 1.0, // Full progress for the results page
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your answers:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...questions.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> question = entry.value;
                      bool isCorrect = userAnswers[index] == question['correctAnswer'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          '${index + 1}. ${userAnswers[index]} ${isCorrect ? '' : '❌  → Correct: ${question['correctAnswer']} ✅'}',
                          style: TextStyle(
                            color: isCorrect ? Colors.black : Colors.red,
                            fontWeight: isCorrect ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    Text(
                      'Score: $score/${questions.length}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Back'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle view score action
                          },
                          child: const Text('View Score'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          child: const Text('Home'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

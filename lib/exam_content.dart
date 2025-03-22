import 'package:flutter/material.dart';

class ExamContent extends StatefulWidget {
  const ExamContent({super.key});

  @override
  _ExamContentState createState() => _ExamContentState();
}

class _ExamContentState extends State<ExamContent> {
  int _currentQuestionIndex = 0;
  bool _isNextPressed = false;
  bool _isPreviousPressed = false;
  bool _isStartPressed = false;
  bool _showIntro = true;
  final Map<int, String> _userAnswers = {};

  final List<Map<String, dynamic>> _questions = [
    // Reading Questions
    {
      'category': 'Story',
      'question': 'What color was the princess\'s dress?',
      'answers': ['Pink', 'Blue', 'Green', 'Yellow'],
      'correctAnswer': 'Pink',
    },
    {
      'category': 'Story',
      'question': 'What did the prince use to defeat the dragon?',
      'answers': ['Sword', 'Shield', 'Magic', 'Bow'],
      'correctAnswer': 'Sword',
    },
    {
      'category': 'Story',
      'question': 'What was the name of the magical kingdom?',
      'answers': ['Fantasia', 'Wonderland', 'Narnia', 'Atlantis'],
      'correctAnswer': 'Fantasia',
    },
    // Grammar Questions
    {
      'category': 'Grammar',
      'question': 'What is the plural form of "child"?',
      'answers': ['Children', 'Childs', 'Childes', 'Child'],
      'correctAnswer': 'Children',
    },
    {
      'category': 'Grammar',
      'question': 'Which word is an adjective?',
      'answers': ['Quick', 'Run', 'Dog', 'Play'],
      'correctAnswer': 'Quick',
    },
    {
      'category': 'Grammar',
      'question': 'What is the past tense of "go"?',
      'answers': ['Went', 'Go', 'Gone', 'Going'],
      'correctAnswer': 'Went',
    },
    // Spelling Questions
    {
      'category': 'Spelling',
      'question': 'Arrange the letters to form the word: "TAC"',
      'answers': ['Cat', 'Act', 'Tac', 'Tca'],
      'correctAnswer': 'Cat',
    },
    {
      'category': 'Spelling',
      'question': 'Arrange the letters to form the word: "GOD"',
      'answers': ['Dog', 'God', 'Ogd', 'Dgo'],
      'correctAnswer': 'Dog',
    },
    {
      'category': 'Spelling',
      'question': 'Arrange the letters to form the word: "NUF"',
      'answers': ['Fun', 'Nuf', 'Unf', 'Fnu'],
      'correctAnswer': 'Fun',
    },
    // Additional Questions
    {
      'category': 'Grammar',
      'question': 'What is the plural form of "mouse"?',
      'answers': ['Mice', 'Mouses', 'Mouse', 'Mices'],
      'correctAnswer': 'Mice',
    },
    {
      'category': 'Grammar',
      'question': 'Which word is an adjective?',
      'answers': ['Quick', 'Run', 'Dog', 'Play'],
      'correctAnswer': 'Quick',
    },
    {
      'category': 'Grammar',
      'question': 'What is the past tense of "go"?',
      'answers': ['Went', 'Go', 'Gone', 'Going'],
      'correctAnswer': 'Went',
    },
    {
      'category': 'Spelling',
      'question': 'Arrange the letters to form the word: "RAT"',
      'answers': ['Art', 'Rat', 'Tar', 'Rta'],
      'correctAnswer': 'Rat',
    },
    {
      'category': 'Spelling',
      'question': 'Arrange the letters to form the word: "HAT"',
      'answers': ['Hat', 'Tah', 'Aht', 'Hta'],
      'correctAnswer': 'Hat',
    },
  ];

  void _startExam() {
    setState(() {
      _showIntro = false;
    });
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit'),
          content: const Text('Do you want to exit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), // Exit
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: _showExitConfirmationDialog,
          child: Image.asset('assets/images/back.png', width: 30, height: 30),
        ),
        title: const Text('Exam'),
      ),
      body: Stack(
        children: [
          if (_showIntro)
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/exam_intro.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTapDown: (_) {
                          setState(() {
                            _isStartPressed = true;
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            _isStartPressed = false;
                          });
                          _startExam();
                        },
                        onTapCancel: () {
                          setState(() {
                            _isStartPressed = false;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          width: _isStartPressed ? 110 : 130,
                          height: _isStartPressed ? 50 : 65,
                          child: Image.asset(
                            'assets/images/start.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (question['category'] == 'Story') ...[
                        const Text(
                          'Story for Reference:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Once upon a time in a magical kingdom called Fantasia, there lived a brave prince and a beautiful princess. The princess wore a pink dress and loved to explore the enchanted forest. One day, a fierce dragon appeared and threatened the kingdom. The brave prince, armed with a magical sword, fought the dragon and saved the kingdom. The people of Fantasia celebrated their victory and lived happily ever after.',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                      ],
                      Text(
                        question['question'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...question['answers'].map<Widget>((answer) {
                        return RadioListTile<String>(
                          title: Text(answer),
                          value: answer,
                          groupValue: _userAnswers[_currentQuestionIndex],
                          onChanged: (value) {
                            setState(() {
                              _userAnswers[_currentQuestionIndex] = value!;
                            });
                          },
                        );
                      }).toList(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          if (!_showIntro)
            Positioned(
              bottom: 50,
              left: 20,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      _isPreviousPressed = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _isPreviousPressed = false;
                    });
                    if (_currentQuestionIndex > 0) {
                      setState(() {
                        _currentQuestionIndex--; // Navigate to the previous question
                      });
                    }
                  },
                  onTapCancel: () {
                    setState(() {
                      _isPreviousPressed = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: _isPreviousPressed ? 70 : 80,
                    height: _isPreviousPressed ? 45 : 50,
                    child: Image.asset(
                      'assets/images/previous.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          if (!_showIntro)
            Positioned(
              bottom: 50,
              right: 20,
              child: Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      _isNextPressed = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _isNextPressed = false;
                    });
                    if (_currentQuestionIndex < _questions.length - 1) {
                      setState(() {
                        _currentQuestionIndex++;
                      });
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ResultPage(score: _userAnswers.values.where((answer) => answer == _questions[_userAnswers.keys.firstWhere((key) => _userAnswers[key] == answer)]['correctAnswer']).length, totalQuestions: _questions.length),
                        ),
                      );
                    }
                  },
                  onTapCancel: () {
                    setState(() {
                      _isNextPressed = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: _isNextPressed ? 70 : 80,
                    height: _isNextPressed ? 45 : 50,
                    child: Image.asset(
                      'assets/images/next.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ResultPage extends StatefulWidget {
  final int score;
  final int totalQuestions;

  const ResultPage({required this.score, required this.totalQuestions, super.key});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with TickerProviderStateMixin {
  late List<String> stars;
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();

    stars = widget.score == 14
        ? ['assets/images/star1.png', 'assets/images/star2.png', 'assets/images/star3.png']
        : (widget.score >= 5
            ? ['assets/images/star1.png', 'assets/images/star2.png']
            : ['assets/images/star1.png']);

    _controllers = List.generate(
      stars.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );

    _animateStars();
  }

  void _animateStars() async {
    for (var controller in _controllers) {
      await Future.delayed(const Duration(milliseconds: 300));
      controller.forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your Score:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${widget.score}/${widget.totalQuestions}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(stars.length, (index) {
                return ScaleTransition(
                  scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                    CurvedAnimation(parent: _controllers[index], curve: Curves.easeOut),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Image.asset(
                      stars[index],
                      width: 70,
                      height: 70,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Home'),
            ),
          ],
        ),
      ),
    );
  }
}

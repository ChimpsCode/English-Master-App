import 'package:flutter/material.dart';

class GrammarContent extends StatefulWidget {
  const GrammarContent({super.key});

  @override
  _GrammarContentState createState() => _GrammarContentState();
}

class _GrammarContentState extends State<GrammarContent> {
  bool _isContinuePressed = false;
  bool _isStartPressed = false;
  int _currentQuestionIndex = 0;
  bool _isNextPressed = false;
  bool _showIntro = true;
  bool _showGrammarBasics = false;
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Which word is a noun?',
      'answers': ['Dog', 'Run', 'Happy', 'Quickly'],
      'correctAnswer': 'Dog',
    },
    {
      'question': 'Which word is a verb?',
      'answers': ['Jump', 'Cat', 'Big', 'Red'],
      'correctAnswer': 'Jump',
    },
    {
      'question': 'Which word is an adjective?',
      'answers': ['Happy', 'Eat', 'School', 'Box'],
      'correctAnswer': 'Happy',
    },
    {
      'question': 'What is the plural of "cat"?',
      'answers': ['Cats', 'Cat', 'Cates', 'Cat\'s'],
      'correctAnswer': 'Cats',
    },
    {
      'question': 'What is the plural of "box"?',
      'answers': ['Boxes', 'Box', 'Boxs', 'Box\'s'],
      'correctAnswer': 'Boxes',
    },
  ];
  final Map<int, String> _userAnswers = {};

  void _showGrammarBasicsAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/instructions.png'),
              const SizedBox(height: 5),
              StatefulBuilder(
                builder: (context, setState) {
                  return GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isStartPressed = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isStartPressed = false;
                      });
                      Navigator.of(context).pop();
                      _startQuiz();
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
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _startQuiz() {
    setState(() {
      _showIntro = false;
      _showGrammarBasics = false;
    });
  }

  void _showGrammarBasicsScreen() {
    setState(() {
      _showIntro = false;
      _showGrammarBasics = true;
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
    final progress = (_currentQuestionIndex + 1) / (_questions.length + 1); // Include grammar content in progress

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: _showExitConfirmationDialog,
          child: Image.asset('assets/images/back.png', width: 30, height: 30),
        ),
        title: const Text('Kids Grammar'),
      ),
      body: Stack(
        children: [
          if (_showIntro)
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/grammar1.png',
                      fit: BoxFit.fitWidth, // Adjusted to not occupy the main header
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
                            _isContinuePressed = true;
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            _isContinuePressed = false;
                          });
                          _showGrammarBasicsScreen();
                        },
                        onTapCancel: () {
                          setState(() {
                            _isContinuePressed = false;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          width: _isContinuePressed ? 200 : 230,
                          height: _isContinuePressed ? 55 : 60,
                          child: Image.asset(
                            'assets/images/continue.png',
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
                if (_showGrammarBasics)
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Grammar Basics for Kids',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '1. Nouns: A noun is a word that names a person, place, or thing. Examples: cat, dog, school.',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '2. Verbs: A verb is a word that shows an action. Examples: run, jump, eat.',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '3. Adjectives: An adjective is a word that describes a noun. Examples: happy, big, red.',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '4. Plurals: Plurals are words that mean more than one. Add "s" or "es" to make plurals. Examples: cat -> cats, box -> boxes.',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTapDown: (_) {
                              setState(() {
                                _isStartPressed = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                _isStartPressed = false;
                              });
                              _showGrammarBasicsAlert();
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
                                'assets/images/next.png',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quiz',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
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
                  ),
              ],
            ),
          if (!_showIntro && !_showGrammarBasics)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
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
                      int score = 0;
                      for (int i = 0; i < _questions.length; i++) {
                        if (_userAnswers[i] == _questions[i]['correctAnswer']) {
                          score++;
                        }
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ResultPage(score: score, totalQuestions: _questions.length),
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
                    width: _isNextPressed ? 90 : 110,
                    height: _isNextPressed ? 40 : 50,
                    child: Image.asset(
                      'assets/images/next.png',
                      fit: BoxFit.fitHeight,
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

    stars = widget.score == 0
        ? ['assets/images/nostar.png']
        : (widget.score <= 2
            ? ['assets/images/star1.png']
            : (widget.score <= 4
                ? ['assets/images/star1.png', 'assets/images/star2.png']
                : ['assets/images/star1.png', 'assets/images/star2.png', 'assets/images/star3.png']));

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

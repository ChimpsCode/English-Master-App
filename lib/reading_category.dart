import 'package:flutter/material.dart';
import 'dart:math';

class ReadingCategory extends StatefulWidget {
  const ReadingCategory({super.key});

  @override
  _ReadingCategoryState createState() => _ReadingCategoryState();
}

class _ReadingCategoryState extends State<ReadingCategory> {
  bool _isContinuePressed = false;
  bool _isStartPressed = false;

  final List<Map<String, dynamic>> _stories = [
    {
      'story': 'Once upon a time, in a peaceful village surrounded by lush green forests, there lived a kind-hearted girl named Red Riding Hood. She loved visiting her grandmother, who lived on the other side of the forest. One day, while carrying a basket of goodies, she encountered a cunning wolf who tried to trick her. But with her wit and courage, she outsmarted the wolf and safely reached her grandmother\'s house.',
      'questions': [
        {
          'question': 'What color was Red Riding Hood\'s cloak?',
          'answers': ['Red', 'Blue', 'Green', 'Yellow'],
          'correctAnswer': 'Red',
        },
        {
          'question': 'Who did Red Riding Hood visit?',
          'answers': ['Her grandmother', 'Her friend', 'Her teacher', 'Her mother'],
          'correctAnswer': 'Her grandmother',
        },
        {
          'question': 'What did Red Riding Hood carry in her basket?',
          'answers': ['Goodies', 'Books', 'Flowers', 'Toys'],
          'correctAnswer': 'Goodies',
        },
      ],
    },
    {
      'story': 'In a small village, there was a curious boy named Jack who lived with his mother. They were very poor and had only one cow. One day, Jack traded the cow for some magical beans. Overnight, the beans grew into a giant beanstalk that reached the clouds. Jack climbed the beanstalk and discovered a castle with treasures guarded by a giant. Using his bravery and cleverness, Jack brought back riches to his mother and they lived happily ever after.',
      'questions': [
        {
          'question': 'What did Jack trade for the magical beans?',
          'answers': ['A cow', 'A horse', 'A chicken', 'A goat'],
          'correctAnswer': 'A cow',
        },
        {
          'question': 'What grew from the magical beans?',
          'answers': ['A beanstalk', 'A tree', 'A flower', 'A bush'],
          'correctAnswer': 'A beanstalk',
        },
        {
          'question': 'What did Jack find at the top of the beanstalk?',
          'answers': ['A castle', 'A dragon', 'A forest', 'A river'],
          'correctAnswer': 'A castle',
        },
      ],
    },
    {
      'story': 'Long ago, in a faraway kingdom, there was a brave knight named Arthur. He was known for his loyalty and courage. One day, the kingdom was threatened by a fierce dragon. Arthur, armed with his magical sword Excalibur, set out on a quest to defeat the dragon. After a fierce battle, Arthur emerged victorious, saving the kingdom and earning the admiration of all its people.',
      'questions': [
        {
          'question': 'What was the name of the knight?',
          'answers': ['Arthur', 'Lancelot', 'Gawain', 'Percival'],
          'correctAnswer': 'Arthur',
        },
        {
          'question': 'What weapon did Arthur use?',
          'answers': ['Excalibur', 'A bow', 'A spear', 'A shield'],
          'correctAnswer': 'Excalibur',
        },
        {
          'question': 'What did Arthur defeat?',
          'answers': ['A dragon', 'A giant', 'A wizard', 'A troll'],
          'correctAnswer': 'A dragon',
        },
      ],
    },
  ];

  late Map<String, dynamic> _selectedStory;

  @override
  void initState() {
    super.initState();
    _selectRandomStory();
  }

  void _selectRandomStory() {
    final randomIndex = Random().nextInt(_stories.length);
    _selectedStory = _stories[randomIndex];
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: _showExitConfirmationDialog,
          child: Image.asset(
            'assets/images/back.png',
            width: 30,
            height: 30,
          ),
        ),
        title: const Text('Reading Category'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/reading1.png',
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
                    _isContinuePressed = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    _isContinuePressed = false;
                  });
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ShortStoryPage(story: _selectedStory),
                    ),
                  );
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
    );
  }
}

class ShortStoryPage extends StatelessWidget {
  final Map<String, dynamic> story;

  const ShortStoryPage({required this.story, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Image.asset('assets/images/back.png', width: 30, height: 30),
        ),
        title: const Text('Short Story'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              LinearProgressIndicator(
                value: 0.33, // Progress for the short story
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    story['story'],
                    style: const TextStyle(fontSize: 18, height: 1.5),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuestionSection(questions: story['questions']),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/next.png',
                  width: 80,
                  height: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionSection extends StatefulWidget {
  final List<Map<String, dynamic>> questions;

  const QuestionSection({required this.questions, super.key});

  @override
  _QuestionSectionState createState() => _QuestionSectionState();
}

class _QuestionSectionState extends State<QuestionSection> {
  int _currentQuestionIndex = 0;
  final Map<int, String> _userAnswers = {};

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / widget.questions.length;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Image.asset('assets/images/back.png', width: 30, height: 30),
        ),
        title: const Text('Questions'),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  if (_currentQuestionIndex < widget.questions.length - 1) {
                    setState(() {
                      _currentQuestionIndex++;
                    });
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          userAnswers: _userAnswers,
                          questions: widget.questions,
                        ),
                      ),
                    );
                  }
                },
                child: Image.asset(
                  'assets/images/next.png',
                  width: 80,
                  height: 50,
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
  final Map<int, String> userAnswers;
  final List<Map<String, dynamic>> questions;

  const ResultPage({required this.userAnswers, required this.questions, super.key});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with TickerProviderStateMixin {
  late int score;
  late List<String> stars;
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    score = widget.userAnswers.entries
        .where((entry) => entry.value == widget.questions[entry.key]['correctAnswer'])
        .length;

    stars = score == widget.questions.length
        ? ['assets/images/star1.png', 'assets/images/star2.png', 'assets/images/star3.png']
        : (score == 0
            ? ['assets/images/nostar.png']
            : (score == 1
                ? ['assets/images/star1.png']
                : ['assets/images/star1.png', 'assets/images/star2.png']));

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
              '$score/${widget.questions.length}',
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

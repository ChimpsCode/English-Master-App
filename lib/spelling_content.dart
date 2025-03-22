import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SpellingContent(),
    );
  }
}

class SpellingContent extends StatefulWidget {
  const SpellingContent({super.key});

  @override
  _SpellingContentState createState() => _SpellingContentState();
}

class _SpellingContentState extends State<SpellingContent> {
  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize AudioPlayer
  bool _isStartPressed = false;
  bool _showIntro = true;
  bool _showHeadsetPopup = false;
  bool _showSpellingSection = false;
  int _currentQuestionIndex = 0;
  int _stars = 3;
  final TextEditingController _answerController = TextEditingController();
  final List<String> _questions = [
    "Hint: This is used in the rainy season.",
    "Hint: This is a fruit that monkeys love.",
    "Hint: This is a device used to call someone."
  ];
  final List<String> _answers = ["umbrella", "banana", "phone"];
  String _feedbackMessage = "";

  void _showInstructionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/instructions.png'),
              const SizedBox(height: 5),
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
                  Navigator.of(context).pop();
                  setState(() {
                    _showHeadsetPopup = true;
                  });
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
            ],
          ),
        );
      },
    );
  }

  void _submitAnswer() {
    setState(() {
      if (_answerController.text.toLowerCase() == _answers[_currentQuestionIndex].toLowerCase()) {
        _feedbackMessage = "Great job!";
        Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
          setState(() {
            _feedbackMessage = "";
          });
        });
        if (_currentQuestionIndex < _questions.length - 1) {
          _currentQuestionIndex++;
          _answerController.clear();
        } else {
          _feedbackMessage = "You've completed the spelling section!";
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(
                score: _stars,
                totalQuestions: _questions.length,
              ),
            ),
          );
        }
      } else {
        _stars--;
        if (_stars == 0) {
          _showGameOverDialog();
        } else {
          _feedbackMessage = "Try again!";
        }
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/game_over.png'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _stars = 3;
                        _currentQuestionIndex = 0;
                        _answerController.clear();
                        _feedbackMessage = "";
                      });
                    },
                    child: Image.asset('assets/images/try_again.png', width: 100),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Image.asset('assets/images/exit.png', width: 100),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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

  Widget _buildStars() {
    List<Widget> starImages = [];
    for (int i = 0; i < _stars; i++) {
      starImages.add(Image.asset('assets/images/star${i + 1}.png', width: 30));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: starImages,
    );
  }

  void _playAudio() async {
    String audioFile;
    switch (_currentQuestionIndex) {
      case 0:
        audioFile = 'assets/audio/umbrella.mp3';
        break;
      case 1:
        audioFile = 'assets/audio/banana.mp3';
        break;
      case 2:
        audioFile = 'assets/audio/phone.mp3';
        break;
      default:
        return;
    }

    try {
      await _audioPlayer.setSource(AssetSource(audioFile)); // Set the audio source
      await _audioPlayer.resume(); // Play the audio
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose of the audio player
    _answerController.dispose(); // Dispose of the text controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: _showExitConfirmationDialog,
          child: Image.asset('assets/images/back.png', width: 30, height: 30),
        ),
        title: const Text('Kids Spelling'),
      ),
      resizeToAvoidBottomInset: true, // Ensures the layout adjusts when the keyboard appears
      body: Stack(
        children: [
          Column(
            children: [
              if (_showIntro)
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/spelling1.png',
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
                                _showIntro = false;
                              });
                              _showInstructionsDialog();
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
              else if (_showHeadsetPopup)
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/headset.png',
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
                                _showHeadsetPopup = false;
                                _showSpellingSection = true;
                              });
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
              else if (_showSpellingSection)
                Expanded(
                  child: SingleChildScrollView( // Wrap the content in SingleChildScrollView
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: _buildStars(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Spelling Section',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _questions[_currentQuestionIndex],
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _playAudio, // Play the corresponding audio
                          icon: const Icon(Icons.audiotrack),
                          label: const Text('Play Audio'),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _answerController,
                          decoration: const InputDecoration(
                            labelText: 'Your Answer',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitAnswer,
                          child: const Text('Submit'),
                        ),
                        const SizedBox(height: 20),
                        AnimatedOpacity(
                          opacity: _feedbackMessage.isNotEmpty ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            _feedbackMessage,
                            style: TextStyle(
                              fontSize: 18,
                              color: _feedbackMessage == "Great job!" ? Colors.green : Colors.red,
                            ),
                          ),
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

    stars = widget.score == widget.totalQuestions
        ? ['assets/images/star1.png', 'assets/images/star2.png', 'assets/images/star3.png']
        : (widget.score >= (widget.totalQuestions / 2).ceil()
            ? ['assets/images/star1.png', 'assets/images/star2.png']
            : ['assets/images/star1.png']); // 1 star for low scores

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

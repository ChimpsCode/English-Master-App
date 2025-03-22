import 'package:flutter/material.dart';
import 'reading_category.dart';
import 'grammar_content.dart';
import 'spelling_content.dart';
import 'exam_content.dart';

class CoursesView extends StatelessWidget {
  const CoursesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: const Text(
          'Categories',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns to form a square
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1, // Makes sure the grid is evenly spaced
            ),
            itemCount: categoriesJSON.length,
            itemBuilder: (context, index) {
              final category = categoriesJSON[index];
              return _CategoryButton(
                imagePath: category['imagePath'] as String,
                destination: category['destination'] as Widget,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CategoryButton extends StatefulWidget {
  final String imagePath;
  final Widget destination;

  const _CategoryButton({
    required this.imagePath,
    required this.destination,
  });

  @override
  State<_CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<_CategoryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true; // Shrink effect starts
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false; // Reset size after release
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.destination),
        );
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false; // Reset size if tap is canceled
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: _isPressed ? 200 : 230, // Shrink width
        height: _isPressed ? 200 : 230, // Shrink height
        child: Center(
          child: Image.asset(
            widget.imagePath,
            width: _isPressed ? 200 : 230, // Shrink image width
            height: _isPressed ? 200 : 230, // Shrink image height
          ),
        ),
      ),
    );
  }
}

// ✅ Now categoriesJSON includes the correct destinations for navigation
final List<Map<String, dynamic>> categoriesJSON = [
  {
    "name": "Reading",
    "imagePath": 'assets/images/reading.png',
    "destination": const ReadingCategory(),
  },
  {
    "name": "Grammar",
    "imagePath": 'assets/images/book.png',
    "destination": const GrammarContent(),
  },
  {
    "name": "Spelling",
    "imagePath": 'assets/images/spelling.png',
    "destination": const SpellingContent(),
  },
  {
    "name": "Exam",
    "imagePath": 'assets/images/exam.png',
    "destination": const ExamContent(),
  },
];

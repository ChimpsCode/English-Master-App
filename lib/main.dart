import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'courses_view.dart';
import 'video_player_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Master',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final tabItems = <String>['Recommended', 'Hot', 'Story Telling', 'Business', 'Grammar'];
  late final selectedTabNotifier = ValueNotifier<String>(tabItems.first);
  final learningsNotifier = ValueNotifier<List<Learning>>([]);
  final ValueNotifier<double> sharedProgressNotifier = ValueNotifier<double>(0.0);
  int _selectedIndex = 0;
  final List<bool> _isIconPressed = [false, false, false, false];

  List<Widget> _widgetOptions(ValueNotifier<String> selectedTabNotifier, ValueNotifier<List<Learning>> learningsNotifier, List<String> tabItems, ValueNotifier<double> sharedProgressNotifier) {
    return [
      HomeViewContent(
        selectedTabNotifier: selectedTabNotifier,
        learningsNotifier: learningsNotifier,
        sharedProgressNotifier: sharedProgressNotifier,
        tabItems: tabItems,
      ),
      CoursesView(),
      Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/underconstruction.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
      Center(child: Text('Profile')),
    ];
  }

  @override
  void initState() {
    super.initState();
    loadData();
    selectedTabNotifier.addListener(() {
      loadData(category: selectedTabNotifier.value);
    });
  }

  @override
  void dispose() {
    selectedTabNotifier.dispose();
    learningsNotifier.dispose();
    sharedProgressNotifier.dispose();
    super.dispose();
  }

  Future<void> loadData({String? category}) async {
    final learnings = List<Learning>.from(
      learningsJSON.map((e) => Learning.fromJson(e)),
    );

    if (category != null) {
      learnings.removeWhere((it) => !it.categories.contains(category));
    } else {
      selectedTabNotifier.value = tabItems.first;
    }

    learningsNotifier.value = learnings;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isIconPressed[index] = true;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _isIconPressed[index] = false;
      });
    });
    _trackFeatureUsage(); // Track navigation as a feature usage
  }

  int _calculateSelectedIndex(BuildContext context) {
    return _selectedIndex;
  }

  void _onTap(BuildContext context, int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _trackFeatureUsage() {
    if (sharedProgressNotifier.value < 1.0) {
      sharedProgressNotifier.value += 0.02; // Slower increment for more challenge
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        title: _selectedIndex == 0
            ? Image.asset('assets/images/hellolearner2.png', width: 550)
            : _selectedIndex == 1
                ? Image.asset('assets/images/courses1.png', width: 130)
                : Text(
                    _selectedIndex == 2
                        ? 'Live'
                        : 'Account',
                  ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset('assets/images/search.png', width: 50),
          ),
        ],
      ),
      body: _widgetOptions(selectedTabNotifier, learningsNotifier, tabItems, sharedProgressNotifier)[_selectedIndex],
      bottomNavigationBar: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bottom.png',
              fit: BoxFit.cover,
            ),
          ),
          BottomNavigationBar(
            items: _navigationItems.asMap().entries.map((entry) {
              int index = entry.key;
              BottomNavigationBarItem item = entry.value;
              return BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _isIconPressed[index] ? 60 : 70,
                  height: _isIconPressed[index] ? 60 : 70,
                  child: item.icon,
                ),
                label: item.label,
              );
            }).toList(),
            currentIndex: _selectedIndex,
            selectedItemColor: null, // Remove color effect on selected icon
            unselectedItemColor: null, // Remove color effect on unselected icon
            backgroundColor: Colors.transparent, // Make background transparent
            onTap: _onItemTapped,
            elevation: 0, // Removes any shadow/elevation
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
          ),
        ],
      ),
    );
  }
}

class HomeViewContent extends StatelessWidget {
  final ValueNotifier<String> selectedTabNotifier;
  final ValueNotifier<List<Learning>> learningsNotifier;
  final ValueNotifier<double> sharedProgressNotifier;
  final List<String> tabItems;

  const HomeViewContent({
    super.key,
    required this.selectedTabNotifier,
    required this.learningsNotifier,
    required this.sharedProgressNotifier,
    required this.tabItems,
  });

  void _trackFeatureClick() {
    if (sharedProgressNotifier.value < 1.0) {
      sharedProgressNotifier.value += 0.02; // Slower increment for more challenge
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: NestedScrollView(
        headerSliverBuilder: (_, __) {
          return [
            SliverPadding(
              padding: const EdgeInsets.only(top: 10),
              sliver: SliverToBoxAdapter(
                child: ProgressTracker(
                  sharedProgressNotifier: sharedProgressNotifier,
                  targetLearned: 10,
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            ValueListenableBuilder<String>(
              valueListenable: selectedTabNotifier,
              builder: (_, currentItem, __) {
                return _HomeTabBar(
                  items: tabItems,
                  currentItem: currentItem,
                  onChanged: (value) {
                    selectedTabNotifier.value = value;
                    _trackFeatureClick(); // Track tab change as a feature interaction
                  },
                );
              },
            ),
            ValueListenableBuilder<List<Learning>>(
              valueListenable: learningsNotifier,
              builder: (_, learnings, __) {
                return _HomeLearningList(
                  learnings: learnings,
                  onFeatureClick: _trackFeatureClick, // Track learning item clicks
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressTracker extends StatefulWidget {
  final ValueNotifier<double> sharedProgressNotifier;
  final int targetLearned;

  const ProgressTracker({
    required this.sharedProgressNotifier,
    required this.targetLearned,
    super.key,
  });

  @override
  _ProgressTrackerState createState() => _ProgressTrackerState();
}

class _ProgressTrackerState extends State<ProgressTracker> {
  void _addProgressOnFeatureClick() {
    // Add progress when a feature is clicked
    setState(() {
      if (widget.sharedProgressNotifier.value < 1.0) {
        widget.sharedProgressNotifier.value += 0.02; // Slower increment for more challenge
      }
      if (widget.sharedProgressNotifier.value > widget.targetLearned) {
        widget.sharedProgressNotifier.value = widget.targetLearned as double; // Cap progress at the target
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: widget.sharedProgressNotifier,
      builder: (_, currentLearned, __) {
        double progress = currentLearned / widget.targetLearned;

        return Card(
          child: ListTile(
            leading: const Icon(Icons.star, size: 50),
            title: const Text('Learning Progress'),
            trailing: CircularProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              strokeWidth: 8,
              semanticsLabel: 'Progress',
            ),
          ),
        );
      },
    );
  }
}

class _HomeTabBar extends StatelessWidget {
  const _HomeTabBar({
    required this.items,
    required this.currentItem,
    required this.onChanged,
  });

  final List<String> items;
  final String currentItem;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 35,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: items.map((item) {
            bool isActivated = currentItem.toLowerCase() == item.toLowerCase();
            return GestureDetector(
              onTap: () => onChanged(item),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 450),
                padding: const EdgeInsets.only(bottom: 4.0, right: 15, left: 15),
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(
                  color: !isActivated ? null : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 19.5,
                      color: !isActivated ? null : Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _HomeLearningList extends StatelessWidget {
  const _HomeLearningList({
    required this.learnings,
    required this.onFeatureClick,
  });

  final List<Learning> learnings;
  final VoidCallback onFeatureClick;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: learnings.map((item) {
          return GestureDetector(
            onTap: () {
              onFeatureClick(); // Track the click
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(videoPath: item.videoPath),
                ),
              );
            },
            child: VideoLearningCard(
              onPressed: onFeatureClick, // Track the click
              title: item.title,
              level: item.level,
              imageUrl: item.imageUrl,
              videoDuration: item.videoDuration,
              countExercises: item.countExercises,
              countStudents: item.countStudents,
              countPlays: item.countPlays,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Learning {
  final String title;
  final String level;
  final String imageUrl;
  final String videoDuration;
  final int countExercises;
  final int countStudents;
  final int countPlays;
  final List<String> categories;
  final String videoPath;

  Learning({
    required this.title,
    required this.level,
    required this.imageUrl,
    required this.videoDuration,
    required this.countExercises,
    required this.countStudents,
    required this.countPlays,
    required this.categories,
    required this.videoPath,
  });

  factory Learning.fromJson(Map<String, dynamic> json) {
    return Learning(
      title: json['title'],
      level: json['level'],
      imageUrl: json['imageUrl'],
      videoDuration: json['videoDuration'],
      countExercises: json['countExercises'],
      countStudents: json['countStudents'],
      countPlays: json['countPlays'],
      categories: List<String>.from(json['categories']),
      videoPath: json['videoPath'],
    );
  }
}

const learningsJSON = [
  {
    "title": "Learning English",
    "level": "Beginner",
    "imageUrl": "assets/images/R1.png",
    "videoDuration": "10:00",
    "countExercises": 5,
    "countStudents": 100,
    "countPlays": 50,
    "categories": ["Recommended"],
    "videoPath": "assets/videos/R1.mp4"
  },
  {
    "title": "English 2",
    "level": "Intermediate",
    "imageUrl": "assets/images/R2.png",
    "videoDuration": "15:00",
    "countExercises": 8,
    "countStudents": 150,
    "countPlays": 75,
    "categories": ["Recommended"],
    "videoPath": "assets/videos/R2.mp4"
  },
  // Add more dummy data as needed
];

class VideoLearningCard extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String level;
  final String imageUrl;
  final String videoDuration;
  final int countExercises;
  final int countStudents;
  final int countPlays;

  const VideoLearningCard({
    required this.onPressed,
    required this.title,
    required this.level,
    required this.imageUrl,
    required this.videoDuration,
    required this.countExercises,
    required this.countStudents,
    required this.countPlays,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class AppBottomBar extends StatelessWidget {
  final double opacity;
  final int currentIndex;
  final ValueChanged<int?> onTap;
  final BorderRadius borderRadius;
  final double elevation;
  final bool hasInk;
  final List<BottomNavigationBarItem> items;

  const AppBottomBar({
    required this.opacity,
    required this.currentIndex,
    required this.onTap,
    required this.borderRadius,
    required this.elevation,
    required this.hasInk,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items,
      currentIndex: currentIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      onTap: onTap,
      backgroundColor: Colors.white.withOpacity(opacity),
      elevation: elevation,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}

const _navigationItems = <BottomNavigationBarItem>[
  BottomNavigationBarItem(
  icon: Image(image: AssetImage('assets/images/home.png'), width: 65),
  label: '',
),

  BottomNavigationBarItem(
    icon: Image(image:AssetImage('assets/images/courses.png'), width: 65),
    label: '',
  ),
  BottomNavigationBarItem(
    icon:Image(image:AssetImage('assets/images/live.png'), width: 65),
    label: '',
  ),
  BottomNavigationBarItem(
    icon: Image(image:AssetImage('assets/images/account.png'), width: 65),
    label: '',
  ),
];


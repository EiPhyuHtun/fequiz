import 'package:flutter/material.dart';
void main() {
  runApp(QuizApp());
}
class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
// :white_tick: Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainTabScreen()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0033A0),
      body: Center(
        child: Image.asset(
          'assets/images/quize.png',
          width: 240,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
// :white_tick: Main Screen with BottomNavigationBar
class MainTabScreen extends StatefulWidget {
  @override
  _MainTabScreenState createState() => _MainTabScreenState();
}
class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    ExamTypeScreen(),
    ProfileScreen(),
    MenuScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ""),
        ],
      ),
    );
  }
}
// :white_tick: Exam Type Screen
class ExamTypeScreen extends StatelessWidget {
  final List<Map<String, String>> examTypes = [
    {'year': '2024', 'month': 'October', 'image': 'assets/images/2024.png'},
    {'year': '2024', 'month': 'April', 'image': 'assets/images/20242.png'},
    {'year': '2023', 'month': 'October', 'image': 'assets/images/2023.png'},
    {'year': '2023', 'month': 'April', 'image': 'assets/images/20232.png'},
    {'year': '2022', 'month': 'October', 'image': 'assets/images/2022.png'},
    {'year': '2022', 'month': 'April', 'image': 'assets/images/20222.png'},
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          // :white_tick: Background
          Container(color: Colors.white),
          // :white_tick: Curved Header
          ClipPath(
            clipper: BottomWaveClipper(),
            child: Container(
              height: height * 0.35,
              color: Colors.cyan,
            ),
          ),
          // :white_tick: Header Title
          Positioned(
            top: 120,
            left: 24,
            child: Text(
              '試験タイプ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 33,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // :white_tick: Profile Avatar (top right)
          Positioned(
            top: 50,
            right: 20,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/people.png'), // Replace with your actual path
              radius: 20,
            ),
          ),
          // :white_tick: Grid Cards
          Padding(
            padding: EdgeInsets.only(top: height * 0.27),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: examTypes.map((exam) {
                  return GestureDetector(
                    onTap: () {},
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      shadowColor: Colors.black26,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              exam['image']!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 12),
                            Text(
                              exam['month']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              exam['year']!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// :white_tick: Dummy Profile Screen
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(":silhouette: Profile Page", style: TextStyle(fontSize: 24)),
    );
  }
}
// :white_tick: Dummy Menu Screen
class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(":clipboard: Menu Page", style: TextStyle(fontSize: 24)),
    );
  }
}
// :white_tick: Curved Header Clipper
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    var controlPoint = Offset(size.width / 2, size.height);
    var endPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

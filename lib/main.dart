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

// Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ExamTypeScreen()),
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

// Exam Type Screen
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
    return Scaffold(
      backgroundColor: Color(0xFFE0F7FA),
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        elevation: 0,
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
            radius: 18,
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 180,
            color: Colors.cyan,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 275.0),
                  child: Text(
                    '試験タイプ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: examTypes.map((exam) {
                  return GestureDetector(
                    onTap: () {
                      // You can handle tap here
                    },
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            exam['image']!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${exam['month']} ${exam['year']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
        ],
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

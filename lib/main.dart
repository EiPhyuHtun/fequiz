import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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
          Container(color: Colors.white),
          ClipPath(
            clipper: BottomWaveClipper(),
            child: Container(
              height: height * 0.35,
              color: Colors.cyan,
            ),
          ),
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
          Positioned(
            top: 50,
            right: 20,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/people.png'),
              radius: 20,
            ),
          ),
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

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  XFile? _pickedFile;
  final picker = ImagePicker();
  final nameController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

  Future<void> _uploadData() async {
    if (_pickedFile == null || nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("名前と画像を入力してください")),
      );
      return;
    }

    final uri = Uri.parse("http://10.0.2.2/fequiz/upload_user.php"); // ← Updated here
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = nameController.text;

    if (kIsWeb) {
      final bytes = await _pickedFile!.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: _pickedFile!.name,
        ),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath("image", _pickedFile!.path),
      );
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("アップロード成功")),
      );
      setState(() {
        _pickedFile = null;
        nameController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("アップロード失敗")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imagePreview;
    if (_pickedFile == null) {
      imagePreview = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 28),
          SizedBox(width: 8),
          Text("画像を選択", style: TextStyle(fontSize: 18)),
        ],
      );
    } else if (kIsWeb) {
      imagePreview = Image.network(_pickedFile!.path);
    } else {
      imagePreview = Image.file(io.File(_pickedFile!.path), fit: BoxFit.cover);
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(height: 80),
            Text("QUIZ 4 ✅", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            Text('サインアップ', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(child: imagePreview),
              ),
            ),
            SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("名前", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _uploadData,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("サインアップ", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Menu Page", style: TextStyle(fontSize: 24)),
    );
  }
}

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

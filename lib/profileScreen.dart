import 'dart:io' as io;
import 'package:fequiz/mysql1.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysql1/mysql1.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final nameController = TextEditingController();
  final db=Mysql();
  bool _isLoading = false;
  String? _statusMessage;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> insertuserWithImageBlob() async {
    if (_imageFile == null) {
      setState(() {
        _statusMessage = 'Please select an image.';
      });
      return;
    }
    if (nameController.text.isEmpty) {
      setState(() {
        _statusMessage = 'Please enter user name and description.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    MySqlConnection? conn; // Initialize connection variable
    try {
      // 1. Read the image file into a Uint8List (raw bytes)
      final Uint8List imageBytes = await _imageFile!.readAsBytes();

      // 2. Get MySQL connection
      conn = await Mysql().getConnection();
      print("Connection established successfully.");

      // 3. Prepare and execute the INSERT query
      // Use prepared statements to properly handle binary data and prevent SQL injection
      var result = await conn.query(
        'INSERT INTO users (user_name,user_image) VALUES (?, ?)',
        [
          nameController.text,
          imageBytes, // Pass the Uint8List directly
        ],
      );

      if (result.affectedRows! > 0) {
        setState(() {
          _statusMessage = 'user and image BLOB inserted successfully! New ID: ${result.insertId}';
          nameController.clear();
          _imageFile = null;
        });
        print('Insert successful. New user ID: ${result.insertId}');
      } else {
        setState(() {
          _statusMessage = 'Failed to insert user data. No rows affected.';
        });
        print('Insert failed: No rows affected.');
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error during insertion: $e';
      });
      print('Error during BLOB insertion: $e');
    } finally {
      // Always close the connection in a finally block
      if (conn != null) {
        await conn.close();
        print("Connection closed.");
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  //method insert data in MySql 
  //connect the database

void insertData(){
db.getConnection().then((conn) {

 String sqlQuery = 'insert into users (user_name,user_image) values (?,?)';
 conn.query(sqlQuery,[nameController.text,null]);
 setState(() {
   
 });
 print("Data Insert Successful....");

});


}
  @override 
  Widget build(BuildContext context) {
    Widget imagePreview;
    if (_imageFile == null) {
      imagePreview = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 28),
          SizedBox(width: 8),
          Text("画像を選択", style: TextStyle(fontSize: 18)),
        ],
      );
    } else if (kIsWeb) {
      imagePreview = Image.network(_imageFile!.path);
    } else {
      imagePreview = Image.file(io.File(_imageFile!.path), fit: BoxFit.cover);
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
               onPressed: () {
                insertuserWithImageBlob();
                print("Data Insert.....");
               },
             
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


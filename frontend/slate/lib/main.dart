import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MalayalamSlateApp());
}

class MalayalamSlateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Malayalam Tracing Slate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.pink[50],
        fontFamily: 'Comic Sans MS',
      ),
      home: DrawingScreen(),
    );
  }
}

class DrawingScreen extends StatefulWidget {
  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Offset?> points = [];
  final GlobalKey _globalKey = GlobalKey();
  Color selectedColor = Colors.black;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _saveToImage() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    var uri = Uri.parse("https://00639315bb8c.ngrok-free.app/upload");

    var request = http.MultipartRequest('POST', uri);
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        pngBytes,
        filename: 'drawing.png',
        contentType: MediaType('image', 'png'),
      ),
    );

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      try {
        var decoded = jsonDecode(responseBody);
        if (decoded['status'] == 'valid') {
          String prediction = decoded['prediction'] == 'a'
              ? 'അ'
              : decoded['prediction'] == 'e'
                  ? 'ഇ'
                  : decoded['prediction'] == 'o'
                      ? 'ഉ'
                      : '😍';
          _showPopup("Good Kidoo!", "You wrote: $prediction", true);
        } else {
          _showPopup("Oops!", "Try again, little champ!", false);
        }
      } catch (e) {
        _showPopup("Error", "Invalid response from server.", false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: ${response.statusCode}")),
      );
    }
  }

  void _showPopup(String title, String content, bool isValid) {
    if (isValid) _confettiController.play();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isValid
                      ? [
                          Colors.pinkAccent.shade100,
                          Colors.orangeAccent.shade100
                        ]
                      : [Colors.grey.shade300, Colors.blueGrey.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 60),
                  Text(
                    isValid ? "🎉 $title 🎉" : "😢 $title 😢",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Comic Sans MS',
                      color: isValid ? Colors.deepPurple : Colors.redAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Comic Sans MS',
                      color: isValid ? Colors.teal[900] : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isValid ? Colors.purple : Colors.grey,
                      shape: StadiumBorder(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    onPressed: () {
                      _confettiController.stop();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      isValid ? "Yay! 🎈" : "Okay 😢",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Comic Sans MS',
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (isValid)
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: pi / 2,
                emissionFrequency: 0.05,
                numberOfParticles: 25,
                gravity: 0.3,
                shouldLoop: false,
              ),
            if (!isValid)
              Positioned(
                top: 10,
                child: Icon(Icons.sentiment_very_dissatisfied,
                    size: 60, color: Colors.blueGrey),
              ),
          ],
        ),
      ),
    );
  }

  void _clearDrawing() {
    setState(() {
      points.clear();
    });
  }

  void _changeColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Slate",
            style: TextStyle(
                fontSize: 22, color: ui.Color.fromARGB(255, 255, 255, 255))),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
        elevation: 5,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.white,
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          RenderBox renderBox =
                              context.findRenderObject() as RenderBox;
                          points.add(
                              renderBox.globalToLocal(details.globalPosition));
                        });
                      },
                      onPanEnd: (details) => points.add(null),
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: DrawingPainter(
                            points: points, color: selectedColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _colorDot(Colors.black),
                _colorDot(Colors.red),
                _colorDot(Colors.green),
                _colorDot(Colors.blue),
                _colorDot(Colors.purple),
                _colorDot(Colors.brown),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _clearDrawing,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                  backgroundColor: Colors.redAccent,
                  shadowColor: Colors.redAccent.withOpacity(0.6),
                ),
                child: Text(
                  "Clear ❌",
                  style: TextStyle(
                    fontFamily: 'Comic Sans MS',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _saveToImage,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                  backgroundColor: Colors.teal,
                  shadowColor: Colors.teal.withOpacity(0.6),
                ),
                child: Text(
                  "Check 😍",
                  style: TextStyle(
                    fontFamily: 'Comic Sans MS',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _colorDot(Color color) {
    return GestureDetector(
      onTap: () => _changeColor(color),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: Colors.white),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;

  DrawingPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final paint = Paint()
      ..color = color
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

//import 'dart:math';
import 'package:flutter/material.dart';

class UserPathPage extends StatefulWidget {
  @override
  _UserPathPageState createState() => _UserPathPageState();
}

class _UserPathPageState extends State<UserPathPage> {
  List<Map<String, dynamic>> path = []; // Store direction and position
  double xPosition = 0.0;
  double yPosition = 0.0;

  final double moveDistance = 38.0; // 10mm in logical pixels (approx. 37.79 pixels)

  void addDirection(String direction) {
    setState(() {
      if (path.isNotEmpty) {
        // Get the last direction
        String lastDirection = path.last['direction'];
        if (lastDirection != direction) {
          path.add({'direction': direction, 'position': Offset(xPosition, yPosition)});
        } else {
          // If the direction is the same, only update the position
          path.last['position'] = Offset(xPosition, yPosition);
        }
      } else {
        // If the path is empty, start with the first direction
        path.add({'direction': direction, 'position': Offset(xPosition, yPosition)});
      }

      // Adjust the position based on the direction
      if (direction == 'left') {
        xPosition -= moveDistance;  // Move left by 10mm
      } else if (direction == 'right') {
        xPosition += moveDistance;  // Move right by 10mm
      } else if (direction == 'forward') {
        yPosition -= moveDistance;  // Move forward by 10mm
      }

      // Add new position to the path
      path.add({'direction': direction, 'position': Offset(xPosition, yPosition)});
    });
  }

  void undoLast() {
    if (path.length > 1) {
      setState(() {
        path.removeLast(); // Remove current position
        path.removeLast(); // Remove previous position
        if (path.isNotEmpty) {
          xPosition = path.last['position'].dx;
          yPosition = path.last['position'].dy;
        } else {
          xPosition = 0.0;
          yPosition = 0.0;
        }
      });
    }
  }

  void resetPath() {
    setState(() {
      path.clear();
      xPosition = 0.0;
      yPosition = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121721),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/FIRO_PNG1.png',
                    height: 50,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 20,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  color: Colors.blueGrey,
                  child: Container(
                    color: Colors.grey[900],
                      child: InteractiveViewer(
                        boundaryMargin: const EdgeInsets.fromLTRB(100.0,700.0,100.0,200.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: CustomPaint(
                            painter: PathPainter(path),
                          ),
                        ),
                      ),
                    ),
                ),
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.arrow_back, color: Colors.white, size: 40)),
                  onPressed: () => addDirection('left'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward, color: Colors.black, size: 40),
                      onPressed: () => addDirection('forward'),
                    ),
                  ),
                ),
                IconButton(
                  icon: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 40)),
                  onPressed: () => addDirection('right'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(26, 107, 229, 1),
                  ),
                  onPressed: undoLast,
                  child: const Text('Undo', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(26, 107, 229, 1),
                  ),
                  onPressed: resetPath,
                  child: const Text('Reset', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/simulationPage',arguments: path);
                  },
                  child: const Text('Start Simulation', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  final List<Map<String, dynamic>> path;
  PathPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    if (path.isNotEmpty) {
      final centerX = size.width / 2;
      final centerY = size.height / 2;

      for (int i = 0; i < path.length - 1; i++) {
        final startPoint = Offset(centerX + path[i]['position'].dx, centerY + path[i]['position'].dy);
        final endPoint = Offset(centerX + path[i + 1]['position'].dx, centerY + path[i + 1]['position'].dy);
        
        // Set color based on direction
        if (path[i]['direction'] == 'left') {
          paint.color = Colors.orange;
        } else if (path[i]['direction'] == 'right') {
          paint.color = Colors.green;
        } else if (path[i]['direction'] == 'forward') {
          paint.color = Colors.white;
        }
        
        // Draw the path segment
        canvas.drawLine(startPoint, endPoint, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

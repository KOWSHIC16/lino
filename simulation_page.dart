import 'dart:async';
import 'package:flutter/material.dart';

class SimulationPage extends StatefulWidget {
  final List<Map<String, dynamic>> path;
  SimulationPage({required this.path});

  @override
  _SimulationPageState createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  late List<Map<String, dynamic>> path;
  int currentIndex = 0;
  Timer? _timer;
  Timer? _directionTimer;
  String currentDirection = 'STARTING'; // To display current direction
  bool leftBoxActive = false;
  bool rightBoxActive = false;

  @override
  void initState() {
    super.initState();
    path = widget.path;
    if (path.isNotEmpty) {
      _startSimulation();
    }
  }

  void _startSimulation() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (currentIndex < path.length) {
        setState(() {
          currentDirection = path[currentIndex]['direction']; // Update direction
          _updateBoxLights();
          currentIndex++;
        });
      } else {
        setState(() {
          currentDirection = 'STOPPED'; // Set direction to 'Stop' when pathway is completed
          leftBoxActive = false;
          rightBoxActive = false;
        });
        _timer?.cancel();
      }
    });
  }

  void _updateBoxLights() {
    if (currentDirection == 'left') {
      leftBoxActive = true;
      rightBoxActive = false;
    } else if (currentDirection == 'right') {
      leftBoxActive = false;
      rightBoxActive = true;
    } else if (currentDirection == 'forward') {
      leftBoxActive = true;
      rightBoxActive = true;
    } else if (currentDirection == 'Stop') {
      leftBoxActive = true;
      rightBoxActive = true;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _directionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121721),
      appBar: AppBar(
        title: Text('Simulation Page'),
        backgroundColor: const Color.fromRGBO(26, 107, 229, 1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display current direction
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '$currentDirection',
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
            ),
            // Box with columns
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDirectionBox('left'),
                  SizedBox(width: 20),
                  _buildDirectionBox('right'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionBox(String direction) {
    bool isActive = direction == 'left' ? leftBoxActive : rightBoxActive;
    Color color = isActive ? Colors.white : Colors.black;
    return Container(
      width: 150,
      height: 300, // Adjusted height for vertically long rectangle
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Container(
          width: 130,
          height: 280, // Adjusted height for light in box
          color: color,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'player_provider.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();

    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlayerProvider>();
    final ambience = provider.currentAmbience;

    if (ambience == null) return const Scaffold();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF6F0),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down, size: 32),

                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    ambience.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const Spacer(),

            ScaleTransition(
              scale: _breathingAnimation,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFD1A490).withOpacity(0.5),
                    width: 15,
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD1A490).withOpacity(0.2),
                      blurRadius: 50,
                      spreadRadius: 20,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "Breathe...",
                    style: TextStyle(
                      color: Color(0xFFD1A490),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            Text(
              formatTime(provider.remainingSeconds),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  // Custom Slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFFD1A490),
                      inactiveTrackColor: const Color(
                        0xFFD1A490,
                      ).withOpacity(0.2),
                      thumbColor: const Color(0xFFD1A490),
                      overlayColor: const Color(0xFFD1A490).withOpacity(0.1),
                      trackHeight: 4.0,
                    ),
                    child: Slider(
                      min: 0,
                      max: provider.totalSeconds.toDouble(),
                      value: provider.elapsedSeconds.toDouble().clamp(
                        0,
                        provider.totalSeconds.toDouble(),
                      ),
                      onChanged: (value) {
                        // Jaise hi user slider ghumaiga, session time update hoga
                        provider.seekSession(value.toInt());
                      },
                    ),
                  ),

                  // Elapsed Time aur Total Duration
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatTime(provider.elapsedSeconds),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          formatTime(provider.totalSeconds),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

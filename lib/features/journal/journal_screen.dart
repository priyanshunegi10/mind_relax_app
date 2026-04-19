import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mind_relax_app/data/model/journal_model.dart';
import 'package:mind_relax_app/features/ambience/home_screen.dart';

class JournalScreen extends StatefulWidget {
  final String ambienceTitle;
  final int durationListened;

  const JournalScreen({
    super.key,
    required this.ambienceTitle,
    required this.durationListened,
  });

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  String _selectedMood = 'Calm';
  final TextEditingController _notesController = TextEditingController();

  final List<Map<String, String>> moods = [
    {'label': 'Calm', 'emoji': '😌'},
    {'label': 'Grounded', 'emoji': '🧘'},
    {'label': 'Energized', 'emoji': '⚡'},
    {'label': 'Sleepy', 'emoji': '😴'},
  ];

  void _saveEntryAndGoHome() async {
    final box = Hive.box<JournalEntry>('journalBox');

    final entry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      ambienceTitle: widget.ambienceTitle,
      durationListened: widget.durationListened,
      mood: _selectedMood,
      notes: _notesController.text,
      date: DateTime.now(),
    );

    await box.add(entry);

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF6F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Session Complete",
                style: TextStyle(
                  color: Color(0xFFD1A490),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "What is gently present with you right now?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: moods.map((mood) {
                  final isSelected = _selectedMood == mood['label'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMood = mood['label']!;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFD1A490)
                                : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              if (!isSelected)
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                ),
                            ],
                          ),
                          child: Text(
                            mood['emoji']!,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          mood['label']!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              const Text(
                "Any notes? (Optional)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Jot down your thoughts...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD1A490),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  onPressed: _saveEntryAndGoHome,
                  child: const Text(
                    "Save Reflection",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

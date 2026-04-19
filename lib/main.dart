import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_relax_app/data/model/journal_model.dart';
import 'package:mind_relax_app/features/ambience/ambience_provider.dart';
import 'package:mind_relax_app/features/ambience/home_screen.dart';
import 'package:mind_relax_app/features/journal/journal_provider.dart';
import 'package:mind_relax_app/features/player/player_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(JournalEntryAdapter());
  await Hive.openBox<JournalEntry>('journalBox');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AmbienceProvider()),
        ChangeNotifierProvider(create: (_) => JournalProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mind relax app",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFFBF6F0),
      ),
      home: HomeScreen(),
    );
  }
}

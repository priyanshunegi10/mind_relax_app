# MindRelax - Meditation & Ambience App

MindRelax is a calming Flutter application designed to help users focus, relax, and sleep using background ambiences. It features a continuous audio player, custom breathing animations, and a local journal to save daily reflections.

---

## 🚀 How to Run the Project

1. **Clone the repository:**
2. cd mind_relax_app
3. flutter pub get
4. flutter run
  
## 🏗️ Architecture Explanation
The app follows a clean, feature-first modular architecture to keep the code scalable and easy to read.

1. Folder Structure
lib/data/: Contains data models (ambience_model, journal_model) and local database setup.
lib/features/: The core of the app. It is divided by feature rather than by type:
ambience/: Home screen, JSON parsing, and search/filter logic.
player/: The audio player screen, breathing animation, and mini-player widget.
journal/: The reflection screen and history viewer.
assets/: Contains the local JSON file, audio tracks, and images.


3. State Management Approach
I chose Provider for state management. Since the app requires tracking the audio player state (playing, paused, elapsed time) and updating multiple screens (Player Screen and Mini-Player) simultaneously, Provider offers a simple, reactive, and highly efficient way to manage this without writing boilerplate code.


4. Data Flow (Repository → Controller → UI)
The app strictly follows a unidirectional data flow:
Repository (Data Layer): The app fetches raw data (either reading the ambiences from the local JSON file or fetching saved journal entries from the Hive database).
Controller (Provider Layer): The AmbienceProvider and PlayerProvider act as controllers. They take the raw data from the repository, apply business logic (like search filtering, timer countdowns, and modulo audio seeking), and hold the state.
UI (Presentation Layer): The screens (HomeScreen, PlayerScreen) simply listen to the Controllers (Providers) using context.watch() or Consumer. When the controller updates the state, the UI automatically rebuilds to show the new data.


📦 Packages Used
provider: Chosen for state management because it is officially recommended, lightweight, and perfect for managing global states like an audio player.
just_audio: Chosen for audio playback because it handles looping (LoopMode.one) and background tracking much better than other audio plugins.
hive & hive_flutter: Chosen for local data persistence. It is a NoSQL database that is incredibly fast and works perfectly for saving small user journal entries without the heavy setup of SQLite.


⚖️ Tradeoffs & Future Improvements
What would I improve if I had two more days?
Persistent Audio State: Right now, if the app is completely killed from memory, the session timer resets. With more time, I would save the current elapsedSeconds in Hive so the user can resume exactly where they left off.
Real Backend Integration: Currently, ambiences are loaded from a local JSON file. I would replace this with a Firebase backend so new audio files can be added without updating the app.
Advanced Animations: I would convert the current simple breathing ScaleTransition into a more complex CustomPainter animation for a more organic, fluid visual experience.

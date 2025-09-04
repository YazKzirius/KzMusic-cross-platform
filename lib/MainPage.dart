import 'package:flutter/material.dart';

// --- Placeholder Pages for each tab ---
// In a real app, these would be in their own files.
class BrowsePage extends StatelessWidget {
  const BrowsePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Browse Page', style: TextStyle(color: Colors.white)));
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Search Page', style: TextStyle(color: Colors.white)));
  }
}

class GenAiPage extends StatelessWidget {
  const GenAiPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('GenAI Page', style: TextStyle(color: Colors.white)));
  }
}

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Library Page', style: TextStyle(color: Colors.white)));
  }
}

class UserSettingsPage extends StatelessWidget {
  const UserSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('User Settings Page', style: TextStyle(color: Colors.white)));
  }
}


// --- The Main Page Widget ---

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 1. State variable to keep track of the currently selected tab index.
  int _selectedIndex = 0;

  // 2. A list of the widgets to display for each tab.
  static const List<Widget> _pageOptions = <Widget>[
    BrowsePage(),
    SearchPage(),
    GenAiPage(),
    LibraryPage(),
    UserSettingsPage(),
  ];

  // 3. A function that updates the state when a tab is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 4. The Scaffold widget provides the main layout structure.
    return Scaffold(
      backgroundColor: const Color(0xFF090909),

      // 5. The body displays the currently selected page widget.
      body: _pageOptions.elementAt(_selectedIndex),

      // 6. The BottomNavigationBar widget is the Flutter equivalent of BottomNavigationView.
      bottomNavigationBar: BottomNavigationBar(
        // 7. These are the items (tabs) to display in the navigation bar.
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.electric_bolt_outlined),
            label: 'GenAI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'User Settings',
          ),
        ],
        // 8. Styling and state properties for the navigation bar.
        currentIndex: _selectedIndex, // Highlights the correct tab.
        onTap: _onItemTapped, // Calls our function when a tab is tapped.

        // --- Styling ---
        type: BottomNavigationBarType.fixed, // Ensures all labels are visible.
        backgroundColor: Colors.white, // Equivalent to `?android:attr/windowBackground`.
        selectedItemColor: Colors.deepPurple, // Color for the active tab's icon and label.
        unselectedItemColor: Colors.grey.shade600, // Color for inactive tabs.
      ),
    );
  }
}
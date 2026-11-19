import 'package:flutter/material.dart';
import 'home_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // এখানে আমরা পরবর্তীতে বাকি স্ক্রিনগুলো যোগ করব
  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text("To-Do Screen Coming Soon")),
    const SizedBox(), // Add বাটনের জন্য ফাঁকা রাখা হলো
    const Center(child: Text("Stats Screen Coming Soon")),
    const Center(child: Text("More Screen Coming Soon")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1877F2), // Facebook Blue
        unselectedItemColor: const Color(0xFF65676B),
        onTap: (index) {
          if (index == 2) {
            // মাঝখানের প্লাস বাটনে ক্লিক করলে যা হবে (পরবর্তীতে জানাবো)
            return;
          }
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'To-Do'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40, color: Color(0xFF1877F2)), 
            label: 'Add'
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'More'),
        ],
      ),
    );
  }
}

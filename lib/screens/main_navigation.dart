import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'add_transaction_screen.dart';
import 'todo_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  
  // Home Screen রিফ্রেশ করার জন্য Key
  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();

  @override
  Widget build(BuildContext context) {
    // স্ক্রিন লিস্ট এখানে তৈরি করা হলো, যাতে Key কাজ করে
    final List<Widget> screens = [
      HomeScreen(key: _homeKey), 
      const TodoScreen(), 
      const SizedBox(), // Add Button (খালি)
      const Center(child: Text("Stats Screen Under Construction")),
      const Center(child: Text("More Screen Under Construction")),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1877F2),
        unselectedItemColor: const Color(0xFF65676B),
        onTap: (index) {
          if (index == 2) {
            // Add Transaction Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
            ).then((value) {
              // সেভ করে ফিরে আসলে Home Screen-কে রিফ্রেশ করতে বলবে
              _homeKey.currentState?.loadData();
            });
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

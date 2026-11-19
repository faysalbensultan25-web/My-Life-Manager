import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'add_transaction_screen.dart';
import 'todo_screen.dart';
import 'history_screen.dart'; 
import 'more_screen.dart';
import 'note_screen.dart'; // Note Screen ইম্পোর্ট

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();

  // Add Menu BottomSheet
  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('What do you want to add?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const CircleAvatar(backgroundColor: Color(0xFF42B72A), child: Icon(Icons.arrow_downward, color: Colors.white)),
                title: const Text('Add Income'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTransactionScreen(isIncome: true))).then((_) => _homeKey.currentState?.loadData());
                },
              ),
              ListTile(
                leading: const CircleAvatar(backgroundColor: Color(0xFFFA383E), child: Icon(Icons.arrow_upward, color: Colors.white)),
                title: const Text('Add Expense'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTransactionScreen(isIncome: false))).then((_) => _homeKey.currentState?.loadData());
                },
              ),
              ListTile(
                leading: const CircleAvatar(backgroundColor: Color(0xFF1877F2), child: Icon(Icons.check_box, color: Colors.white)),
                title: const Text('Add To-Do Task'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _currentIndex = 1); // Go to To-Do Tab
                },
              ),
              ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.note, color: Colors.white)),
                title: const Text('Add Daily Note'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NoteScreen())).then((_) => _homeKey.currentState?.loadData());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(key: _homeKey), 
      const TodoScreen(), 
      const SizedBox(),
      const HistoryScreen(), 
      const MoreScreen(), 
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
            _showAddMenu(); // Show Bottom Sheet
            return;
          }
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'To-Do'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 40, color: Color(0xFF1877F2)), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'More'),
        ],
      ),
    );
  }
}

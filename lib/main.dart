import 'package:flutter/material.dart';

void main() {
  runApp(const MyLifeManager());
}

class MyLifeManager extends StatelessWidget {
  const MyLifeManager({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Life Manager',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Life Manager'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Welcome to My Life Manager',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _menu(Icons.check_circle_outline, 'To-Do List'),
          _menu(Icons.edit_note, 'Daily Note'),
          _menu(Icons.account_balance_wallet, 'Income & Expense'),
          _menu(Icons.history, 'Recent History'),
          _menu(Icons.calendar_month, 'Monthly Summary'),
          _menu(Icons.bar_chart, 'Statistics'),
          _menu(Icons.settings, 'Settings'),
        ],
      ),
    );
  }

  Widget _menu(IconData icon, String title) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

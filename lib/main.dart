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
          _menu(context, Icons.check_circle_outline, 'To-Do List'),
          _menu(context, Icons.edit_note, 'Daily Note'),
          _menu(context, Icons.account_balance_wallet, 'Income & Expense'),
          _menu(context, Icons.history, 'Recent History'),
          _menu(context, Icons.calendar_month, 'Monthly Summary'),
          _menu(context, Icons.bar_chart, 'Statistics'),
          _menu(context, Icons.settings, 'Settings'),
        ],
      ),
    );
  }

  // এখানে context যুক্ত করা হয়েছে এবং onTap দেওয়া হয়েছে
  Widget _menu(BuildContext context, IconData icon, String title) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // ক্লিক করলে নতুন পেজে নিয়ে যাবে
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaceholderPage(title: title),
            ),
          );
        },
      ),
    );
  }
}

// নতুন পেজ দেখানোর জন্য একটি সাধারণ প্লেসহোল্ডার পেজ
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          '$title Page\n(Coming Soon)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

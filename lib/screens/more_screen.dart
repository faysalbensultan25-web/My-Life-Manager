import 'package:flutter/material.dart';
import 'note_screen.dart';
import 'profile_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text('More'),
        backgroundColor: const Color(0xFF1877F2),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuTile(
            context, 
            icon: Icons.person, 
            title: 'My Profile & Guest Mode', 
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())).then((_) => (context as Element).markNeedsBuild()),
          ),
          _buildMenuTile(
            context, 
            icon: Icons.note_add, 
            title: 'Daily Notes', 
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NoteScreen())).then((_) => (context as Element).markNeedsBuild()),
          ),
          _buildMenuTile(
            context, 
            icon: Icons.category, 
            title: 'Category Manager', 
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coming soon!')));
            },
          ),
          _buildMenuTile(
            context, 
            icon: Icons.settings, 
            title: 'Settings', 
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coming soon!')));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1877F2)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

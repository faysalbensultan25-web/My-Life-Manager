import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFF1877F2),
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Good Morning!',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
                Text(
                  'Faysal Ben Sultan',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black54),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    title: 'Today Income',
                    amount: '৳ 2,500',
                    color: const Color(0xFF42B72A),
                    icon: Icons.arrow_downward,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    title: 'Today Expense',
                    amount: '৳ 850',
                    color: const Color(0xFFFA383E),
                    icon: Icons.arrow_upward,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1877F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Total Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 5),
                  Text('৳ 1,650', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Today's To-Do (2)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('See All', style: TextStyle(color: Color(0xFF1877F2))),
              ],
            ),
            const SizedBox(height: 10),
            _buildTaskCard('Bazar Kora', true),
            _buildTaskCard('Office Report Joma', false),

            const SizedBox(height: 20),

            const Text("Today's Daily Note", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.note, color: Colors.red),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Aj khub valo din chilo!', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('10:30 AM', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({required String title, required String amount, required Color color, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 5),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(amount, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTaskCard(String title, bool isDone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked, color: isDone ? const Color(0xFF42B72A) : Colors.grey),
        title: Text(title, style: TextStyle(decoration: isDone ? TextDecoration.lineThrough : null)),
        trailing: const Icon(Icons.more_vert),
      ),
    );
  }
}

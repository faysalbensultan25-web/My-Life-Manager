import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_helper.dart';
import '../models/transaction_model.dart';
import '../models/task_model.dart';
import '../models/note_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState(); 
}

class HomeScreenState extends State<HomeScreen> {
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double totalBalance = 0.0;
  
  List<TransactionModel> recentTransactions = [];
  List<TaskModel> recentTasks = [];
  List<NoteModel> recentNotes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    
    final transactions = await DatabaseHelper().getAllTransactions();
    final tasks = await DatabaseHelper().getAllTasks();
    final notes = await DatabaseHelper().getAllNotes();

    double income = 0.0;
    double expense = 0.0;

    for (var t in transactions) {
      if (t.type == 'Income') income += t.amount;
      else expense += t.amount;
    }

    setState(() {
      totalIncome = income;
      totalExpense = expense;
      totalBalance = income - expense;
      recentTransactions = transactions.take(3).toList(); 
      recentTasks = tasks.where((t) => t.isCompleted == 0).take(2).toList(); // Only incomplete tasks
      recentNotes = notes.take(2).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '৳ ', decimalDigits: 0);

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
                Text('Welcome back,', style: TextStyle(color: Colors.black54, fontSize: 12)),
                Text('User', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.black54), onPressed: loadData)
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Income/Expense Cards
                    Row(
                      children: [
                        Expanded(child: _buildSummaryCard(title: 'Income', amount: currencyFormatter.format(totalIncome), color: const Color(0xFF42B72A), icon: Icons.arrow_downward)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSummaryCard(title: 'Expense', amount: currencyFormatter.format(totalExpense), color: const Color(0xFFFA383E), icon: Icons.arrow_upward)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Balance Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: const Color(0xFF1877F2), borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 5),
                          Text(currencyFormatter.format(totalBalance), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Recent To-Dos
                    if (recentTasks.isNotEmpty) ...[
                      const Text("Upcoming Tasks", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ...recentTasks.map((task) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.radio_button_unchecked, color: Colors.grey),
                          title: Text(task.title),
                        ),
                      )).toList(),
                      const SizedBox(height: 20),
                    ],

                    // Recent Notes
                    if (recentNotes.isNotEmpty) ...[
                      const Text("Recent Notes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ...recentNotes.map((note) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.note, color: Colors.orange),
                          title: Text(note.title),
                          subtitle: Text(note.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      )).toList(),
                      const SizedBox(height: 20),
                    ],

                    // Recent Transactions
                    const Text("Recent Transactions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    if (recentTransactions.isEmpty)
                      const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('No transactions yet.', style: TextStyle(color: Colors.grey))))
                    else
                      ...recentTransactions.map((t) => _buildTransactionCard(t, currencyFormatter)).toList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryCard({required String title, required String amount, required Color color, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
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
          FittedBox(child: Text(amount, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(TransactionModel t, NumberFormat formatter) {
    bool isIncome = t.type == 'Income';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome ? const Color(0xFF42B72A).withOpacity(0.1) : const Color(0xFFFA383E).withOpacity(0.1),
          child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: isIncome ? const Color(0xFF42B72A) : const Color(0xFFFA383E)),
        ),
        title: Text(t.note.isEmpty ? t.categoryName ?? 'Transaction' : t.note, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(t.date),
        trailing: Text('${isIncome ? '+' : '-'} ${formatter.format(t.amount)}', style: TextStyle(color: isIncome ? const Color(0xFF42B72A) : const Color(0xFFFA383E), fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_helper.dart';
import '../models/transaction_model.dart';

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    
    final transactions = await DatabaseHelper().getAllTransactions();

    double income = 0.0;
    double expense = 0.0;

    for (var t in transactions) {
      if (t.type == 'Income') {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }

    setState(() {
      totalIncome = income;
      totalExpense = expense;
      totalBalance = income - expense;
      recentTransactions = transactions.take(5).toList(); 
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
                Text('Good Morning!', style: TextStyle(color: Colors.black54, fontSize: 12)),
                Text('Faysal Ben Sultan', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black54),
            onPressed: loadData, 
          )
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
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            title: 'Total Income',
                            amount: currencyFormatter.format(totalIncome),
                            color: const Color(0xFF42B72A),
                            icon: Icons.arrow_downward,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryCard(
                            title: 'Total Expense',
                            amount: currencyFormatter.format(totalExpense),
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
                        children: [
                          const Text('Total Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 5),
                          Text(currencyFormatter.format(totalBalance), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text("Recent Transactions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    
                    if (recentTransactions.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('No transactions yet. Add some!', style: TextStyle(color: Colors.grey)),
                        ),
                      )
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
          FittedBox(
            child: Text(amount, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ),
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
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? const Color(0xFF42B72A) : const Color(0xFFFA383E),
          ),
        ),
        title: Text(t.note.isEmpty ? t.categoryName ?? 'Transaction' : t.note, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(t.date, style: const TextStyle(fontSize: 12)),
        trailing: Text(
          '${isIncome ? '+' : '-'} ${formatter.format(t.amount)}',
          style: TextStyle(
            color: isIncome ? const Color(0xFF42B72A) : const Color(0xFFFA383E),
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
        ),
      ),
    );
  }
}

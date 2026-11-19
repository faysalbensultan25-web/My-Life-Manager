import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../services/database_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<TransactionModel> allTransactions = [];
  List<TransactionModel> filteredTransactions = [];
  List<Map<String, dynamic>> monthlyIncome = [];
  List<Map<String, dynamic>> monthlyExpense = [];
  
  String selectedFilter = 'All';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadMonthlyStats();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    final data = await DatabaseHelper().getAllTransactions();
    setState(() {
      allTransactions = data;
      _applyFilter(selectedFilter);
      isLoading = false;
    });
  }

  Future<void> _loadMonthlyStats() async {
    final inc = await DatabaseHelper().getMonthlyCategorySummary('Income');
    final exp = await DatabaseHelper().getMonthlyCategorySummary('Expense');
    setState(() {
      monthlyIncome = inc;
      monthlyExpense = exp;
    });
  }

  void _applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      final now = DateTime.now();
      
      if (filter == 'All') {
        filteredTransactions = allTransactions;
      } else {
        filteredTransactions = allTransactions.where((t) {
          DateTime date = DateTime.parse(t.date);
          if (filter == 'Daily') {
            return date.year == now.year && date.month == now.month && date.day == now.day;
          } else if (filter == 'Weekly') {
            final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
            final endOfWeek = startOfWeek.add(const Duration(days: 6));
            return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) && date.isBefore(endOfWeek.add(const Duration(days: 1)));
          } else if (filter == 'Monthly') {
            return date.year == now.year && date.month == now.month;
          } else if (filter == 'Yearly') {
            return date.year == now.year;
          }
          return true;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '৳ ', decimalDigits: 0);

    double totalInc = 0;
    double totalExp = 0;
    for (var t in filteredTransactions) {
      if (t.type == 'Income') totalInc += t.amount;
      else totalExp += t.amount;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text('History & Stats'),
        backgroundColor: const Color(0xFF1877F2),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: ['All', 'Daily', 'Weekly', 'Monthly', 'Yearly'].map((f) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(f),
                            selected: selectedFilter == f,
                            selectedColor: const Color(0xFF1877F2),
                            labelStyle: TextStyle(color: selectedFilter == f ? Colors.white : Colors.black),
                            onSelected: (val) => _applyFilter(f),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Summary Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCol('Income', currencyFormatter.format(totalInc), const Color(0xFF42B72A)),
                        Container(height: 30, width: 1, color: Colors.grey[300]),
                        _buildStatCol('Expense', currencyFormatter.format(totalExp), const Color(0xFFFA383E)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Monthly Breakdown Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("This Month's Breakdown", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        if (monthlyExpense.isNotEmpty) ...[
                          const Text("Expense by Category:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                          ...monthlyExpense.map((e) => Text("${e['categoryName']}: ${currencyFormatter.format(e['totalAmount'])}")).toList(),
                          const SizedBox(height: 10),
                        ],
                        if (monthlyIncome.isNotEmpty) ...[
                          const Text("Income by Category:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                          ...monthlyIncome.map((e) => Text("${e['categoryName']}: ${currencyFormatter.format(e['totalAmount'])}")).toList(),
                        ],
                      ],
                    ),
                  ),

                  // List of Transactions
                  filteredTransactions.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('No transactions found', style: TextStyle(color: Colors.grey)),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final t = filteredTransactions[index];
                            bool isIncome = t.type == 'Income';
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isIncome ? const Color(0xFF42B72A).withOpacity(0.1) : const Color(0xFFFA383E).withOpacity(0.1),
                                  child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: isIncome ? const Color(0xFF42B72A) : const Color(0xFFFA383E)),
                                ),
                                title: Text(t.note.isEmpty ? 'Transaction' : t.note, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(t.date),
                                trailing: Text(
                                  '${isIncome ? '+' : '-'} ${currencyFormatter.format(t.amount)}',
                                  style: TextStyle(color: isIncome ? const Color(0xFF42B72A) : const Color(0xFFFA383E), fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            );
                          },
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCol(String title, String amount, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
      ],
    );
  }
}

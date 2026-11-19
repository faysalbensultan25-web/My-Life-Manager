import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../services/database_helper.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  bool isIncome = true;
  CategoryModel? selectedCategory;
  DateTime selectedDate = DateTime.now();
  List<CategoryModel> categories = [];
  bool isLoadingCats = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => isLoadingCats = true);
    final cats = await DatabaseHelper().getCategories(isIncome ? 'Income' : 'Expense');
    setState(() {
      categories = cats;
      selectedCategory = cats.isNotEmpty ? cats.first : null;
      isLoadingCats = false;
    });
  }

  Future<void> _saveTransaction() async {
    if (_amountController.text.isEmpty || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter amount and select category')),
      );
      return;
    }

    final transaction = TransactionModel(
      amount: double.parse(_amountController.text),
      type: isIncome ? 'Income' : 'Expense',
      categoryId: selectedCategory!.id!,
      date: DateFormat('yyyy-MM-dd').format(selectedDate),
      note: _noteController.text,
    );

    await DatabaseHelper().insertTransaction(transaction);
    
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20, 
        left: 16, 
        right: 16, 
        top: 20
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 50, 
                height: 5, 
                decoration: BoxDecoration(
                  color: Colors.grey[300], 
                  borderRadius: BorderRadius.circular(10)
                )
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => isIncome = true);
                      _loadCategories();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isIncome ? const Color(0xFF42B72A) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Income', 
                          style: TextStyle(
                            color: isIncome ? Colors.white : Colors.black, 
                            fontWeight: FontWeight.bold
                          )
                        )
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => isIncome = false);
                      _loadCategories();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !isIncome ? const Color(0xFFFA383E) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Expense', 
                          style: TextStyle(
                            color: !isIncome ? Colors.white : Colors.black, 
                            fontWeight: FontWeight.bold
                          )
                        )
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount', 
                border: OutlineInputBorder(), 
                prefixIcon: Icon(Icons.attach_money)
              ),
            ),
            const SizedBox(height: 15),
            isLoadingCats 
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonFormField<CategoryModel>(
                  decoration: const InputDecoration(
                    labelText: 'Category', 
                    border: OutlineInputBorder(), 
                    prefixIcon: Icon(Icons.category)
                  ),
                  value: selectedCategory,
                  items: categories.map((cat) => DropdownMenuItem<CategoryModel>(
                    value: cat, 
                    child: Text(cat.name)
                  )).toList(),
                  onChanged: (newValue) => setState(() => selectedCategory = newValue),
                ),
            const SizedBox(height: 15),
            InkWell(
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context, 
                  initialDate: selectedDate, 
                  firstDate: DateTime(2000), 
                  lastDate: DateTime(2100)
                );
                if (pickedDate != null) setState(() => selectedDate = pickedDate);
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date', 
                  border: OutlineInputBorder(), 
                  prefixIcon: Icon(Icons.calendar_today)
                ),
                child: Text(DateFormat('dd MMM yyyy').format(selectedDate)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note (Optional)', 
                border: OutlineInputBorder(), 
                prefixIcon: Icon(Icons.note)
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: isIncome ? const Color(0xFF42B72A) : const Color(0xFFFA383E),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Save Transaction', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

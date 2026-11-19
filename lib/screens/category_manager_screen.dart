import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/database_helper.dart';

class CategoryManagerScreen extends StatefulWidget {
  const CategoryManagerScreen({super.key});

  @override
  State<CategoryManagerScreen> createState() => _CategoryManagerScreenState();
}

class _CategoryManagerScreenState extends State<CategoryManagerScreen> {
  List<CategoryModel> incomeCats = [];
  List<CategoryModel> expenseCats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => isLoading = true);
    final inc = await DatabaseHelper().getCategories('Income');
    final exp = await DatabaseHelper().getCategories('Expense');
    setState(() {
      incomeCats = inc;
      expenseCats = exp;
      isLoading = false;
    });
  }

  void _showAddCategoryDialog(String type) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add $type Category'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Category Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final newCat = CategoryModel(
                  name: nameController.text.trim(),
                  type: type,
                  iconCode: type == 'Income' ? '0xe148' : '0xe56c',
                  colorCode: type == 'Income' ? 0xFF42B72A : 0xFFFA383E,
                );
                await DatabaseHelper().insertCategory(newCat);
                if (mounted) Navigator.pop(context);
                _loadCategories();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCategory(int id) async {
    await DatabaseHelper().deleteCategory(id);
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F2F5),
        appBar: AppBar(
          title: const Text('Category Manager'),
          backgroundColor: const Color(0xFF1877F2),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Income'),
              Tab(text: 'Expense'),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildCategoryList(incomeCats, 'Income'),
                  _buildCategoryList(expenseCats, 'Expense'),
                ],
              ),
      ),
    );
  }

  Widget _buildCategoryList(List<CategoryModel> cats, String type) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () => _showAddCategoryDialog(type),
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text('Add New $type Category', style: const TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: type == 'Income' ? const Color(0xFF42B72A) : const Color(0xFFFA383E),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cats.length,
            itemBuilder: (context, index) {
              final cat = cats[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: ListTile(
                  leading: Icon(
                    Icons.category, 
                    color: type == 'Income' ? const Color(0xFF42B72A) : const Color(0xFFFA383E)
                  ),
                  title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCategory(cat.id!),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

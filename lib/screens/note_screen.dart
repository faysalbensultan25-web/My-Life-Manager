import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/note_model.dart';
import '../services/database_helper.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  List<NoteModel> notes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => isLoading = true);
    final data = await DatabaseHelper().getAllNotes();
    setState(() { notes = data; isLoading = false; });
  }

  void _showAddNoteDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                final newNote = NoteModel(title: titleController.text, description: descController.text, date: DateTime.now().toString().split(' ')[0]);
                await DatabaseHelper().insertNote(newNote);
                if (mounted) Navigator.pop(context);
                _loadNotes();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(title: const Text('Daily Notes'), backgroundColor: const Color(0xFF1877F2)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
              ? const Center(child: Text('No notes yet. Add one!', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: const CircleAvatar(backgroundColor: Color(0xFFE7F3FF), child: Icon(Icons.note, color: Color(0xFF1877F2))),
                        title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(note.description),
                        trailing: IconButton(
                          icon: const Icon(Icons.share, color: Color(0xFF1877F2)),
                          onPressed: () {
                            Share.share('${note.title}\n\n${note.description}\nDate: ${note.date}\n\nShared via My Life Manager');
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1877F2),
        onPressed: _showAddNoteDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

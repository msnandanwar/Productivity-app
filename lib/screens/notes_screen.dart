import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';
import '../services/note_service.dart';
import 'package:intl/intl.dart';

class NotesScreen extends StatefulWidget {
  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Note>('notes').listenable(),
        builder: (context, Box<Note> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text('No notes yet! Tap + to add.',
                  style: TextStyle(fontSize: 18, color: Colors.pink[200])),
            );
          }
          final notes = box.values.toList();
          notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            itemCount: notes.length,
            separatorBuilder: (_, __) => SizedBox(height: 8),
            itemBuilder: (context, i) {
              final note = notes[i];
              return Dismissible(
                key: ValueKey(note.key),
                background: Container(color: Colors.red[100], alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: 24), child: Icon(Icons.delete, color: Colors.red)),
                direction: DismissDirection.startToEnd,
                onDismissed: (_) async {
                  await NoteService.deleteNote(note);
                },
                child: Card(
                  color: Colors.pink[50],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(note.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(note.content, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54)),
                        SizedBox(height: 4),
                        Text(DateFormat('MMM d, yyyy – h:mm a').format(note.createdAt), style: TextStyle(fontSize: 12, color: Colors.pink[300])),
                      ],
                    ),
                    onTap: () => _showEditNoteDialog(context, note),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Add Note',
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final _titleController = TextEditingController();
    final _contentController = TextEditingController();
    bool isLoading = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 480,
                  maxHeight: MediaQuery.of(context).size.height * 0.88,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.85),
                      Colors.pink[50]!.withOpacity(0.85),
                      Colors.teal[50]!.withOpacity(0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 32,
                      offset: Offset(0, 16),
                    ),
                  ],
                  border: Border.all(color: Colors.pink[100]!, width: 1.2),
                  backgroundBlendMode: BlendMode.overlay,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.sticky_note_2_rounded, size: 48, color: Colors.pink[300]),
                        SizedBox(height: 8),
                        Text(
                          'New Note',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Colors.pink[400],
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Capture your thoughts instantly',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 22),
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            prefixIcon: Icon(Icons.title_rounded, color: Colors.pink[200]),
                          ),
                          style: TextStyle(fontSize: 18),
                          autofocus: true,
                        ),
                        SizedBox(height: 14),
                        TextField(
                          controller: _contentController,
                          decoration: InputDecoration(
                            labelText: 'Content',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            prefixIcon: Icon(Icons.notes_rounded, color: Colors.teal[200]),
                          ),
                          style: TextStyle(fontSize: 16),
                          maxLines: 7,
                          minLines: 3,
                        ),
                        SizedBox(height: 28),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 180),
                          curve: Curves.easeInOut,
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink[300],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 3,
                              shadowColor: Colors.pink[100],
                              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add, size: 22),
                                      SizedBox(width: 8),
                                      Text('Add Note'),
                                    ],
                                  ),
                            onPressed: isLoading
                                ? null
                                : () async {
                                    if (_titleController.text.trim().isEmpty && _contentController.text.trim().isEmpty) return;
                                    isLoading = true;
                                    (context as Element).markNeedsBuild();
                                    final newNote = Note(
                                      title: _titleController.text.trim().isEmpty ? '(Untitled)' : _titleController.text.trim(),
                                      content: _contentController.text.trim(),
                                    );
                                    await NoteService.addNote(newNote);
                                    isLoading = false;
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditNoteDialog(BuildContext context, Note note) {
    final _titleController = TextEditingController(text: note.title);
    final _contentController = TextEditingController(text: note.content);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 0,
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 24,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Edit Note', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink[400])),
                          SizedBox(height: 16),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 12),
                          TextField(
                            controller: _contentController,
                            decoration: InputDecoration(
                              labelText: 'Content',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 5,
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink[200],
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text('Save Changes'),
                              onPressed: () async {
                                note.title = _titleController.text.trim().isEmpty ? '(Untitled)' : _titleController.text.trim();
                                note.content = _contentController.text.trim();
                                await NoteService.updateNote(note);
                                Navigator.pop(context);
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

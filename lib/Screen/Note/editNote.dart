import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

import '../../local_storage/model/NoteModel.dart';
import '../../local_storage/service/NoteDatabaseService.dart';

class EditNoteScreen extends StatefulWidget {
  int id;
  EditNoteScreen(this.id);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  DataBaseService db = DataBaseService();
  QuillController controller = QuillController.basic();

  late NoteModel note;
  bool _loading = true;

  @override
  initState() {
    _getNote();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  _getNote() async {
    NoteModel model = await db.getNote(widget.id);
    setState(() {
      note = model;
    });
    var decodedContent = jsonDecode(model.content);
    controller = QuillController(
        document: Document.fromJson(decodedContent),
        selection: const TextSelection.collapsed(offset: 0));
  }

  //save note method
  _saveNote() {
    String title = '';
    //title
    if (controller.document.length >= 5) {
      title =
          '${controller.document.toPlainText().toString().substring(0, 5)}...';
    } else {
      title =
          '${controller.document.toPlainText().toString().substring(0, controller.document.length)}...';
    }
    //createAt
    String time = DateTime.now().toString();
    //content
    String encodedContent = jsonEncode(controller.document.toDelta().toJson());
    DataBaseService db = DataBaseService();
    db.createNote(NoteModel(widget.id, title, encodedContent, note.createdAt, time));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Content Saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'bee-Note-ify',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _loading
          ? LinearProgressIndicator()
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
              child: Column(
                children: [
                  SizedBox(
                    height: 45,
                    child: QuillToolbar.basic(
                      controller: controller,
                      toolbarIconSize: 23,
                      multiRowsDisplay: false,
                      showImageButton: false,
                      showRedo: false,
                      showUndo: false,
                      showVideoButton: false,
                      showAlignmentButtons: false,
                      showIndent: false,
                      showLink: false,
                      showColorButton: false,
                      showBackgroundColorButton: false,
                      showClearFormat: false,
                      showFontSize: false,
                      showStrikeThrough: false,
                      showCodeBlock: false,
                      showInlineCode: false,
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.black26,
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: QuillEditor.basic(
                        controller: controller, readOnly: false),
                  ))
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _saveNote,
          label: const Text(
            'Save',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          )),
    );
  }
}

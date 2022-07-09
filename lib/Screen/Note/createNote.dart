import 'dart:convert';

import 'package:bee_note_fy/local_storage/model/NoteModel.dart';
import 'package:bee_note_fy/local_storage/service/NoteDatabaseService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class CreateNoteScreen extends StatelessWidget {
  const CreateNoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuillController controller = QuillController.basic();
    //save note method
    _saveNote() {
      print('save note at ${DateTime.now()}');
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
      String encodedContent =
          jsonEncode(controller.document.toDelta().toJson());
      // var decodedContent = jsonDecode(encodedContent);
      // print(decodedContent.runtimeType);
      DataBaseService db = DataBaseService();
      db.createNote(
          NoteModel(UniqueKey().hashCode, title, encodedContent, time, time));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Content Saved')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Note',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: QuillEditor.basic(controller: controller, readOnly: false),
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

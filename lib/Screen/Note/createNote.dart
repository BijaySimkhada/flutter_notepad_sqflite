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

    //save note Method
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
      if (controller.document.toPlainText().toString().length > 1) {
        // createAt
        String time = DateTime.now().toString();
        //content
        String encodedContent =
            jsonEncode(controller.document.toDelta().toJson());

        DataBaseService db = DataBaseService();
        db.createNote(
            NoteModel(UniqueKey().hashCode, title, encodedContent, time, time));
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Content Saved')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Insufficient Content')));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Note',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: QuillProvider(
        configurations: QuillConfigurations(
          controller: controller
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
          child: Column(
            children: [
              const SizedBox(
                height: 45,
                child: QuillToolbar(configurations: QuillToolbarConfigurations(
                    multiRowsDisplay: false,
                    showRedo: false,
                    showUndo: false,
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
                ),),
              ),
              const Divider(
                thickness: 1,
                color: Colors.black26,
              ),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: QuillEditor.basic(
                  configurations: const QuillEditorConfigurations(
                    readOnly: false
                  ),
                ),
              ))
            ],
          ),
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

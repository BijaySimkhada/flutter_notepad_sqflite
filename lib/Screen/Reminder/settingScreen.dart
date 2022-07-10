import 'package:bee_note_fy/local_storage/service/NoteDatabaseService.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  int id;
  SettingScreen(this.id, {super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  deleteNote() async {
    DataBaseService service = DataBaseService();
    int result = await service.deleteNote(widget.id);
    if (result == 1) {
      print(result.runtimeType);
      Navigator.popUntil(context, ModalRoute.withName('/'));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Unable to Delete')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: TextButton(
                        onPressed: deleteNote,
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ])
        ],
      ),
    );
  }
}

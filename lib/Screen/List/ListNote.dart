import 'package:bee_note_fy/Screen/Note/editNote.dart';
import 'package:bee_note_fy/local_storage/service/NoteDatabaseService.dart';
import 'package:flutter/material.dart';

import '../../local_storage/model/NoteModel.dart';

class ListNoteScreen extends StatefulWidget {
  const ListNoteScreen({Key? key}) : super(key: key);

  @override
  State<ListNoteScreen> createState() => _ListNoteScreenState();
}

class _ListNoteScreenState extends State<ListNoteScreen> {
  bool _isloading = true;
  List<NoteModel> _list = [];

  @override
  initState() {
    getList();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isloading = false;
      });
    });
    super.initState();
  }

  getList() async {
    DataBaseService db = DataBaseService();
    _list = await db.getNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                getList();
              },
              icon: const Icon(Icons.refresh_sharp))
        ],
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: _isloading
              ? Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                )
              : _list.isEmpty
                  ? const ListTile(
                      leading: Icon(Icons.note),
                      title: Text('No Notes! Create a new one'),
                    )
                  : ListView.builder(
                      itemCount: _list.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: const Icon(Icons.notes),
                          title: Text(_list[index].title),
                          subtitle:
                              Text('Created At:${_list[index].createdAt}'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditNoteScreen(_list[index].id)));
                            // DataBaseService db = DataBaseService();
                            // db.getNote(_list[index].id);
                          },
                        );
                      })),
      floatingActionButton: FloatingActionButton(
        isExtended: false,
        onPressed: () {
          Navigator.pushNamed(context, '/create-note');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

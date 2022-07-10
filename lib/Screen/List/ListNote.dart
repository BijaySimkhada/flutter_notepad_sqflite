import 'package:bee_note_fy/Screen/Note/editNote.dart';
import 'package:bee_note_fy/Screen/Reminder/settingScreen.dart';
import 'package:bee_note_fy/local_storage/service/NoteDatabaseService.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../local_storage/model/NoteModel.dart';
import '../../routeHelper/Helper.dart';

class ListNoteScreen extends StatefulWidget {
  const ListNoteScreen({Key? key}) : super(key: key);

  @override
  State<ListNoteScreen> createState() => _ListNoteScreenState();
}

class _ListNoteScreenState extends State<ListNoteScreen> with RouteAware {
  bool _isloading = true;
  List<NoteModel> _list = [];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    _refreshController.refreshCompleted();
  }

  @override
  void didPopNext() {
    getList();
    super.didPopNext();
  }

  @override
  initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Helper.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    });
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
        centerTitle: true,
        title: const Text(
          'Notes',
          style: TextStyle(color: Colors.white),
        ),
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
                  : SmartRefresher(
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      header: const WaterDropHeader(),
                      child: ListView.builder(
                          itemCount: _list.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: SizedBox(
                                height: 80,
                                child: ListTile(
                                  leading: const Icon(Icons.notes),
                                  title: Text(_list[index].title),
                                  subtitle: Text(
                                      'Created At:${_list[index].createdAt}'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditNoteScreen(
                                                    _list[index].id)));
                                    // DataBaseService db = DataBaseService();
                                    // db.getNote(_list[index].id);
                                  },
                                  trailing: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SettingScreen(
                                                      _list[index].id)));
                                    },
                                    icon: const Icon(Icons.settings),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )),
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

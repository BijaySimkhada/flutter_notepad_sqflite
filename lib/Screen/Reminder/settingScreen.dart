import 'package:bee_note_fy/local_storage/service/NoteDatabaseService.dart';
import 'package:flutter/material.dart';

import '../../routeHelper/Helper.dart';

class SettingScreen extends StatefulWidget {
  int id;
  SettingScreen(this.id, {super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with RouteAware {
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Helper.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    });
    super.initState();
  }

  deleteNote() async {
    DataBaseService service = DataBaseService();
    int result = await service.deleteNote(widget.id);
    if (result == 1) {
      Navigator.popUntil(context, ModalRoute.withName('/'));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Unable to Delete')));
    }
  }

  selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 16)));
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  selectTime(BuildContext context) async {
    var time =
        await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          initialEntryMode: TimePickerEntryMode.input
        );
    if (time != null && time != _time) {
      setState(() {
        _time = time;
      });
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ListTile(
                trailing: Icon(Icons.settings),
                title: Text(
                  'Reminder Settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text('Date ${_date.year}/${_date.month}/${_date.day}')),
                  TextButton(
                      onPressed: () => selectDate(context),
                      child: const Text('Select Date'))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text('Time : ${_time.hour}:${_time.minute}')),
                  TextButton(
                      onPressed: () => selectTime(context),
                      child: const Text('Select Time'))
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 15),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text(
                      'Set Reminder',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

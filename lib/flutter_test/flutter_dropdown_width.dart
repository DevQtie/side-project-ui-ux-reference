import 'package:flutter/material.dart';

class FlutterDropDownWidth extends StatefulWidget {
  const FlutterDropDownWidth({super.key});

  @override
  State<FlutterDropDownWidth> createState() => _FlutterDropDownWidthState();
}

class _FlutterDropDownWidthState extends State<FlutterDropDownWidth> {
  final timeController = TextEditingController();
  ListTime? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DropDownMenu'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: 200,
            child: DropdownMenu<ListTime>(
              width: double.infinity,
              menuStyle: const MenuStyle(),
              leadingIcon: const Icon(
                Icons.schedule_outlined,
                size: 20,
              ),
              initialSelection: _selectedTime,
              controller: timeController,
              requestFocusOnTap: false,
              onSelected: (ListTime? time) {
                setState(() {
                  _selectedTime = time;
                  timeController.text = time?.label ?? '';
                });
              },
              dropdownMenuEntries: ListTime.values
                  .map<DropdownMenuEntry<ListTime>>((ListTime time) {
                return DropdownMenuEntry<ListTime>(
                  value: time,
                  label: time.label,
                );
              }).toList(),
            ),
          ),
          DropdownMenu<ListTime>(
            width: MediaQuery.of(context).size.width,
            menuStyle: const MenuStyle(alignment: Alignment.topLeft),
            leadingIcon: const Icon(
              Icons.schedule_outlined,
              size: 20,
            ),
            initialSelection: _selectedTime,
            controller: timeController,
            requestFocusOnTap: false,
            onSelected: (ListTime? time) {
              setState(() {
                _selectedTime = time;
                timeController.text = time?.label ?? '';
              });
            },
            dropdownMenuEntries: ListTime.values
                .map<DropdownMenuEntry<ListTime>>((ListTime time) {
              return DropdownMenuEntry<ListTime>(
                value: time,
                label: time.label,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

enum ListTime {
  first('8:00-9:45'),
  second('9:45-11:00'),
  third('11:00-12:45');

  const ListTime(this.label);
  final String label;
}

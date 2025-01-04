import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SubPage(searchController: _searchController);
  }
}

class SubPage extends StatefulWidget {
  final TextEditingController searchController;
  const SubPage({super.key, required this.searchController});

  @override
  State<SubPage> createState() => _SubPageState();
}

class _SubPageState extends State<SubPage> {
  void filterAirports(String value) {
    setState(() {
      if (kIsWeb) {
        widget.searchController.text = value;

        // Reset the selection to the end of the text to avoid highlighting
        widget.searchController.selection = TextSelection.collapsed(
            offset: widget.searchController.text.length); // for web purposes
      } else {
        widget.searchController.text =
            value; // The underline in the text goes back if I comment out this line of code snippet, otherwise it's gone.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blue underline text'),
      ),
      body: Center(
        child: Padding(
          // Experiment with these values to adjust the padding of the search field
          padding:
              const EdgeInsets.fromLTRB(2, 16, 2, 8), // Reduced side padding
          child: TextField(
            textDirection: TextDirection.ltr,
            controller: widget.searchController,
            style: const TextStyle(
              decoration: TextDecoration.none,
              color: Colors.white,
            ),
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: 'SEARCH',
              labelStyle: const TextStyle(color: Colors.white),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
              ),
              filled: false,
              fillColor: Colors.white.withOpacity(0.1),
            ),
            onChanged: (value) {
              filterAirports(value.toUpperCase());
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hyrule/controllers/api_controller.dart';
import 'package:hyrule/domain/models/entry.dart';
import 'package:hyrule/screens/components/entry_card.dart';
import 'package:hyrule/screens/details.dart';
import 'package:hyrule/screens/favorites.dart';
import 'package:hyrule/utils/consts/categories.dart';

class Results extends StatefulWidget {
const Results({ Key? key, required this.category, required this.entries }) : super(key: key);
  final String category;
  final List<Entry> entries;

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  final ApiController apiController = ApiController();

  bool cardView = true;

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(categories[widget.category]!),
          actions: [
            IconButton(onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Favorites(),
                      ));
                },
                icon: const Icon(Icons.bookmark)),
            IconButton(
                onPressed: () => setState(() {
                      cardView = !cardView;
                    }),
                icon: const Icon(Icons.swap_horiz))
          ],
        ),
        body: cardView
            ? _CardList(entries: widget.entries)
            : _ListView(entries: widget.entries),
      ),
    );
  }
}

class _CardList extends StatelessWidget {
  const _CardList({required this.entries});

  final List<Entry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) => EntryCard(entry: entries[index], isSaved: false,), itemCount: entries.length,);
  }
}

class _ListView extends StatelessWidget {
  const _ListView({required this.entries});

  final List<Entry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) => _ListTile(entry: entries[index]), itemCount: entries.length,);
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      leading: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0)),
          child: Image.network(entry.image)),
      title: Text(
        entry.name.toUpperCase(),
        style: const TextStyle(fontSize: 21.0, fontFamily: 'Philosopher'),
      ),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => Details(entry: entry))),
    );
  }
}

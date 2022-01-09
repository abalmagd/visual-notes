import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visual_notes/bloc/app_cubit.dart';
import 'package:visual_notes/bloc/app_states.dart';
import 'package:visual_notes/core/constants.dart';
import 'package:visual_notes/core/local/hive.dart';
import 'package:visual_notes/screens/add_note_screen.dart';

import '../models/note_model.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Notes'),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => Navigator.push(context, AddNoteScreen.navTo()),
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(kSmallSpacing),
            itemBuilder: (context, index) => NoteItem(
              item: cubit.getNotes(id: index),
              index: index,
            ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: HiveHelper.count(),
          ),
        );
      },
    );
  }
}

/// [item] is an [Item] data model containing
/// [Id], [Name], [Description], [Status], [Picture], [Date]
class NoteItem extends StatelessWidget {
  /// This class will implement the ui of a single note
  const NoteItem({
    Key? key,
    required this.item,
    required this.index,
  }) : super(key: key);

  final Item item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    return InkWell(
      onTap: () => Navigator.push(
          context,
          AddNoteScreen.navTo(
            index: index,
            item: item,
          )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.file(
            File(item.picture),
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: kMediumSpacing),
          Expanded(
            child: SizedBox(
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item.title),
                  Text(item.description),
                  const Spacer(),
                  Text(item.date),
                  Text('ID: ${item.id} - Status: ${item.status}'),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => cubit.deleteNote(index: index),
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

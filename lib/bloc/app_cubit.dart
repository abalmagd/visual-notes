import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visual_notes/core/local/hive.dart';

import '../models/note_model.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  final Item _item = Item();

  void addNote({
    required String title,
    required String description,
    required String picture,
    required String status,
  }) {
    var date = DateTime.now();
    var formattedDate = "${date.day}-${date.month}-${date.year}";
    HiveHelper.insert(jsonEncode(
      _item.toMap(
        id: HiveHelper.count(),
        title: title,
        description: description,
        picture: picture,
        date: formattedDate,
        status: status,
      ),
    ));
    emit(DbInsertNote());
  }

  Item getNotes({required int id}) {
    emit(DbGetNotes());
    return Item.fromJson(jsonDecode(HiveHelper.get(id)));
  }

  void deleteNote({required int index}) {
    HiveHelper.delete(index);
    emit(DbDeleteNote());
  }

  void editNote({
    required int index,
    required String title,
    required String description,
    required String picture,
    required String status,
  }) {
    var date = DateTime.now();
    var formattedDate = "${date.day}-${date.month}-${date.year}";
    HiveHelper.edit(index, jsonEncode(
      _item.toMap(
        id: HiveHelper.count(),
        title: title,
        description: description,
        picture: picture,
        date: formattedDate,
        status: status,
      ),
    ));
    emit(DbEditNote());
  }
}

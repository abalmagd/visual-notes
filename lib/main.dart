import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visual_notes/bloc/app_cubit.dart';
import 'package:visual_notes/screens/notes_screen.dart';

import 'core/local/hive.dart';

Future<void> main() async {
  await HiveHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: const MaterialApp(
        title: 'Visual Notes',
        debugShowCheckedModeBanner: false,
        home: NotesScreen()
      ),
    );
  }
}

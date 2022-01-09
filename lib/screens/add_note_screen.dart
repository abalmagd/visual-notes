import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visual_notes/bloc/app_cubit.dart';
import 'package:visual_notes/bloc/app_states.dart';
import 'package:visual_notes/core/constants.dart';
import 'package:visual_notes/models/note_model.dart';
import 'package:visual_notes/widgets/button.dart';
import 'package:visual_notes/widgets/input_form_field.dart';

/// If this class is called while passing an [Item], it will act
/// as a note editing where [index] is the index where that saved data
/// will be edited.
///
/// And [item] is the passed data that will be edited.
class AddNoteScreen extends StatefulWidget {
  static navTo({Item? item, int? index}) => MaterialPageRoute(
      builder: (context) => AddNoteScreen(
            item: item,
            index: index,
          ));

  final Item? item;
  final int? index;

  const AddNoteScreen({
    Key? key,
    this.item,
    this.index,
  }) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  String? _image;

  /// Radio group value
  String _value = 'Open';

  /// Check if [Item] is null
  /// if not null, the controller will have its value when
  /// this widget's [initState] is called.
  @override
  void initState() {
    if (widget.item != null) {
      _titleController.text = widget.item!.title;
      _descriptionController.text = widget.item!.description;
      _image = widget.item!.picture;
    }

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void changeRadioGroupValue({required var value}) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(kMediumSpacing),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          _image != null
                              ? Image.file(
                                  File(_image!),
                                  height: 250,
                                  width: 200,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey,
                                  height: 250,
                                  width: 200,
                                ),
                          Container(
                            width: 200,
                            height: 35,
                            color: Colors.black.withOpacity(0.7),
                            child: TextButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.camera_alt),
                                  SizedBox(width: 5),
                                  Text('Image'),
                                ],
                              ),
                              onPressed: () async {
                                if (await Permission.camera
                                    .request()
                                    .isGranted) {
                                  final tempImage = await _picker.pickImage(
                                    source: ImageSource.camera,
                                  );
                                  if (tempImage != null) {
                                    _image = tempImage.path;
                                  }
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      if (_image == null)
                        const Text(
                          'An image is required',
                          style: TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: kLargeSpacing),
                      InputFormField(
                        controller: _titleController,
                        type: TextInputType.name,
                        label: 'Title',
                        validate: '* Field must not be empty',
                      ),
                      const SizedBox(height: kLargeSpacing),
                      InputFormField(
                        controller: _descriptionController,
                        type: TextInputType.multiline,
                        label: 'Description',
                        validate: '* Field must not be empty',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Radio(
                            value: 'Closed',
                            groupValue: _value,
                            onChanged: (value) =>
                                changeRadioGroupValue(value: value),
                          ),
                          const Text('Closed'),
                          Radio(
                            value: 'Open',
                            groupValue: _value,
                            onChanged: (value) =>
                                changeRadioGroupValue(value: value),
                          ),
                          const Text('Open'),
                        ],
                      ),
                      Button(
                        onPressed: () {
                          /// Validates the form fields and image
                          /// Then checks if user is editing or adding
                          /// new notes before saving.
                          if (_formKey.currentState!.validate() &&
                              _image != null) {
                            if (widget.item == null) {
                              cubit.addNote(
                                title: _titleController.text.trim(),
                                description: _descriptionController.text.trim(),
                                picture: _image!,
                                status: _value,
                              );
                            } else {
                              cubit.editNote(
                                index: widget.index!,
                                title: _titleController.text.trim(),
                                description: _descriptionController.text.trim(),
                                picture: _image!,
                                status: _value,
                              );
                            }
                            Navigator.pop(context);
                          }
                        },
                        text: 'save',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

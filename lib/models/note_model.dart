import 'package:image_picker/image_picker.dart';

/// [picture] is the [String] path to the image
class Item {

  Item();

  late final int id;
  late final String title;
  late final String description;
  late final String status;
  late final String picture;
  late final String date;

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    picture = json['picture'];
    date = json['date'];
  }

  Map<String, dynamic> toMap({
    required int id,
    required String title,
    required String description,
    required String picture,
    required String date,
    required String status,
  }) {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'status': status,
      'picture': picture,
    };
  }
}

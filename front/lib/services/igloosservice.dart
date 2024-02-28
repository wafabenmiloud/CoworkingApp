import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

import '../constants.dart';

class IgloosService {
  Dio dio = new Dio();

  likeDislike(id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      await dio.post('$server/igloos/like/$id');
      print('Igloo liked/disliked successfully');
    } catch (error) {
      print('Error liking/disliking igloo: $error');
    }
  }

  addIgloo(
      type,
      place,
      cnx,
      days,
      transport,
      startDate,
      endDate,
      startTime,
      endTime,
      description,
      equipements,
      animals,
      animalsbool,
      environnementbool,
      fauteilbool,
      ascenseurbool,
      cuisinebool,
      name,
      ville,
      location,
      price,
      nb_places,
      images,
      files,
      lat,
      long) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    print(days);
    try {
      final formData = FormData.fromMap({
        "igloo_name": name,
        "igloo_type": type,
        "coworking_place": place,
        "internet": cnx,
        "days": days,
        "transport": transport,
        "equipements": equipements,
        "description": description,
        "startDate": startDate.text,
        "endDate": endDate.text,
        "startTime": startTime.text,
        "endTime": endTime.text,
        "animals": animals,
        "accept_animals": animalsbool,
        "habitude": environnementbool,
        "fauteil": fauteilbool,
        "ascenseur": ascenseurbool,
        "cuisine": cuisinebool,
        "ville": ville,
        "location": location,
        "price": price,
        "nb_places": nb_places,
        "lat": lat,
        "long": long
      });

      if (images != null && images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          final file = File(images[i].path);
          final fileName = path.basename(file.path);
          formData.files.add(MapEntry(
            "images",
            await MultipartFile.fromFile(file.path, filename: fileName),
          ));
        }
      }
      if (files != null && files.isNotEmpty) {
        for (int i = 0; i < files.length; i++) {
          final file = File(files[i].path);
          final fileName = path.basename(file.path);
          formData.files.add(MapEntry(
            "files",
            await MultipartFile.fromFile(file.path, filename: fileName),
          ));
        }
      }

      final response = await dio.post(
        '$server/addigloo',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return response.data;
    } catch (error, stackTrace) {
      print('Error: $error');
      print('Stack trace: $stackTrace');
      throw error;
    }
  }
}

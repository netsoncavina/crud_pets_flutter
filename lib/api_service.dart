import 'dart:convert';
import 'package:crud_pets_flutter/config.dart';
import 'package:crud_pets_flutter/models/pet_model.dart';
import 'package:http/http.dart' as http;

class APIService {
  static var client = http.Client();

  static Future<List<PetModel>?> getPets() async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.petURL);

    var response = await http.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return petsFromJson(data["data"]);
    } else {
      print(response.statusCode);
      return null;
    }
  }

  static Future<bool> savePet(
      PetModel model, bool isEditMode, bool isFileSelected) async {
    var petURL = Config.petURL;

    if (isEditMode) {
      petURL = petURL + "/" + model.id.toString();
    }

    var url = Uri.http(Config.apiURL, petURL);

    var requestMethod = isEditMode ? "PUT" : "POST";

    var request = http.MultipartRequest(requestMethod, url);
    request.fields['petName'] = model.petName;
    request.fields['petAge'] = model.petAge.toString();
    request.fields['petType'] = model.petType;
    request.fields['petBreed'] = model.petBreed;

    if (model.petImage != null && isFileSelected) {
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('petImage', model.petImage!);

      request.files.add(multipartFile);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deletePet(petId) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.petURL + "/" + petId);

    var response = await client.delete(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

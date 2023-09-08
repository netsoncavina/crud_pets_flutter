List<PetModel> petsFromJson(dynamic str) =>
    List<PetModel>.from((str).map((x) => PetModel.fromJson(x)));

class PetModel {
  late String? id;
  late String petName;
  late int petAge;
  late String petType;
  late String petBreed;
  late String petImage;

  PetModel({
    this.id,
    required this.petName,
    required this.petAge,
    required this.petType,
    required this.petBreed,
    required this.petImage,
  });

  PetModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    petName = json['petName'];
    petAge = json['petAge'];
    petType = json['petType'];
    petBreed = json['petBreed'];
    petImage = json['petImage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};

    _data['_id'] = id;
    _data['petName'] = petName;
    _data['petAge'] = petAge;
    _data['petType'] = petType;
    _data['petBreed'] = petBreed;
    _data['petImage'] = petImage;

    return _data;
  }
}

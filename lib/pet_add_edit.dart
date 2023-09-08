import 'dart:convert';
import 'dart:io';

import 'package:crud_pets_flutter/api_service.dart';
import 'package:crud_pets_flutter/config.dart';
import 'package:crud_pets_flutter/models/pet_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class PetAddEdit extends StatefulWidget {
  const PetAddEdit({super.key});

  @override
  State<PetAddEdit> createState() => _PetAddEditState();
}

class _PetAddEditState extends State<PetAddEdit> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool isAPICallProcess = false;
  PetModel? petModel;
  bool isEditMode = false;
  bool isImageSelected = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Cadastro de Pet"),
          elevation: 0,
        ),
        backgroundColor: Colors.grey[200],
        body: ProgressHUD(
            child: Form(
              key: globalKey,
              child: petForm(),
            ),
            inAsyncCall: isAPICallProcess,
            opacity: 0.3,
            key: UniqueKey()),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    petModel = PetModel(
        id: "",
        petName: "",
        petAge: 0,
        petType: "",
        petBreed: "",
        petImage: "");

    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;

        petModel = arguments["model"];
        isEditMode = true;
        setState(() {});
      }
    });
  }

  Widget petForm() {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: FormHelper.inputFieldWidget(
                context, "PetName", "Nome do Pet", (onValidateVal) {
              if (onValidateVal!.isEmpty) {
                return "Nome do Pet é obrigatório";
              }
              return null;
            }, (onSavedVal) {
              petModel!.petName = onSavedVal!;
            },
                initialValue: petModel!.petName ?? "",
                borderColor: Colors.black,
                borderFocusColor: Colors.black,
                textColor: Colors.black,
                hintColor: Colors.black.withOpacity(0.7),
                borderRadius: 10,
                showPrefixIcon: false)),
        Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FormHelper.inputFieldWidget(
                context, "PetAge", "Idade do Pet", (onValidateVal) {
              if (onValidateVal!.isEmpty) {
                return "Idade do Pet é obrigatório";
              }
              return null;
            }, (onSavedVal) {
              petModel!.petAge = int.parse(onSavedVal!);
            },
                initialValue:
                    petModel!.petAge == 0 ? "" : petModel!.petAge.toString(),
                borderColor: Colors.black,
                borderFocusColor: Colors.black,
                textColor: Colors.black,
                hintColor: Colors.black.withOpacity(0.7),
                borderRadius: 10,
                showPrefixIcon: false)),
        Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FormHelper.inputFieldWidget(
                context, "PetType", "Espécie do Pet", (onValidateVal) {
              if (onValidateVal!.isEmpty) {
                return "Espécie do Pet é obrigatório";
              }
              return null;
            }, (onSavedVal) {
              petModel!.petType = onSavedVal!;
            },
                initialValue: petModel!.petType ?? "",
                borderColor: Colors.black,
                borderFocusColor: Colors.black,
                textColor: Colors.black,
                hintColor: Colors.black.withOpacity(0.7),
                borderRadius: 10,
                showPrefixIcon: false)),
        Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FormHelper.inputFieldWidget(
                context, "PetBreed", "Raça do Pet", (onValidateVal) {
              if (onValidateVal!.isEmpty) {
                return "Raça do Pet é obrigatório";
              }
              return null;
            }, (onSavedVal) {
              petModel!.petBreed = onSavedVal!;
            },
                initialValue: petModel!.petBreed ?? "",
                borderColor: Colors.black,
                borderFocusColor: Colors.black,
                textColor: Colors.black,
                hintColor: Colors.black.withOpacity(0.7),
                borderRadius: 10,
                showPrefixIcon: false)),
        picPicker(isImageSelected, petModel!.petImage ?? "", (file) {
          setState(() {
            petModel!.petImage = file.path;
            isImageSelected = true;
          });
        }),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: FormHelper.submitButton("Salvar", () {
            if (validateAndSave()) {
              print(petModel!.toJson());
              setState(() {
                isAPICallProcess = true;
              });
              APIService.savePet(petModel!, isEditMode, isImageSelected)
                  .then((response) {
                setState(() {
                  isAPICallProcess = false;
                });
                print(response);
                if (response) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/", (route) => false);
                } else {
                  FormHelper.showSimpleAlertDialog(context, Config.appName,
                      "Houve um erro ao cadastrar", "Ok", () {
                    Navigator.of(context).pop();
                  });
                }
              });
            }
          }, btnColor: HexColor("#38b6ff"), borderRadius: 10)),
        )
      ],
    ));
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  Widget picPicker(
    bool isFileSelected,
    String fileName,
    Function onFilePicked,
  ) {
    Future<XFile?> _imageFile;
    ImagePicker _picker = ImagePicker();

    return Column(
      children: [
        fileName.isNotEmpty
            ? isFileSelected
                ? Image.file(
                    File(fileName),
                    height: 200,
                    width: 200,
                  )
                : SizedBox(
                    child: Image.network(fileName,
                        width: 200, height: 200, fit: BoxFit.scaleDown))
            : SizedBox(
                child: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png",
                    width: 200,
                    height: 200,
                    fit: BoxFit.scaleDown)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 35.0,
                width: 35,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.image,
                    size: 35,
                  ),
                  onPressed: () {
                    _imageFile = _picker.pickImage(source: ImageSource.gallery);
                    _imageFile.then((file) async {
                      onFilePicked(file);

                      // image to base64
                      List<int> imageBytes = await file!.readAsBytes();
                      String base64Image = base64Encode(imageBytes);
                      petModel!.petImage = base64Image;
                    });
                  },
                )),
            SizedBox(
                height: 35.0,
                width: 35,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 35,
                  ),
                  onPressed: () {
                    _imageFile = _picker.pickImage(source: ImageSource.camera);
                    _imageFile.then((file) async {
                      onFilePicked(file);
                    });
                  },
                ))
          ],
        )
      ],
    );
  }
}

import 'package:crud_pets_flutter/api_service.dart';
import 'package:crud_pets_flutter/config.dart';
import 'package:crud_pets_flutter/models/pet_model.dart';
import 'package:crud_pets_flutter/pet_item.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class PetList extends StatefulWidget {
  const PetList({super.key});

  @override
  State<PetList> createState() => _PetListState();
}

class _PetListState extends State<PetList> {
  // List<PetModel> pets = List<PetModel>.empty(growable: true);
  bool isAPICallProcess = false;
  @override
  void initState() {
    super.initState();

    // pets.add(
    //   PetModel(
    //       id: "1",
    //       petName: "Romarin",
    //       petAge: 5,
    //       petType: "Cachorro",
    //       petBreed: "Vira Lata",
    //       petImage:
    //           "https://i0.statig.com.br/bancodeimagens/9k/fj/a0/9kfja0nfvlpr5243tpog661z6.jpg"),
    // );
    // pets.add(
    //   PetModel(
    //       id: "2",
    //       petName: "Robertin",
    //       petAge: 5,
    //       petType: "Cachorro",
    //       petBreed: "Vira Lata",
    //       petImage:
    //           "https://www.petz.com.br/cachorro/racas/vira-lata/img/vira-lata-caracteristicas-guia-racas.jpg"),
    // );
    // pets.add(
    //   PetModel(
    //       id: "3",
    //       petName: "Junin",
    //       petAge: 5,
    //       petType: "Cachorro",
    //       petBreed: "Vira Lata",
    //       petImage:
    //           "https://i0.wp.com/www.portaldodog.com.br/cachorros/wp-content/uploads/2022/03/caracteristicas-do-vira-lata-2.jpg?resize=563%2C422&ssl=1"),
    // );
  }

  Widget petList(pets) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.green,
                  minimumSize: const Size(88, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              onPressed: () {
                Navigator.pushNamed(context, "/add");
              },
              child: const Text("Adicionar Pet"),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: pets.length,
              itemBuilder: (context, index) {
                return PetItem(
                    model: pets[index],
                    onDelete: (PetModel model) {
                      setState(() {
                        isAPICallProcess = true;
                      });

                      APIService.deletePet(model.id).then((response) {
                        setState(() {
                          isAPICallProcess = false;
                        });
                      });
                    });
              },
            )
          ],
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Lista de Pets"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 30),
          elevation: 0,
          backgroundColor: const Color(0xFF38b6ff),
          centerTitle: true,
        ),
        // #38b6ff
        backgroundColor: Colors.grey[200],
        // body: loadPets(),
        body: ProgressHUD(
          child: loadPets(),
          inAsyncCall: isAPICallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ));
  }

  Widget loadPets() {
    return FutureBuilder(
        future: APIService.getPets(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<PetModel>?> model,
        ) {
          if (model.hasData) {
            debugPrint("model.data: ${model.data}");
            return petList(model.data);
          }
          debugPrint("model.data: ${model}");
          return const Center(
            child: CircularProgressIndicator(),
            // child: Text("AAAAAAAAAa"),
          );
        });
  }
}

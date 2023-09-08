import 'package:crud_pets_flutter/models/pet_model.dart';
import 'package:flutter/material.dart';

class PetItem extends StatelessWidget {
  const PetItem({Key? key, this.model, this.onDelete}) : super(key: key);

  final PetModel? model;
  final Function? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: petWidget(context),
      ),
    );
  }

  Widget petWidget(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 120,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          child: Image.network(
            (model!.petImage == null || model!.petImage == "")
                ? "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png"
                : model!.petImage!,
            height: 120,
            fit: BoxFit.scaleDown,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model!.petName,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("Idade: ${model!.petAge}"),
                const SizedBox(
                  height: 10,
                ),
                Text("${model!.petType}"),
                const SizedBox(
                  height: 10,
                ),
                Text("Raça : ${model!.petBreed}"),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 180,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.edit),
                          onTap: () {
                            Navigator.of(context).pushNamed('/edit',
                                arguments: {'model': model});
                          },
                        ),
                        GestureDetector(
                          child: const Icon(Icons.delete, color: Colors.red),
                          onTap: () {
                            onDelete!(model);
                          },
                        ),
                      ],
                    ))
              ],
            ))
      ],
    );
  }
}

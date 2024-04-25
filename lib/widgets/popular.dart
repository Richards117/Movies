import 'package:flutter/material.dart';

//contenedor de Populares
class PopularContainer extends StatelessWidget {
  const PopularContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 92),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: 300,
          height: 45,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 3),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                color: Colors.deepPurple,
              )
            ],
            color: Colors.blueAccent,
          ),
          child: const Center(
            child: Text(
              textAlign: TextAlign.left,
              'Top Populares',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  fontStyle: FontStyle.italic,
                  shadows: [
                    Shadow(
                        color: Colors.deepPurple,
                        blurRadius: 5,
                        offset: Offset(0, 4))
                  ]),
            ),
          )),
    );
  }
}

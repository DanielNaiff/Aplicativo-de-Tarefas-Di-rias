import 'package:aplicativo_de_tarefas_diarias/screens/creating_todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Todos_screen extends StatefulWidget {
  const Todos_screen({super.key});

  @override
  State<Todos_screen> createState() => _Todos_screenState();
}

class _Todos_screenState extends State<Todos_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange, // Cor do AppBar
        title: const Center(
          child: Text(
            'Aplicativo de Tarefas Diárias',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[850], // Fundo cinza escuro
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Lista de tarefas',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white), // Texto em branco
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () {}),
                          children: [
                            SlidableAction(
                              onPressed: null,
                              backgroundColor: Colors.white,
                              foregroundColor:
                                  Colors.deepOrange, // Cor do ícone
                              icon: Icons.delete,
                              label: 'Deletar',
                            )
                          ],
                        ),
                        endActionPane:
                            ActionPane(motion: const ScrollMotion(), children: [
                          SlidableAction(
                            onPressed: (context) {},
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepOrange, // Cor do ícone
                            icon: Icons.edit,
                            label: 'Editar',
                          )
                        ]),
                        child: Card(
                          elevation: 10,
                          color: Colors.grey[800], // Fundo do card
                          margin: EdgeInsets.all(5),
                          child: Container(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Título : ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Colors.white), // Texto em branco
                                    ),
                                    Text(
                                      'Teste',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              Colors.white), // Texto em branco
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Prazo final : ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Colors.white), // Texto em branco
                                    ),
                                    Text(
                                      'Teste',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              Colors.white), // Texto em branco
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Creating_todo_screen()),
          ).then((_) {});
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

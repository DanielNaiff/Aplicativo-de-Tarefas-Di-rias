import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'creating_todo_screen.dart';

class Todos_screen extends StatefulWidget {
  final Function onToggleTheme;
  final bool isDarkTheme;

  const Todos_screen({
    Key? key,
    required this.onToggleTheme,
    required this.isDarkTheme,
  }) : super(key: key);

  @override
  State<Todos_screen> createState() => _Todos_screenState();
}

class _Todos_screenState extends State<Todos_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Center(
          child: Text(
            'Aplicativo de Tarefas Diárias',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => widget.onToggleTheme(), // Alterna o tema
          ),
        ],
      ),
      body: Container(
        color: widget.isDarkTheme ? Colors.grey[850] : Colors.white,
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
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Slidable(
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {},
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepOrange,
                          icon: Icons.delete,
                          label: 'Deletar',
                        )
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            title.text = task[index].title;
                            date.text = task[index].date;
                            description.text = task[index].description;
                            setState(() {
                              editpressed = true;
                              this_id = task[index].id;
                            });
                          },
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepOrange,
                          icon: Icons.edit,
                          label: 'Editar',
                        )
                      ],
                    ),
                    child: Card(
                      elevation: 10,
                      color:
                          widget.isDarkTheme ? Colors.grey[800] : Colors.white,
                      margin: const EdgeInsets.all(5),
                      child: Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Título: Teste',
                              style: TextStyle(
                                fontSize: 20,
                                color: widget.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              'Prazo final: Teste',
                              style: TextStyle(
                                fontSize: 20,
                                color: widget.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Creating_todo_screen(
                onToggleTheme: widget.onToggleTheme,
                isDarkTheme: widget.isDarkTheme,
              ),
            ),
          );
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

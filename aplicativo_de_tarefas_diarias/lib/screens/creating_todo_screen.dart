import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Creating_todo_screen extends StatefulWidget {
  final Function onToggleTheme;
  final bool isDarkTheme;

  const Creating_todo_screen({
    Key? key,
    required this.onToggleTheme,
    required this.isDarkTheme,
  }) : super(key: key);

  @override
  State<Creating_todo_screen> createState() => _Creating_todo_screenState();
}

class _Creating_todo_screenState extends State<Creating_todo_screen> {
  final TextEditingController descricao = TextEditingController();
  final TextEditingController titulo = TextEditingController();
  final TextEditingController data = TextEditingController();

  @override
  void dispose() {
    titulo.dispose();
    data.dispose();
    descricao.dispose();
    super.dispose();
  }

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
            onPressed: () => widget.onToggleTheme(),
          ),
        ],
      ),
      body: Container(
        color: widget.isDarkTheme ? Colors.grey[850] : Colors.white,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25, top: 25),
              child: Text(
                "Adicione uma tarefa",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: titulo,
              decoration: InputDecoration(
                hintText: 'Digite o título',
                labelText: 'Título',
                labelStyle: TextStyle(
                    color: widget.isDarkTheme ? Colors.white : Colors.black),
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.title, color: Colors.deepOrange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.deepOrange),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: data,
              decoration: InputDecoration(
                constraints: BoxConstraints(maxHeight: 50),
                hintText: 'Escolha uma data',
                labelText: 'Data',
                labelStyle: TextStyle(
                    color: widget.isDarkTheme ? Colors.white : Colors.black),
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon:
                    const Icon(Icons.calendar_month, color: Colors.deepOrange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.deepOrange),
                ),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    data.text = formattedDate;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data não selecionada!')));
                }
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: descricao,
              maxLines: 3,
              decoration: InputDecoration(
                constraints: const BoxConstraints(maxHeight: 150),
                hintText: 'Digite uma descrição',
                labelText: 'Descrição',
                labelStyle: TextStyle(
                    color: widget.isDarkTheme ? Colors.white : Colors.black),
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon:
                    const Icon(Icons.description, color: Colors.deepOrange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.deepOrange),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton.icon(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.deepOrange),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton.icon(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.deepOrange),
                    ),
                    onPressed: () {
                      titulo.clear();
                      data.clear();
                      descricao.clear();
                    },
                    icon: const Icon(Icons.clear, color: Colors.white),
                    label: const Text(
                      'Limpar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

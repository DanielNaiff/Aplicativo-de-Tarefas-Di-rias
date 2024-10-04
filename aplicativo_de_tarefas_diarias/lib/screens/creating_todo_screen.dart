import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class Creating_todo_screen extends StatefulWidget {
  const Creating_todo_screen({super.key});

  @override
  State<Creating_todo_screen> createState() => _Creating_todo_screenState();
}

class _Creating_todo_screenState extends State<Creating_todo_screen> {
  TextEditingController descricao = TextEditingController();
  TextEditingController titulo = TextEditingController();
  TextEditingController data = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Aplicativo de Tarefas Diárias',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25, top: 25),
              child: Text(
                "Adicione uma tarefa",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: titulo,
              decoration: InputDecoration(
                  hintText: 'Digite o título',
                  labelText: 'Título',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: data,
              decoration: InputDecoration(
                  constraints: BoxConstraints(maxHeight: 50),
                  hintText: 'Escolha uma data',
                  labelText: 'Data',
                  prefixIcon: const Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1));
                if (pickedDate != null) {
                  String formatedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    data.text = formatedDate;
                  });
                } else {
                  if (mounted) {}
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data não selecionada!')));
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: descricao,
              maxLines: 3,
              decoration: InputDecoration(
                constraints: const BoxConstraints(maxHeight: 150),
                hintText: 'Digite uma descrição',
                labelText: 'Descrição',
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton.icon(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                    onPressed: () {},
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton.icon(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                    onPressed: () {
                      titulo.clear();
                      data.clear();
                      descricao.clear();
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
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

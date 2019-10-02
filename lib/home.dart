import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

List<String> tarefas = [];

void _listaTarefas() {

  tarefas.clear();

  for (int i=0;i<10;i++) {
    tarefas.add('Tarefa ' + i.toString());
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

    _listaTarefas();
    bool _valor = false;

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.purple,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          print("Clicou pra adicionar");

          // 

        },
      ),

      body: Container(
        child: ListView.builder(
          itemCount: tarefas.length,
          itemBuilder: (context, index) {

            return ListTile(
              title: Text( tarefas[index] ),
              trailing: Checkbox(
                value: _valor,
                onChanged: (bool value) {
                  print("Checkbox ID " + index.toString() + ". VALUE: " + value.toString());
                  setState(() {
                    // _valor = value;
                    _valor = value;
                  });
                },
              ),
              // onTap: () {
              //   print("Item " + index.toString() + " concluído");
              // },
            );

          },
        ),
      ),

    );
  }
}
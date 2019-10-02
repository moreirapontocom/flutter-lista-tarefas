import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> tarefas = [];

  bool _valor = false;
  TextEditingController _novoItemController = TextEditingController();

  void _listaTarefas() {

    if (tarefas.length==0) {
      for (int i=0;i<5;i++) {
        tarefas.add('Tarefa ' + i.toString());
      }
    }
  }

  void _pusha() {
    print("Push: " + _novoItemController.text);

    setState(() {
      tarefas.add( _novoItemController.text );
    });

    print("Length: " + tarefas.length.toString());
  }

  @override
  Widget build(BuildContext context) {

    _listaTarefas();

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

          showDialog(
            context: context,
            builder: (context) {

              return AlertDialog(
                title: Text("Adicionar"),
                content: TextField(
                  controller: _novoItemController,
                  decoration: InputDecoration(
                    labelText: "Descrição da tarefa"
                  ),
                ),
                actions: <Widget>[
                  RaisedButton(
                    color: Colors.purple,
                    child: Text("Adicionar", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _pusha();
                      Navigator.pop(context);
                    },
                  )
                ],
              );

            }
          );

        },
      ),

      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[

            Expanded(
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
                          _valor = value;
                        });
                      },
                    ),
                  );

                },
              ),
            )

          ],
        ),
      ),

    );
  }
}

/*
ListView.builder(
  itemCount: tarefas.length,
  itemBuilder: (context, index) {

    return ListTile(
      title: Text( tarefas[index] ),
      trailing: Checkbox(
        value: _valor,
        onChanged: (bool value) {
          print("Checkbox ID " + index.toString() + ". VALUE: " + value.toString());
          setState(() {
            _valor = value;
          });
        },
      ),
    );

  },
)
*/
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List tarefas = [];

  TextEditingController _novoItemController = TextEditingController();

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File( diretorio.path + "/dados.json" );
  }

  _salvarArquivo() async {

    var arquivo = await _getFile();

    String dados = json.encode(tarefas);
    arquivo.writeAsString(dados);
  }

  _lerArquivo() async {

    try {
      
      var arquivo = await _getFile();
      return arquivo.readAsString();

    } catch (e) {
      return null;
    }

  }

  _salvarTarefa() {

    Map<String, dynamic> tarefa = Map();

    tarefa['titulo'] = _novoItemController.text;
    tarefa['concluido'] = false;

    setState(() {
      tarefas.add(tarefa);
    });

    _novoItemController.text = "";
    _salvarArquivo();

  }

  @override
  void initState() {
    super.initState();

    _lerArquivo().then((dados) {
      setState(() {
        tarefas = json.decode(dados);
      });
    });

    // Não dá pra usar da forma abaixo pois o await só pode ser utilizado dentro de uma função async que retorne algum Future<>
    // Aqui é o initState, não pode esperar
    // var itens = await _lerArquivo();
  }

  @override
  Widget build(BuildContext context) {

    // _salvarArquivo();
    print(tarefas.toString());

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
                      _salvarTarefa();
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

                  return Dismissible(
                    // Não pode usar esta linha pois ao desfazer a exclusão, o item volta com a mesma key (tarefas[index].toString())
                    // Os keys nunca podem se repetir, mesmo que tenha sido removido
                    // key: Key(tarefas[index].toString()),
                    key: Key( DateTime.now().millisecondsSinceEpoch.toString() ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direcao) {
                      print("Direção: " + direcao.toString());

                      final itemRemovido = tarefas[index];
                      final indexRemovido = index;

                      tarefas.removeAt(index);
                      _salvarArquivo();

                      // Snackbar
                      final snackBar = SnackBar(
                        duration: Duration(seconds: 5),
                        content: Text("Item removido"),
                        action: SnackBarAction(
                          label: "Desfazer",
                          textColor: Colors.yellow,
                          onPressed: () {

                            setState(() {
                              tarefas.insert(indexRemovido, itemRemovido);
                            });
                            _salvarArquivo();

                          },
                        ),
                      );

                      Scaffold.of(context).showSnackBar(snackBar);
                      // fim Snackbar
                    },
                    /*
                    background: Container(
                      color: Colors.green,
                      child: Icon(Icons.check, color: Colors.white,)
                    ),
                    */
                    // secondaryBackground: Container(
                    background: Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(Icons.clear, color: Colors.white,)
                        ],
                      ),
                    ),
                    child: CheckboxListTile(
                      checkColor: Colors.white,
                      activeColor: Colors.purple,
                      value: tarefas[index]['concluido'],
                      title: Text( tarefas[index]['titulo'] ),
                      onChanged: (valorAlterado) {
                        setState(() {
                          tarefas[index]['concluido'] = valorAlterado;
                        });

                        _salvarArquivo();
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
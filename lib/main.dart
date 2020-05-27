
import 'package:fluter_vscode/db/database.dart';
import 'package:flutter/material.dart';
import 'add_editclient.dart';
import 'model/client_model.dart';
import 'db/database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Registro de usuarios",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
  class MyHomePage extends StatefulWidget{
    @override
    _MyHomePageState createState() => _MyHomePageState();  
  }

  class _MyHomePageState extends State<MyHomePage> {

    @override
    void didUpdateWidget(MyHomePage oldWidget){
      super.didUpdateWidget(oldWidget);
      setState(() {

      });
    }


    
   @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Personal sqlite") ,
          actions: <Widget>[
          RaisedButton(
            color: Theme.of(context).primaryColor,
          onPressed: (){
            ClientDatabaseProvider.db.deleteAllClient();
            setState(() {
              
            });
          },
          child: Text('Delete All',
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
            color: Colors.black
          )
          ),
          )
        ],),

        body:
        FutureBuilder<List<Client>>(
          future: ClientDatabaseProvider.db.getAllClients(),
          builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  Client item = snapshot.data[index];
                  return Dismissible(

                    key: UniqueKey(),
                    background: Container(color: Colors.red),
                    onDismissed: (diretion){
                      ClientDatabaseProvider.db.deleteClientWithId(item.id);
                    },
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.phone),
                      leading: CircleAvatar(child: Text(item.id.toString())),
                      onTap: () {//este es el setOnClickListener de flutter
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddEditClient(
                          true, 
                          client: item,
                        )
                        )
                        );
                      },
                    ),);
                },
              );
            }else{
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditClient(false)));

            
          },
      ),
    );
  }
}

    
  

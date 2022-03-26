import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatelessWidget{
  const HomePage({Key? key}) : super(key: key) ;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Movies").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading...');
          return ListView.separated(
            separatorBuilder: (context, snapshot) => Divider(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {

                return ListTile(
                  leading: Image.network(snapshot.data!.docs[index]['cartaz']),
                  title: Text(snapshot.data!.docs[index]['nome'], style: new TextStyle(color: Colors.white),),
                  subtitle: Text(snapshot.data!.docs[index]['genero'], style: new TextStyle(color: Colors.white)),
                  tileColor: Colors.blueGrey,

                );
            },
            padding: EdgeInsets.all(16),


          );
        },
      )
    );
  }
}
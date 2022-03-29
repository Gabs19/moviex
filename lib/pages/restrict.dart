import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Restrict extends StatefulWidget {

  @override
  _RestrictState createState() => _RestrictState();
}

class _RestrictState extends State<Restrict>{
  bool isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

  @override
  Widget build(BuildContext context) => isEmailVerified == false ?
      Scaffold(
        appBar: AppBar(
          title: Text('Criticas'),
        ),
        body: Text("Por favor validar email"),
      )
      :
  Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      body : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Reviews").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading...');
          return ListView.separated(
            separatorBuilder: (context, snapshot) => Divider(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {

              return ListTile(
                onTap: () {
                  DocumentSnapshot snap = snapshot.data!.docs[index];
                  showDialogFunc(context,snap);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                leading: ClipRRect(
                  child: Image.network(snapshot.data!.docs[index]['cartaz']),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                title: Text(snapshot.data!.docs[index]['nome'],style: new TextStyle(color: Colors.white,),),
                subtitle: Text("Nota: " + snapshot.data!.docs[index]['nota'] + "/10", style: new TextStyle(color: Colors.white)),
                tileColor: Colors.blueGrey,
                selected: false,
                selectedTileColor: Colors.black45,
                trailing: double.parse(snapshot.data!.docs[index]['nota']) > 7 ? Icon(Icons.verified, color: Colors.green,) : Icon(Icons.warning, color:Colors.red),
              );
            },
            padding: EdgeInsets.all(16),
          );
        },
      )
  );

  showDialogFunc(context, snap){
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2),
              width: MediaQuery.of(context).size.width * 0.7,
              height: 550,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    child: Image.network(snap['cartaz'], width: 500, height: 300,),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    snap['nome'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    snap['critica'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  }



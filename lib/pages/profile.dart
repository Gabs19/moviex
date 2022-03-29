import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviex/databases/db_firestore.dart';
import 'package:moviex/pages/documentsPage.dart';
import 'package:moviex/services/auth_service.dart';



class Profile extends StatelessWidget{

  late FirebaseFirestore db;
  late AuthService auth;

  final formKey = GlobalKey<FormState>();

  late var nome = TextEditingController();

  Profile({Key? key, required this.auth}) : super(key: key){
    _startPerfil();
  }

  _startPerfil() async{
    await _startFirestore();
    await _readData();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  _readData() async {
    if( auth.usuario != null) {
      final snapshot = await db.collection('user').doc(auth.usuario!.uid).get();
    }
  }

  update() async{
    await db.collection('user').doc(auth.usuario!.uid).set({
      'nome' : nome.text,
      'url' : 'img-2022-03-27 11:50:27.880384.jpg'
    },
      SetOptions(merge: true),
    );
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body:
      SingleChildScrollView(
        child:  Padding(
          padding: EdgeInsets.only(top: 100),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Atualize seus Dados',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DocumentsPage(), fullscreenDialog: true)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                              "Tire uma nova Selfie",
                              style: TextStyle(fontSize: 16)
                          ),
                        ),
                        Icon(Icons.camera_alt),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: TextFormField(
                    controller: nome,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Atualize seu nome",
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe seu nome corretamente!';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 3),
                  child: ElevatedButton(
                    onPressed: () {
                      if(formKey.currentState!.validate()){
                        update();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.update),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                              "Atualizar",
                              style: TextStyle(fontSize: 16)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
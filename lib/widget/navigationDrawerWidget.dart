
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviex/databases/db_firestore.dart';
import 'package:moviex/pages/profile.dart';
import 'package:moviex/pages/restrict.dart';
import 'package:moviex/pages/validate_email.dart';
import 'package:moviex/services/auth_service.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class NavigationDrawerWidget extends StatefulWidget {

  @override
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget>{

  final padding = EdgeInsets.symmetric(horizontal: 20);

  late FirebaseFirestore db;
  late FirebaseStorage fs;
  late  String name = '';
  late String urlImage = 'https://i1.wp.com/terracoeconomico.com.br/wp-content/uploads/2019/01/default-user-image.png?ssl=1';


  @override
  void initState() {
    super.initState();
    _startNavigationDrawer();
  }

  _startNavigationDrawer() async{
    await _startFirestore();
    await _readData();
  }

  _startFirestore() {
    db = DBFirestore.get();
    fs = FirebaseStorage.instance;
  }

  _readData() async {

      final snapshot = await db.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).get();
      String ref = await fs.ref('images').child('img-2022-03-27 11:50:27.880384.jpg').getDownloadURL();

      setState(() {
        name = snapshot.get('nome');
        urlImage = ref;
      });
  }

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Material(
        color: Color.fromRGBO(45, 123, 38, 100),
        child: ListView(
          children: <Widget>[
            buildHeader(urlImage: urlImage, name: name),
            Container(
              padding: padding,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  buildMenuItem(text: 'perfil', icon: Icons.people,onClicked: () => selectedItem(context, 0)),
                  const SizedBox(height: 16),
                  buildMenuItem(text: 'Restrito', icon: Icons.notes,onClicked: () => selectedItem(context, 1)),
                  const SizedBox(height: 24),
                  Divider(color: Colors.white70),
                  buildMenuItem(text: 'validar email', icon: Icons.email_outlined,onClicked: () => selectedItem(context, 2)),
                  const SizedBox(height: 16,),
                  buildMenuItem(text: 'sair', icon: Icons.backspace_outlined, onClicked: () => selectedItem(context, 3))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }){
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color),),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
  }) => InkWell(
    child: Container(
      color: Color.fromRGBO(102, 181, 95, 100),
      padding: padding.add(EdgeInsets.symmetric(vertical: 20)),
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage),),
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          )
        ],
      ),
    )
  );

  void selectedItem(BuildContext context, int index) {

    Navigator.of(context).pop();

    switch(index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile(auth: context.read<AuthService>(),)));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Restrict()));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ValidateEmail()));
        break;
      case 3:
        context.read<AuthService>().logout();
        break;
    }
  }
}


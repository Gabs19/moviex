
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviex/databases/db_firestore.dart';
import 'package:moviex/pages/profile.dart';
import 'package:moviex/pages/restrict.dart';
import 'package:moviex/pages/validate_email.dart';
import 'package:moviex/services/auth_service.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class NavigationDrawerWidget extends StatelessWidget {

  final padding = EdgeInsets.symmetric(horizontal: 20);

  late FirebaseFirestore db;
  late AuthService auth;

  late  String name = '';
  late String email = '';
  late String urlImage = 'https://i1.wp.com/terracoeconomico.com.br/wp-content/uploads/2019/01/default-user-image.png?ssl=1';


  NavigationDrawerWidget({required this.auth}){
    _startNavigationDrawer();
  }

  _startNavigationDrawer() async{
    await _startFirestore();
    await _readData();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  _readData() async {
    if( auth.usuario != null) {
      final snapshot = await db.collection('user').doc(auth.usuario!.uid).get();
      name = snapshot.get('nome');
      email = snapshot.get('email');
    }
  }

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Material(
        color: Color.fromRGBO(45, 123, 38, 100),
        child: ListView(
          children: <Widget>[
            buildHeader(urlImage: urlImage, name: name, email: email),
            Container(
              padding: padding,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  buildMenuItem(text: 'perfil', icon: Icons.people,onClicked: () => selectedItem(context, 0)),
                  const SizedBox(height: 16),
                  buildMenuItem(text: 'Restrito', icon: Icons.favorite_border,onClicked: () => selectedItem(context, 1)),
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
    required String email
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
              const SizedBox(height: 4,),
              Text(
                email,
                style: TextStyle(fontSize: 14, color: Colors.white),
              )
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


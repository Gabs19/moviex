
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviex/pages/perfil.dart';
import 'package:moviex/pages/restrict.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  final name = 'gabriel';
  final email = 'gabs@gmail.com';
  final urlImage = 'https://lh3.googleusercontent.com/a-/AOh14GhPhjpndc8XzXrDgm84B11xGo5B3xvo53-CVjPshg=s288-p-rw-no';

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
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Perfil()));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Restrict()));
        break;
    }
  }
}


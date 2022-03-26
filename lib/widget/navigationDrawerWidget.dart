
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Material(
        color: Colors.green,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 48),
            buildMenuItem(text: 'perfil', icon: Icons.people,onClicked: () => selectedItem(context, 0)),
            const SizedBox(height: 16),
            buildMenuItem(text: 'Restrito', icon: Icons.favorite_border,onClicked: () => selectedItem(context, 1)),
            const SizedBox(height: 24),
            Divider(color: Colors.white70),
            buildMenuItem(text: 'validar email', icon: Icons.email_outlined,onClicked: () => selectedItem(context, 2)),
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

  void selectedItem(BuildContext context, int index) {

  }
}


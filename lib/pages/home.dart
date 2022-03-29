import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:moviex/widget/navigationDrawerWidget.dart';
import 'package:url_launcher/url_launcher.dart';


class HomePage extends StatelessWidget{
  const HomePage({Key? key}) : super(key: key) ;

  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      drawer: NavigationDrawerWidget(),
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
                  onTap: () {
                    _launchLink(snapshot.data!.docs[index]['trailer']);
                    // DocumentSnapshot snap = snapshot.data!.docs[index];
                    // showDialogFunc(context,snap);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  leading: ClipRRect(
                    child: Image.network(snapshot.data!.docs[index]['cartaz']),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  title: Text(snapshot.data!.docs[index]['nome'],style: new TextStyle(color: Colors.white,),),
                  subtitle: Text(snapshot.data!.docs[index]['genero'] +  " " + snapshot.data!.docs[index]['tempo'], style: new TextStyle(color: Colors.white)),
                  tileColor: Colors.blueGrey,
                  selected: false,
                  selectedTileColor: Colors.black45,


                );
            },
            padding: EdgeInsets.all(16),
          );
        },
      )
    );
  }
}

Future<void> _launchLink(String url) async{
  if (await canLaunch(url)){
    await launch(url, forceWebView: false, forceSafariVC: false);
  }else {
    print('não foi possivel abrir essa url');
  }
}
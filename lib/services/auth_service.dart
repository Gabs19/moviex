import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moviex/databases/db_firestore.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}
class AuthService extends ChangeNotifier{
 FirebaseAuth _auth = FirebaseAuth.instance;
 late FirebaseFirestore db;

 User? usuario;
 bool isLoading = true;

 AuthService() {
   _authCheck();
   _startService();
 }

 _startService() async{
   await _startFirestore();
 }

 _startFirestore(){
   db = DBFirestore.get();
 }

  _authCheck() {
   _auth.authStateChanges().listen((User? user){
     usuario = (user == null) ? null : user;
     isLoading = false;
     notifyListeners();
   });
  }

  _getUser() {
   usuario = _auth.currentUser;
   notifyListeners();
  }

  registrar(String email, String senha,String nome) async {
   try {
     await _auth.createUserWithEmailAndPassword(email: email, password: senha);
     await db.collection('user').doc(usuario!.uid).set({
       'nome' : nome,
       'email' : email,
       'selfie' : 'https://i1.wp.com/terracoeconomico.com.br/wp-content/uploads/2019/01/default-user-image.png?ssl=1',
     });

     _getUser();
   } on FirebaseAuthException catch (e) {
     if(e.code == 'weak-password') {
       throw AuthException('A senha é muito fraca');
     } else if(e.code == 'email-already-in-use'){
       throw AuthException('Este email já está cadastrado');
     }
   }
  }


 login(String email, String senha) async {
   try {
     await _auth.signInWithEmailAndPassword(email: email, password: senha);
     _getUser();
   } on FirebaseAuthException catch (e) {
     if(e.code == 'user-not-found') {
       throw AuthException('Email não encontrado. Cadastre-se');
     } else if(e.code == 'wrong-password'){
       throw AuthException('Senha incorreta. Tente novamente');
     }
   }
 }

 logout() async {
   await _auth.signOut();
   _getUser();
 }
}
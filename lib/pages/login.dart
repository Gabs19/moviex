
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviex/pages/documentsPage.dart';
import 'package:moviex/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget{
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseStorage storage = FirebaseStorage.instance;

  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  final nome = TextEditingController();

  bool isLogin = true;
  late String titulo;
  late String actionButton;
  late String toggleButtton;
  late String selfie = "";
  late bool signIn = false;

  bool loading = false;


  @override
  void initState() {
    super.initState();
    setFormAction(true);
    loadImage();
  }

  loadImage() async{
    var ref = (await storage.ref('images').child(''));
  }

  setFormAction(bool acao){
    setState(() {
      isLogin = acao;
      if(isLogin){
        titulo = 'Bem vindo';
        actionButton = 'Sign in';
        toggleButtton = 'Ainda não tem conta? Cadastre-se agora.';
        signIn = false;
      } else {
        titulo = 'Crie sua conta';
        actionButton = 'Sign up';
        toggleButtton = 'Voltar ao login.';
        selfie = 'tire uma selfie';
        signIn = true;
      }
    });
  }

  login() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().login(email.text, senha.text);
    } on AuthException catch(e){
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  register()  async{
    try {
      await context.read<AuthService>().registrar(email.text, senha.text,nome.text);
    } on AuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100),
          child : Form(
            key: formKey,
            child : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                Visibility(
                  visible: signIn,
                  child:
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: TextFormField(
                      controller: nome,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nome",
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
                ),
                Padding(
                    padding: EdgeInsets.all(24),
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe o email corretamente!';
                        }
                        return null;
                      },
                    ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
                  child: TextFormField(
                    controller: senha,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Senha",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informa sua senha';
                      } else if (value.length < 6) {
                        return 'Sua Senha deve ter no minimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                Visibility(
                  visible: signIn,
                    child:
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 3),
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DocumentsPage(), fullscreenDialog: true)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                  selfie,
                                  style: TextStyle(fontSize: 16)
                              ),
                            ),
                            Icon(Icons.camera_alt),
                          ],
                        ),
                      ),
                    ),
                ),

                Padding(
                  padding: EdgeInsets.all(24),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                          if (isLogin) {
                            login();
                          } else {
                            register();
                          }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (loading)
                      ? [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white,),),
                        )
                      ]
                      :
                      [
                        Icon(Icons.check),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            actionButton,
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                TextButton(onPressed: () => setFormAction(!isLogin), child: Text(toggleButtton))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
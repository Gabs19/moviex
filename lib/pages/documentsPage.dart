import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:moviex/databases/db_firestore.dart';


class DocumentsPage extends StatefulWidget{
    DocumentsPage({Key?  key}): super(key: key);

    @override
    _DocumentsPageState createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  XFile? file;
  Size? size;

  final FirebaseStorage storage = FirebaseStorage.instance;
  late FirebaseFirestore firestore;
  late FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadCamera();

    firestore = DBFirestore.get();
  }

  _loadCamera() async {
    try {
      cameras = await availableCameras();
      _startCamera();
    }  on CameraException catch (e) {
      print(e.description);
    }
  }

  _startCamera() {
    if(cameras.isEmpty){
      print('Não há cameras disponiveis');
    } else {
      _previewCamera(cameras.last);
    }
  }

  _previewCamera(CameraDescription camera) async {
    final CameraController cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    controller = cameraController;

    try {
     await cameraController.initialize();
    } on CameraException catch(e){
      print(e.description);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context){
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Tire sua Selfie'),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[900],
        child: Center(
          child: _arquivoWidget(),
        ),
      ),
      floatingActionButton: (file != null) ? FloatingActionButton.extended(onPressed: upload ,label: Text('Finalizar'),)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _arquivoWidget() {
    return Container(
      width: size!.width - 50,
      height: size!.height - (size!.height / 3),
      child: file == null ? _cameraPreviewWidget()
          : Image.file(
          File(file!.path),
          fit: BoxFit.contain,
      ),
    );
  }

  _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return Text('Widget para Câmera que não está disponivel');
    } else {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          CameraPreview(controller!),
          _botaoCapturaWidget(),
        ],
      );
    }
  }

  _botaoCapturaWidget() {
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: CircleAvatar(
        radius: 32,
        backgroundColor: Colors.black.withOpacity(0.5),
        child: IconButton(
          icon: Icon(Icons.camera_alt, color: Colors.white,size: 30,),
          onPressed: tirafoto,
        ),
      ),
    );
  }

  tirafoto() async {
    final CameraController? cameraController = controller;

    if(cameraController != null && cameraController.value.isInitialized){
      try {
        XFile image = await cameraController.takePicture();
        if (mounted) setState(() => file = image);
      } on CameraException catch(e) {
        print(e.description);
      }
    }
  }

  Future<void> upload() async{
    XFile? selfie = file;
    if (selfie != null){
        File file = File(selfie.path);
        try{
          String ref = 'images/img-${DateTime.now().toString()}.jpg';
          await storage.ref(ref).putFile(file);

          if(auth.currentUser != null){
            final snapshot = await firestore.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).set({
                'selfie' : 'img-${DateTime.now().toString()}.jpg',
                },
              SetOptions(merge: true),
            );
          }

        } on FirebaseException catch(e) {
          throw Exception('Erro no upload: ${e.code}');
        }
        Navigator.pop(context);
    }
  }
}
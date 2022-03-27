class user {
  late String _nome;
  late String _email;
  late String _selfie;

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get email => _email;

  String get selfie => _selfie;

  set selfie(String value) {
    _selfie = value;
  }

  set email(String value) {
    _email = value;
  }
}
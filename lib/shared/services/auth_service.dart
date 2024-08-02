import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_tasks_app/shared/utils/shared_preferences_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> createUser(String email, String senha) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
  }

  Future<UserCredential> loginUsuario(String email, String senha) async {
    var userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );

    await SharedPreferencesService.setString(
        'userId', userCredential.user!.uid);

    return userCredential;
  }

  Future<void> logout() async {
    await _auth.signOut();
    await SharedPreferencesService.remove('userId');
  }

  bool isAuthenticated() {
    var userId = SharedPreferencesService.getString('userId');
    return userId != null;
  }
}

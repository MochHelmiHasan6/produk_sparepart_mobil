import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
String nameGoogle;
String emailGoogle;
String imageUrl;
String errorMessageRegister;
String errorMessageLogin;

Future<String> signInWithGoogle() async {
  await Firebase.initializeApp();
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;
  if (user != null) {
// Checking if email and name is null
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);
    nameGoogle = user.displayName;
    emailGoogle = user.email;
    imageUrl = user.photoURL;
// Only taking the first part of the name, i.e., First Name
    if (nameGoogle.contains(" ")) {
      nameGoogle = nameGoogle.substring(0, nameGoogle.indexOf(" "));
    }
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    print('signInWithGoogle succeeded: $user');
    return '$user';
  }
  return null;
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();
  print("User Signed Out");
  nameGoogle = "";
  emailGoogle = "";
  imageUrl = "";
}

Future<User> signWithEmailAndPassword(String email, String password) async {
  await Firebase.initializeApp();
  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    assert(user != null);
    assert(await user.getIdToken() != null);
    final User currentUser = await _auth.currentUser;
    assert(user.uid == currentUser.uid);
    return user;
  } catch (e) {
    if (e.code == 'user-not-found') {
      errorMessageLogin = "User not found for this email";
    } else if (e.code == 'wrong-password') {
      errorMessageLogin = "Your password is wrong";
    } else if (e.code == 'unknown') {
      errorMessageLogin = "Please enter your Email and Password";
    } else if (e.code == 'invalid-email') {
      errorMessageLogin = "Invalid Email";
    }
    print(e.toString());
    return null;
  }
}

Future<User> signUp(String email, String password) async {
  await Firebase.initializeApp();
  try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    assert(user != null);
    assert(await user.getIdToken() != null);
    return user;
  } catch (e) {
    if (e.code == 'email-already-in-use') {
      errorMessageRegister = "Email already in use";
    } else if (e.code == 'operation-not-allowed') {
      errorMessageRegister = "Email / Password is required";
    } else if (e.code == 'unknown') {
      errorMessageRegister = "Please enter your email and password";
    } else if (e.code == 'invalid-email') {
      errorMessageRegister = "Invalid Email";
    } else if (e.code == 'weak-password') {
      errorMessageRegister = "Weak Password, must be more thane 8 character";
    }
    print(e.toString());
    return null;
  }
}

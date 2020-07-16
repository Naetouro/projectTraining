import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:projecttrainingflutter/api/ApiMuscles.dart';
import 'package:projecttrainingflutter/constants/RouteName.dart';
import 'package:projecttrainingflutter/globals/Globals.dart';
import 'package:projecttrainingflutter/models/User.dart';
import 'package:projecttrainingflutter/widgets/CustomAppBar.dart';
import 'package:projecttrainingflutter/widgets/CustomDrawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ScreenLogin extends StatefulWidget {
  ScreenLogin({Key key}) : super(key: key);

  @override
  _ScreenLoginState createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<GoogleSignInAccount> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );


    ApiMuscles().findAll2(googleAuth.idToken);

    var response = await http.get("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=${googleAuth.idToken}");
    print(response.body);

/*


    print("signed in " + user.displayName);
    user.getIdToken().then((value) async {
      print(googleAuth.idToken);
        var response = await http.get("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token="+googleAuth.idToken);
        print(response.body);
        ApiMuscles().findAll2(googleAuth.idToken);
    });
*/
    //print(user.uid);
    return googleUser;
  }

  Future<void> setUser(
      String id, String name, String email, String image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("id", id);
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('image', image);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const FlutterLogo(
            size: 150,
          ),
          const SizedBox(height: 50),
          OutlineButton(
            highlightElevation: 0,
            borderSide: const BorderSide(color: Colors.grey),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/google_logo.png",
                  height: 35.0,
                ),
                const Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: const Text("Sign in with Google"),
                )
              ],
            ),
            onPressed: () {
              _handleSignIn().then((GoogleSignInAccount user) {
                setUser(user.id, user.displayName, user.email, user.photoUrl)
                    .then((value) =>
                        Navigator.pushNamed(context, RouteSplashScreen));
              }).catchError((e) => print(e));
            },
          )
        ],
      )),
    );
  }
}

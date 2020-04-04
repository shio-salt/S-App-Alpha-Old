import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => new _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final formkey = new GlobalKey<FormState>();

  String _email;
  String _password;

  Future<String> signInWithEmailAndPassword(String email,
      String password) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)).user;
    return user.uid;
  }

  bool validateAndSave() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.red,
    ),
  );

  void signin() async {
    if (validateAndSave()) {
      try {
        final user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: _email, password: _password)).user;
        if (user.isEmailVerified) {
          Navigator.of(context).pushReplacementNamed("/Signin");
        } else {
          Alert(
            context: context,
            style: alertStyle,
            type: AlertType.error,
            title: "",
            desc: "このアカウントは、認証されていません。",
            buttons: [
              DialogButton(
                child: Text(
                  "閉じる",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                color: Color.fromRGBO(0, 0, 0, 1.0),
                radius: BorderRadius.circular(0.0),
              ),
            ],
          ).show();
        }
      } catch (e) {
        switch (e.code) {
          case 'ERROR_INVALID_EMAIL':
            Alert(
              context: context,
              style: alertStyle,
              type: AlertType.error,
              title: "",
              desc: "メールアドレスの形式が、正しくありません。",
              buttons: [
                DialogButton(
                  child: Text(
                    "閉じる",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                  color: Color.fromRGBO(0, 0, 0, 1.0),
                  radius: BorderRadius.circular(0.0),
                ),
              ],
            ).show();
            print(e);
            break;
          case 'ERROR_WRONG_PASSWORD':
            Alert(
              context: context,
              style: alertStyle,
              type: AlertType.error,
              title: "",
              desc: "パスワードが、正しくありません。",
              buttons: [
                DialogButton(
                  child: Text(
                    "閉じる",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                  color: Color.fromRGBO(0, 0, 0, 1.0),
                  radius: BorderRadius.circular(0.0),
                ),
              ],
            ).show();
            print(e);
            break;
          case 'ERROR_USER_DISABLED':
            Alert(
              context: context,
              style: alertStyle,
              type: AlertType.error,
              title: "",
              desc: "このアカウントは、存在しません。",
              buttons: [
                DialogButton(
                  child: Text(
                    "閉じる",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                  color: Color.fromRGBO(0, 0, 0, 1.0),
                  radius: BorderRadius.circular(0.0),
                ),
              ],
            ).show();
            print(e);
            break;
          case 'ERROR_TOO_MANY_REQUESTS':
            Alert(
              context: context,
              style: alertStyle,
              type: AlertType.error,
              title: "",
              desc: "サインインを制限しました。",
              buttons: [
                DialogButton(
                  child: Text(
                    "閉じる",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  onPressed: () => Navigator.pop(context),
                  color: Color.fromRGBO(0, 0, 0, 1.0),
                  radius: BorderRadius.circular(0.0),
                ),
              ],
            ).show();
            print(e);
            break;
        }
      }
    }
  }


    @override
    Widget build(BuildContext context) {
      return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: new Text("サインイン"),
        ),
        body: new Container(
          padding: EdgeInsets.all(20.0),
          child: new Form(
            key: formkey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs() + buildSubmitButtons(),
            ),
          ),
        ),
      );
    }

    List<Widget> buildInputs() {
      return [
        new Icon(
          Icons.person,
          size: 160.0,
        ),
        new TextFormField(
          decoration: new InputDecoration(
            labelText: 'メールアドレス',
            icon: Icon(Icons.mail_outline),
          ),
          validator: (value) => value.isEmpty ? 'メールアドレスを入力して下さい。' : null,
          onSaved: (value) => _email = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(
            labelText: 'パスワード',
            icon: Icon(Icons.lock_outline),
          ),
          validator: (value) => value.isEmpty ? 'パスワードを入力して下さい。' : null,
          obscureText: true,
          onSaved: (value) => _password = value,
        ),
      ];
    }

    List<Widget> buildSubmitButtons() {
      return [
        new RaisedButton(
          color: Colors.black,
          child: new Text('サインイン', style: new TextStyle(fontSize: 20.0)),
          onPressed: signin,
        ),
        new FlatButton(
          child: new Text('アカウント作成', style: new TextStyle(fontSize: 20.0)),
          onPressed: () {
            Navigator.of(context).pushNamed("/Create");
          },
        ),
        new FlatButton(
            child: new Text('パスワード再設定', style: new TextStyle(fontSize: 20.0)),
            onPressed: () {
              Navigator.of(context).pushNamed("/Reset");
            }
        ),
      ];
    }
  }
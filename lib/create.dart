import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => new _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final formkey = new GlobalKey<FormState>();

  String _username;
  String _email;
  String _password;
  String _confirmation;

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<void> updateProfile(FirebaseUser user,
      {String name, String photoUrl}) async {
    try {
      if (user != null) {
        UserUpdateInfo userInfo = UserUpdateInfo();
        userInfo.photoUrl = photoUrl;
        userInfo.displayName = name;
        await user.updateProfile(userInfo);
      }
    } catch (e) {
      print("UpdateProfile: $e");
    }
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

  void create() async {
    if (validateAndSave()) {
      try {
        if (_password == _confirmation) {
          final FirebaseUser user = (await _firebaseAuth
              .createUserWithEmailAndPassword(
              email: _email, password: _password))
              .user;
          await user.sendEmailVerification();
          await updateProfile(
              user, name: _username, photoUrl: 'https://www.google.co.jp/');
          Alert(
            context: context,
            style: alertStyle,
            type: AlertType.success,
            title: "",
            desc: "認証メールを送信しました。メールに記載されているURLにアクセスして下さい。",
            buttons: [
              DialogButton(
                child: Text(
                  "閉じる",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed("/Signout"),
                color: Color.fromRGBO(0, 0, 0, 1.0),
                radius: BorderRadius.circular(0.0),
              ),
            ],
          ).show();
        } else {
          Alert(
            context: context,
            style: alertStyle,
            type: AlertType.error,
            title: "",
            desc: "パスワードが、一致しません。",
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
          case 'ERROR_WEAK_PASSWORD':
            Alert(
              context: context,
              style: alertStyle,
              type: AlertType.error,
              title: "",
              desc: "パスワードの強度が十分ではありません。",
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
          case 'ERROR_INVALID_EMAIL':
            Alert(
              context: context,
              style: alertStyle,
              type: AlertType.error,
              title: "",
              desc: "メールアドレスの形式が正しくありません。",
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
          case 'ERROR_EMAIL_ALREADY_IN_USE':
            Alert(
              context: context,
              style: alertStyle,
              type: AlertType.error,
              title: "",
              desc: "このメールアドレスは既に使用されています。",
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
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text("アカウント作成"),
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
      new TextFormField(
        decoration: new InputDecoration(
          labelText: '名前',
          icon: Icon(Icons.person),),
        validator: (value) => value.isEmpty ? '名前を入力して下さい。' : null,
        onSaved: (value) => _username = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(
          labelText: 'メールアドレス',
          icon: Icon(Icons.mail_outline),),
        validator: (value) => value.isEmpty ? 'メールアドレスを入力して下さい。' : null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(
          labelText: 'パスワード',
          icon: Icon(Icons.lock_outline),),
        validator: (value) => value.isEmpty ? 'パスワードを入力して下さい。' : null,
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(
          labelText: '確認',
          icon: Icon(Icons.lock_outline),),
        validator: (value) => value.isEmpty ? 'パスワードを再入力して下さい。' : null,
        obscureText: true,
        onSaved: (value) => _confirmation = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    return [
      new RaisedButton(
        color: Colors.black,
        child: new Text('アカウント作成', style: new TextStyle(fontSize: 20.0)),
        onPressed: create,
      ),
    ];
  }
}
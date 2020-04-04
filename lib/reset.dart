import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ResetPage extends StatefulWidget {
  @override
  _ResetPageState createState() => new _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final formkey = new GlobalKey<FormState>();

  String _email;
  String _password;

  Future<void> sendPasswordResetEmail({
    @required String email,
  }) async {
    assert(email != null);
    return _firebaseAuth.sendPasswordResetEmail(email: email);
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

  void reset() async {
    if (validateAndSave()) {
      try {
        await sendPasswordResetEmail(email: _email);
        Alert(
          context: context,
          style: alertStyle,
          type: AlertType.success,
          title: "",
          desc: "再設定メールを送信しました。メールに記載されているURLにアクセスして下さい。",
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
      }
      catch (e) {
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
          case 'ERROR_USER_NOT_FOUND':
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
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text("パスワード再設定"),
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
          icon: Icon(Icons.mail_outline),),
        validator: (value) => value.isEmpty ? 'メールアドレスを入力して下さい。' : null,
        onSaved: (value) => _email = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    return [
      RaisedButton(
        color: Colors.black,
        child: new Text('パスワード再設定', style: new TextStyle(fontSize: 20.0)),
        onPressed: reset,
      ),
    ];
  }
}
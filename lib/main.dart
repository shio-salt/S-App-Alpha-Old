import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s_app/signin.dart';
import 'package:s_app/create.dart';
import 'package:s_app/reset.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'S-App',
      theme: new ThemeData.dark(),
      home: new SigninPage(),
      routes: <String, WidgetBuilder>{
        '/Signin': (_) => new HomePage(),
        '/Create': (_) => new CreatePage(),
        '/Signout': (_) => new SigninPage(),
        '/Reset': (_) => new ResetPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    /*Container(
        height: 100.0,
        width: double.infinity,
        color: Colors.red,
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        child: RaisedButton.icon(
      icon: Icon(Icons.school, color: Colors.white),
      label: Text("WHS-Lock"),
      onPressed: null)
    ),*/
    ListView(
      children: <Widget>[
    Container(
      height: 100.0,
      width: double.infinity,
      color: Colors.red,
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      child: RaisedButton.icon(
        icon: Icon(Icons.school, color: Colors.white),
        label: Text("WHS-Lock"),
        onPressed: null)
    )
      ],
    ),
    Text(
      '準備中',
      style: optionStyle,
    ),
    Text(
      '準備中',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<String> _getCurrentUserProfile() async {
    return await FirebaseAuth.instance.currentUser().then((user) {
      return ' ㅤ' + user.displayName + '\n' + ' ㅤ' + user.email;
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text("ホーム"),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.lock),
              title: Text('Lock',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.looks),
              title: Text('Sensor',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.device_hub),
              title: Text('Hub',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
        drawer: Drawer(
            child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ClipRect(
                    child: Container(
                      color: Colors.black,
                      child: IconButton(icon: Icon(Icons.person,
                          size: 50),
                        onPressed: null,
                      ),
                    ),
                  ),
                  Container(
                    height: 90,
                    child: DrawerHeader(
                        child: FutureBuilder(
                            future: _getCurrentUserProfile(),
                            builder: (BuildContext context,
                                AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                );
                              } else {
                                return Text("Error");
                              }
                            }
                        ),
                        decoration: BoxDecoration(
                            color: Colors.black
                        ),
                        margin: EdgeInsets.all(0.0),
                        padding: EdgeInsets.all(0.0)
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_box),
                    title: Text('アカウント情報',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('設定',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('',
                      style: TextStyle(
                        fontSize: 200,
                      ),
                    ),
                    onTap: () {},
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('サポート',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("/Signout");
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('情報',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("/Signout");
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.description),
                    title: Text('利用規約',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("/Signout");
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.security),
                    title: Text('個人情報保護方針',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("/Signout");
                    },
                  ),
                ]
            )
        )
    );
  }
}
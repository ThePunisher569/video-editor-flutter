
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_editor_app/hidden_vault/enter_PIN.dart';
import 'hidden_vault/create_PIN.dart';
import 'settings.dart';
import 'video/video_trimmer_home_screen.dart';

import 'audio/audio_trimmer_home_screen.dart';
import 'files/files_home_screen.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<Widget> _bottomNavigationWidgets=[
    FilesHomeScreen(),VideoTrimmerHomeScreen(),AudioTrimmerHomeScreen()
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text('Hi, Name Goes here!',style: TextStyle(fontSize: 20,)),
                  SizedBox(height: 10),
                  Text('Email Goes here',style: TextStyle(fontSize: 15),),
                  SizedBox(height: 10),

                  ButtonBar(
                    children: [
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)
                        ),
                        textColor: Colors.black,
                        color: Colors.deepPurpleAccent.shade100,
                        child:Text('Login In or Sign Up'),
                        onPressed: () {
                          //TODO: Login Screen and sign up screen

                        },
                      ),
                    ],
                  )
                ],
            ),
            decoration: BoxDecoration(color: Colors.deepPurpleAccent)
            ),
            ListTile(
              leading: Icon(Icons.settings_applications_outlined,size: 30,),
              title: Text('Settings'),
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings())),
            ),
            ListTile(
              leading: Icon(Icons.lock_outline,size: 30,),
              title: Text('Vault'),
              onTap: () async{

                SharedPreferences prefs = await SharedPreferences.getInstance();
                if(prefs.getBool('isPINCreated')??false){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EnterPIN())
                  );
                }
                else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreatePIN())
                  );
                }
              })

          ],

        ),
      ),
      appBar: AppBar(
        title: Text('Editing Tools'),
        actions: [IconButton(icon:Icon(Icons.logout,size: 30),
            onPressed: () {
          //TODO: Logout from firebase
          })
      ],
      ),
      body: _bottomNavigationWidgets.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.folder),label: 'Files'),
        BottomNavigationBarItem(icon: Icon(Icons.video_library),label: 'Video Trimmer'),
        BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Audio Trimmer')
      ],
        onTap: (index){
        setState(() {
          _selectedIndex=index;
        });
        },
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 15,

      ),
    );
  }
}

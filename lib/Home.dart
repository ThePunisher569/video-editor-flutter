
import 'package:flutter/material.dart';
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
      appBar: AppBar(title: Text('Video Editor')),
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

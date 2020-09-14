import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    //TODO: Shared preferences and settings
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Container(),
    );
  }
}

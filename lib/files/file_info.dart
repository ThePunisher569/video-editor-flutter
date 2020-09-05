import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class FileInfo extends StatelessWidget {
  final File _trimmedFile;


  FileInfo(this._trimmedFile);

  @override
  Widget build(BuildContext context) {
    //TODO: Implement file information window put name,location,size,extension,lastModified,lastAccessed

    final suffixes = ['B','KB','MB','GB'];
    final i = (log(_trimmedFile.lengthSync())/log(1024)).floor();
    final fileSize = ((_trimmedFile.lengthSync()/pow(1024, i))).toStringAsFixed(2) + ' ' +suffixes[i];

    return Scaffold(
      appBar: AppBar(title: Text('Information')),
      body: Container(
        padding: EdgeInsets.all(10),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
              Text('Name:',style: TextStyle(color: Colors.black,fontSize: 18)),
              SizedBox(width: 30,),
              Expanded(child: Text('${_trimmedFile.path.split('/').last}'),flex: 3,)]),

            SizedBox(width: MediaQuery.of(context).size.width,height: 10,),

            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Location:',style: TextStyle(color: Colors.black,fontSize: 18)),
                SizedBox(width: 10,),
                Expanded(child: Text('${_trimmedFile.path}'),flex: 3)]),

            SizedBox(width: MediaQuery.of(context).size.width,height: 20,),

            Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Size'),
                  SizedBox(height: 5,),
                  Text('$fileSize')
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Type'),
                  SizedBox(height: 5,),
                  Text('${_trimmedFile.path.split('.').last.toUpperCase()}')
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Size'),
                  SizedBox(height: 5,),
                  Text('$fileSize')
                ],
              )
            ]),
          ])
      )
    );
  }
}

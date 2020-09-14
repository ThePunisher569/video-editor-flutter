import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';



class FileInfo extends StatelessWidget {
  final File _trimmedFile;
  final Uint8List videoThumbnail;

  FileInfo(this._trimmedFile, this.videoThumbnail);
  @override
  Widget build(BuildContext context) {

    final suffixes = ['B','KB','MB','GB'];
    final i = (log(_trimmedFile.lengthSync())/log(1024)).floor();
    final fileSize = ((_trimmedFile.lengthSync()/pow(1024, i))).toStringAsFixed(2) + ' ' +suffixes[i];

    return Scaffold(
      appBar: AppBar(title: Text('Information')),
      body: Container(
        color: Colors.black,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.3,
              child: Image.memory(videoThumbnail),
            ),
            Expanded(
                child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 5,
                    child: Container(padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Name:',style: TextStyle(color: Colors.black,fontSize: 18)),
                              SizedBox(width: 50,),
                              Expanded(child: Text('${_trimmedFile.path.split('/').last}'),flex: 3,)]
                        ),

                        SizedBox(width: MediaQuery.of(context).size.width,height: 10,),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Location:',style: TextStyle(color: Colors.black,fontSize: 18)),
                              SizedBox(width: 30,),
                              Expanded(child: Text('${_trimmedFile.path}'),flex: 3)]
                        ),

                        SizedBox(width: MediaQuery.of(context).size.width,height: 20,),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Size:',style: TextStyle(color: Colors.black,fontSize: 18)),
                              SizedBox(width: 80,),
                              Text('$fileSize')]
                        ),

                        SizedBox(width: MediaQuery.of(context).size.width,height: 20,),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Type:',style: TextStyle(color: Colors.black,fontSize: 18)),
                              SizedBox(width: 80,),
                              Text('${_trimmedFile.path.split('.').last.toUpperCase()}')]
                        ),


                        SizedBox(width: MediaQuery.of(context).size.width,height: 20,),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Last Accessed:',style: TextStyle(color: Colors.black,fontSize: 18)),
                              SizedBox(width: 50,),
                              Text('${_trimmedFile.lastAccessedSync()}')]
                        ),

                        SizedBox(width: MediaQuery.of(context).size.width,height: 20,),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Last Modified:',style: TextStyle(color: Colors.black,fontSize: 18)),
                              SizedBox(width: 60,),
                              Text('${_trimmedFile.lastModifiedSync()}')]
                        )
                    ],
                  ),
                )
            )
            ),


          ])
      )
    );
  }
}

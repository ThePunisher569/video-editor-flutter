import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_trimmer/video_trimmer.dart';

import 'video_editor.dart';

class VideoTrimmerHomeScreen extends StatelessWidget {
  final Trimmer _trimmer = Trimmer();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Choose the video: ',style: TextStyle(
              fontSize: 20.0
          ),),
          SizedBox(width: 10),
          RaisedButton(
              color: Colors.deepPurpleAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)
              ),
              child: Icon(Icons.file_upload),
              onPressed: () async{
                File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
                if(video!=null) {
                  await _trimmer.loadVideo(videoFile: video);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => VideoEditor(_trimmer)));
                }
              })
        ],
      ),
    );
  }
}


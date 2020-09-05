import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_trimmer/storage_dir.dart';

import 'package:video_trimmer/trim_editor.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:video_trimmer/video_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class VideoEditor extends StatefulWidget {
  final Trimmer _trimmer;

  VideoEditor(this._trimmer);

  @override
  _VideoEditorState createState() => _VideoEditorState();
}

class _VideoEditorState extends State<VideoEditor> {

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _resultVisibility = false;

  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  String _finalVideoPath;


  Future<String> _saveVideo() async {

    String _value;

    await widget._trimmer
        .saveTrimmedVideo(startValue: _startValue, endValue: _endValue,
        storageDir: StorageDir.externalStorageDirectory).then((value) {
      setState(() {
        _value = value;
      });
    });

    return _value;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Edit')),
    body: Builder(
      builder: (context)=>Center(
        child: Container(
          padding: EdgeInsets.only(bottom: 30.0),
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Visibility(
                visible: _resultVisibility,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Video saved Successfully in: $_finalVideoPath\n\nFind the video in file manager using the path provided above.',
                      style: TextStyle(color: Colors.white)
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(onPressed: (){
                          setState(() {
                            _resultVisibility=false;
                          });
                        },
                        child: Text('Hide'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)
                          ),
                          color: Colors.deepPurpleAccent,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: VideoViewer(),
              ),
              Center(
                child: TrimEditor(
                  viewerHeight: 50.0,
                  viewerWidth: MediaQuery.of(context).size.width,
                  onChangeStart: (value) {
                    _startValue = value;
                  },
                  onChangeEnd: (value) {
                    _endValue = value;
                  },
                  onChangePlaybackState: (value) {
                    setState(() {
                      _isPlaying = value;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)
                    ),
                    color: Colors.deepPurpleAccent,
                    onPressed: () async {
                      _saveVideo().then((outputPath) {
                        setState(() {
                          _resultVisibility=true;
                          _finalVideoPath=outputPath;
                        });
                        final snackBar = SnackBar(content: Text('Video Saved successfully!'));
                        Scaffold.of(context).showSnackBar(snackBar);
                      });
                    },
                    child: Text('Save'),
                  ),
                  FlatButton(
                    child: _isPlaying
                        ? Icon(
                      Icons.pause,
                      size: 80.0,
                      color: Colors.white,
                    )
                        : Icon(
                      Icons.play_arrow,
                      size: 80.0,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      bool playbackState =
                      await widget._trimmer.videPlaybackControl(
                        startValue: _startValue,
                        endValue: _endValue,
                      );
                      setState(() {
                        _isPlaying = playbackState;
                      });
                    },
                  ),
                  Expanded(child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)
                      ),
                      color: Colors.deepPurpleAccent,
                      onPressed: () async{
                        File file = await FilePicker.getFile(type:FileType.audio);

                        if(file != null){
                          String audioFilePath = file.path;
                          await widget._trimmer.saveTrimmedVideo(startValue: _startValue, endValue: _endValue,)
                              .then((value){

                            String mutedVideoFile = value+'_muted.mp4';
                            _flutterFFmpeg.execute("-i $value -vcodec copy -an $mutedVideoFile")
                                .then((rc){

                              String finalVideo = value+'_withAudio.mp4';
                              var arguments = ["-i",mutedVideoFile,"-i",audioFilePath,"-codec","copy","-shortest",finalVideo];
                              _flutterFFmpeg.executeWithArguments(arguments)
                                  .then((rc) async {

                                await getExternalStorageDirectory()
                                    .then((value)async {
                                      if(!(await (Directory(value.path+'/trimmedWithAudio').exists()))){
                                        Directory(value.path+'/trimmedWithAudio/').create();
                                      }

                                  File(finalVideo).copy(value.path+'/trimmedWithAudio/'+finalVideo.split('/').last)
                                      .then((value){

                                    print(value.path);
                                    setState(() {
                                      _resultVisibility=true;
                                      _finalVideoPath=value.path;
                                    });

                                  });
                                });


                              });
                            });

                          });
                        }
                        else{
                          final snackBar = SnackBar(content: Text('No music selected! Please select a music for the video in order to save the video.'));
                          Scaffold.of(context).showSnackBar(snackBar);
                        }

                      },
                      child: Text('Add sound and save video')
                  ),
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

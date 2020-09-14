import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:video_editor_app/video/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'file_info.dart';


class FilesHomeScreen extends StatefulWidget {
  @override
  _FilesHomeScreenState createState() => _FilesHomeScreenState();
}

class _FilesHomeScreenState extends State<FilesHomeScreen> {
  List _trimmedWithAudioFiles = new List();
  List _trimmedVideoFiles = new List();
  String _appDocsDirectory;

  // PopUpMenu items
  List<Icon> popUpMenuIcons= [
    Icon(Icons.delete_forever,color: Colors.red,semanticLabel: 'delete',),
    Icon(Icons.share,color: Colors.blue, semanticLabel: 'share',),
    Icon(Icons.info,color: Colors.black, semanticLabel: 'info',)
  ];

  //list files from externalStorageDirectory method
  Future<void> _listFiles()async{
    _appDocsDirectory = (await getExternalStorageDirectory()).path;
    if(await Directory('$_appDocsDirectory/trimmedWithAudio/').exists()){
      setState(() {
        _trimmedWithAudioFiles=Directory('$_appDocsDirectory/trimmedWithAudio/').listSync();
      });
    }
    if(await Directory('$_appDocsDirectory/Trimmer/').exists()){
      setState(() {
        _trimmedVideoFiles = Directory('$_appDocsDirectory/Trimmer/').listSync();
      });
    }

  }





  @override
  void initState() {
    super.initState();
    _listFiles();
  }




  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(child: _trimmedWithAudioFiles.isEmpty&&_trimmedVideoFiles.isEmpty?
    Center(child: Text('Wow! Such empty'))
        : Container(
      padding: EdgeInsets.all(5),
        child: Column(
        children: [
          SizedBox(height: 10),
          Text('Trimmed videos with custom sound',style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold)
          ),
          SizedBox(height: 10),
          Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border.all(width: 2),borderRadius: BorderRadius.all(Radius.circular(10))),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _trimmedWithAudioFiles.length,
                    itemBuilder: (BuildContext context,int index){
                      String trimmedWithAudioFilePath = _trimmedWithAudioFiles.elementAt(index).toString().substring(7,_trimmedWithAudioFiles.elementAt(index).toString().length-1);
                      // /storage/emulated/0/Android/data/com.example.video_editor_app/files/trimmedWithAudio/image_picker1454177772836198879_trimmed:Aug28,2020-14:57:45.mp4
                      String trimmedWithAudioFileName = _trimmedWithAudioFiles.elementAt(index).toString().split('/').last;
                      trimmedWithAudioFileName = trimmedWithAudioFileName.substring(0,trimmedWithAudioFileName.length-1);
                      //image_picker1454177772836198879_trimmed:Aug28,2020-14:57:45.mp4

                      File trimmedWithAudioFile = new File(trimmedWithAudioFilePath);




                      return Container(
                        decoration: BoxDecoration(border: Border(
                            bottom: BorderSide(width: 1)
                        )),
                        child: ListTile(
                            title: Text(trimmedWithAudioFileName),
                            leading: Icon(Icons.video_library_rounded,color: Colors.black,size: 40),
                            trailing: PopupMenuButton(icon: Icon(Icons.more_vert,color: Colors.black),
                              offset: Offset(0,100),//set offset to change the position of menu
                              itemBuilder: (BuildContext context) {
                                return popUpMenuIcons.map((Icon e){
                                  return PopupMenuItem(child: Center(child: e,),value: e.semanticLabel,);
                                }).toList();
                              },
                              onSelected: (value)async{


                                switch(value) {
                                //Delete
                                  case 'delete':
                                    assert (trimmedWithAudioFile!=null);
                                    await trimmedWithAudioFile.delete().then((value){
                                      _listFiles();
                                      final snackBar = new SnackBar(
                                          content: Text('Video deleted successfully!'),
                                          duration: Duration(seconds: 1)
                                      );
                                      Scaffold.of(context).showSnackBar(snackBar);
                                    });
                                    break;
                                //Share
                                  case 'share':
                                    await FlutterShare.shareFile(
                                      title: 'a',
                                      filePath: trimmedWithAudioFilePath,
                                    ).then((value) => {
                                      print('file shared successfully!!!! $value')
                                    });
                                    break;
                                  case 'info':
                                    final uint8list = await VideoThumbnail.thumbnailData(
                                      video: trimmedWithAudioFile.path,
                                      imageFormat: ImageFormat.JPEG,
                                      quality: 50,
                                    );
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>FileInfo(trimmedWithAudioFile,uint8list)));
                                    break;
                                }
                              },),
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=>VideoPlayer(trimmedWithAudioFilePath)));
                            }
                        ),
                      );
                    }
                ),
              )
          ),
          SizedBox(height: 10),
          Text('Trimmed videos',
              style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold)
          ),
          SizedBox(height: 10),
          Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border.all(width: 2),borderRadius: BorderRadius.all(Radius.circular(10))),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    //shrinkWrap: true,
                    itemCount: _trimmedVideoFiles.length,
                    itemBuilder: (BuildContext context,int index) {
                      String trimmedVideoFilePath = _trimmedVideoFiles.elementAt(index).toString().substring(7,_trimmedVideoFiles.elementAt(index).toString().length-1);
                      // /storage/emulated/0/Android/data/com.example.video_editor_app/files/Trimmer/image_picker1454177772836198879_trimmed:Aug28,2020-14:57:45.mp4
                      String trimmedVideoFileName = _trimmedVideoFiles.elementAt(index).toString().split('/').last;
                      trimmedVideoFileName = trimmedVideoFileName.substring(0,trimmedVideoFileName.length-1);
                      //image_picker1454177772836198879_trimmed:Aug28,2020-14:57:45.mp4

                      File trimmedVideoFile = new File(trimmedVideoFilePath);


                      return Container(
                        decoration: BoxDecoration(border: Border(
                            bottom: BorderSide(width: 1)
                        )),
                        child: ListTile(
                            title: Text(trimmedVideoFileName),
                            leading: Icon(Icons.video_library_rounded,size: 40,color: Colors.black),
                            trailing: PopupMenuButton(icon: Icon(Icons.more_vert,color: Colors.black),
                              offset: Offset(0,100),//set offset to change the position of menu
                              itemBuilder: (BuildContext context) {
                                return popUpMenuIcons.map((Icon e){
                                  return PopupMenuItem(child: Center(child: e,),value: e.semanticLabel,);
                                }).toList();
                              },
                              onSelected: (value) async{
                                switch(value){
                                  case 'delete':
                                    await trimmedVideoFile?.delete()?.then((value){
                                      _listFiles();
                                      final snackBar = SnackBar(
                                          content: Text('Video deleted successfully!'),
                                          duration: Duration(seconds: 1)
                                      );
                                      Scaffold.of(context).showSnackBar(snackBar);
                                    });
                                    break;
                                  case 'share':
                                    await FlutterShare.shareFile(
                                      title: 'b',
                                      filePath: trimmedVideoFilePath,
                                    ).then((value) => {
                                      print('file shared successfully!!!! $value')
                                    });
                                    break;
                                  case 'info':
                                    final trimmedVideoThumbnail = await VideoThumbnail.thumbnailData(
                                      video: trimmedVideoFile.path,
                                      imageFormat: ImageFormat.JPEG,
                                      quality: 50,
                                    );
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (BuildContext context)=>FileInfo(trimmedVideoFile,trimmedVideoThumbnail))
                                    );
                                    break;
                                }
                              },),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoPlayer(trimmedVideoFilePath)));
                            }),
                      );
                    }),
              )
          ),
        ],
      )

    ),
      onRefresh: ()=>_listFiles(),
    );
  }
}

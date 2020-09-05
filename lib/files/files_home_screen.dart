import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:video_editor_app/video/video_player.dart';

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
  List<Icon> items= [
    Icon(Icons.delete_forever,color: Colors.red,semanticLabel: 'delete',),
    Icon(Icons.share,color: Colors.blue, semanticLabel: 'share',),
    Icon(Icons.info,color: Colors.black, semanticLabel: 'info',)
  ];

  //list files from externalStorageDirectory method
  Future<void> _listFiles()async{
    _appDocsDirectory = (await getExternalStorageDirectory()).path;
    print(_appDocsDirectory);
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

    print(_trimmedVideoFiles);
    print(_trimmedWithAudioFiles);
  }





  @override
  void initState() {
    super.initState();
    _listFiles();
    print('initState called');
  }




  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(child: _trimmedWithAudioFiles.isEmpty&&_trimmedVideoFiles.isEmpty?
    Center(child: Text('Wow! Such empty'))
        : Container(
      padding: EdgeInsets.all(5),
        child: Column(
        children: [
          SizedBox(height: 5),
          Text('Trimmed videos with custom sound',style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold)
          ),
          SizedBox(height: 5),
          Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                  //shrinkWrap: true,
                  itemCount: _trimmedWithAudioFiles.length,
                  itemBuilder: (BuildContext context,int index){
                    String trimmedWithAudioFilePath = _trimmedWithAudioFiles.elementAt(index).toString().substring(7,_trimmedWithAudioFiles.elementAt(index).toString().length-1);
                    print(trimmedWithAudioFilePath);// /storage/emulated/0/Android/data/com.example.video_editor_app/files/trimmedWithAudio/image_picker1454177772836198879_trimmed:Aug28,2020-14:57:45.mp4
                    String trimmedWithAudioFileName = _trimmedWithAudioFiles.elementAt(index).toString().split('/').last;
                    trimmedWithAudioFileName = trimmedWithAudioFileName.substring(0,trimmedWithAudioFileName.length-1);
                    print(trimmedWithAudioFileName); //image_picker1454177772836198879_trimmed:Aug28,2020-14:57:45.mp4

                    File trimmedWithAudioFile = new File(trimmedWithAudioFilePath);




                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)
                      ),
                      shadowColor: Colors.deepPurpleAccent,
                      color: Colors.deepPurple,
                        elevation: 15.0,
                        child:ListTile(
                          title: Text(trimmedWithAudioFileName),
                          leading: Icon(Icons.video_library_rounded,color: Colors.black,size: 40),
                            trailing: PopupMenuButton(icon: Icon(Icons.more_vert,color: Colors.black),
                              offset: Offset(0,100),//set offset to change the position of menu
                              itemBuilder: (BuildContext context) {
                              return items.map((Icon e){
                                return PopupMenuItem(child: Center(child: e,),value: e.semanticLabel,);
                              }).toList();
                            },
                            onSelected: (value)async{
                              SnackBar snackBar = new SnackBar(content: Text('Video deleted successfully!'));

                              switch(value) {
                                //Delete
                                case 'delete':
                                  assert (trimmedWithAudioFile!=null);
                                  await trimmedWithAudioFile.delete().then((value){
                                    _listFiles();
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
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>FileInfo(trimmedWithAudioFile)));
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
                  )
          ),
          Text('Trimmed videos',style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold)
          ),
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  //shrinkWrap: true,
                  itemCount: _trimmedVideoFiles.length,
                  itemBuilder: (BuildContext context,int index) {
                    String trimmedVideoFilePath = _trimmedVideoFiles.elementAt(index).toString().substring(7,_trimmedVideoFiles.elementAt(index).toString().length-1);
                    print(trimmedVideoFilePath);// /storage/emulated/0/Android/data/com.example.video_editor_app/files/Trimmer/image_picker1454177772836198879_trimmed:Aug28,2020-14:57:45.mp4
                    String trimmedVideoFileName = _trimmedVideoFiles.elementAt(index).toString().split('/').last;
                    trimmedVideoFileName = trimmedVideoFileName.substring(0,trimmedVideoFileName.length-1);
                    print(trimmedVideoFileName); //image_picker1454177772836198879_trimmed:Aug28,2020-14:57:45.mp4

                    File trimmedVideoFile = new File(trimmedVideoFilePath);


                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)
                      ),
                      shadowColor: Colors.deepPurpleAccent,
                      color: Colors.deepPurple,
                      elevation: 15.0,
                      child: ListTile(
                        title: Text(trimmedVideoFileName),
                        leading: Icon(Icons.video_library_rounded,size: 40,color: Colors.black),
                        trailing: PopupMenuButton(icon: Icon(CupertinoIcons.ellipsis,color: Colors.black),
                          offset: Offset(0,100),//set offset to change the position of menu
                          itemBuilder: (BuildContext context) {
                            return items.map((Icon e){
                              return PopupMenuItem(child: Center(child: e,),value: e.semanticLabel,);
                            }).toList();
                          },
                          onSelected: (value) async{
                            switch(value){
                              case 'delete':
                                await trimmedVideoFile?.delete()?.then((value){
                                  _listFiles();
                                  final snackBar = SnackBar(content: Text('Video deleted successfully!'));
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
                              //TODO: Get file information in alert box
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>FileInfo(trimmedVideoFile)));

                                break;











                              /*showDialog(context: context,
                                builder: (BuildContext context){

                                return AlertDialog(title: Container(width: MediaQuery.of(context).size.width,
                                child: Icon(Icons.video_library_sharp,color: Colors.black,size: 50,),
                                ),backgroundColor: Colors.deepPurpleAccent,
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.start,children: [
                                      Text('Name: ',style: TextStyle(color: Colors.black)),
                                      RichText(text: TextSpan(text:'$trimmedVideoFileName',style: TextStyle(color: Colors.black),
                                      ),softWrap: true,
                                      )
                                    ]),
                                    SizedBox(width: MediaQuery.of(context).size.width,height: 10,),
                                    Row(mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text('Location: ',style: TextStyle(color: Colors.black)),
                                        Text('$trimmedVideoFilePath',style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black,fontSize: 10))
                                      ],
                                    )
                                  ]),
                                  actions: [
                                  FlatButton(onPressed: (){
                                    Navigator.of(context).pop();
                                    }, child: Text('OK',style: TextStyle(color: Colors.black),))
                                ],
                                );
                                }
                              );*/

                              

                            }
                          },),
                      onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoPlayer(trimmedVideoFilePath)));
                      }),
                    );
                  })
          ),
        ],
      )

    ),
      onRefresh: ()=>_listFiles(),
    );
  }
}

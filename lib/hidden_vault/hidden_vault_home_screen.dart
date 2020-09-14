import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editor_app/video/video_player.dart';

class HiddenVault extends StatefulWidget {
  @override
  _HiddenVaultState createState() => _HiddenVaultState();
}

class _HiddenVaultState extends State<HiddenVault> {

  List<FileSystemEntity> _vaultFiles = new List();
  _getFiles() async{
    String appDocsDir = (await getApplicationDocumentsDirectory()).path;
    if(Directory(appDocsDir+'/.vault').existsSync()){
      setState(() {
        _vaultFiles = Directory(appDocsDir+'/.vault/').listSync();
      });
    }
  }
  
  @override
  void initState(){
    _getFiles();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _vaultFiles.isEmpty?Center(child: Text('Wow! Such empty'),)
          :Container(
        child: ListView.builder(
          itemCount: _vaultFiles.length,
            itemBuilder: (BuildContext context, int index) {
              String vaultFilePath = _vaultFiles.elementAt(index).toString().substring(7,_vaultFiles.elementAt(index).toString().length-1);
              String vaultFileName = _vaultFiles.elementAt(index).toString().split('/').last;
              vaultFileName = vaultFileName.substring(0,vaultFileName.length-1);
              return ListTile(
                leading: Icon(Icons.video_library_rounded,size: 40,color: Colors.black),//TODO: check file type then set icon
                title: Text(vaultFileName),
                trailing: IconButton(icon: Icon(Icons.remove_red_eye,color: Colors.black,),
                    onPressed: () async{

                  File currentFile = new File(_vaultFiles.elementAt(index).path);

                  await getExternalStorageDirectory().then((value){
                    if (!((Directory(value.path+'/vaultFiles')).existsSync())){
                      Directory(value.path+'/vaultFiles').create();
                      print("directory created");
                    }

                    currentFile.copy('${value.path}/vaultFiles/$vaultFileName')
                        .then((value)async{
                      print(value.path);
                      await currentFile.delete().then((value){
                        print(value.path);
                        print('File deleted');
                        Scaffold.of(context).showSnackBar(new SnackBar(content: Text('Unhide Successfully')));
                        setState(() {
                          _getFiles();
                        });
                      });
                    });
                  });

                  }),
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>VideoPlayer(vaultFilePath)));
                  //TODO: check the file type then associate certain actions
                },
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Hide Files',
        child: Icon(Icons.add_circle_outline_outlined,color: Colors.black,),
        onPressed: () async{
          List<File> files = await FilePicker.getMultiFile(type: FileType.video);

          //TODO: Add for other file format support also
          if(files != null){
            await getApplicationDocumentsDirectory().then( (value){
              if (!((Directory(value.path+'/.vault')).existsSync())){
                Directory(value.path+'/.vault').create();
                print("directory created");
              }
              for(File file in files){
                file.copy(value.path+'/.vault/'+file.path.split('/').last).then((value) {
                  print(value.path);
                  setState(() {
                    _getFiles();
                  });
                });

              }}
              );

            showDialog(context: context,builder: (BuildContext context){
              return AlertDialog(title: Text('Information'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  content: Text('Files Added Successfully!'));
            });
          }
          else{
            showDialog(context: context,builder: (BuildContext context){
              return AlertDialog(title: Text('Error'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  content: Text('No Files Selected!'));
            });
          }



        }),
    );
  }
}

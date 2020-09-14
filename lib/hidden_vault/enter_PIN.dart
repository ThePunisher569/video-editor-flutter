import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_editor_app/hidden_vault/create_PIN.dart';

import 'hidden_vault_home_screen.dart';

class EnterPIN extends StatefulWidget {
  @override
  _EnterPINState createState() => _EnterPINState();
}

class _EnterPINState extends State<EnterPIN> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 180,),
            Icon(Icons.lock_outline,size: 120,),
            SizedBox(height: 30,),
            Text('Enter PIN',style: TextStyle(fontSize: 20),),
            SizedBox(height: 60,),
            PinEntryTextField(
              isTextObscure: true,
              showFieldAsBox: true,
              onSubmit: (String pin)async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                if (pin == prefs.getString('PIN')){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HiddenVault()));
                }
                else{
                  showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(title: Text('Error'),
                        content: Text('Wrong PIN entered!'));
                  });

                }

              },
            ),
            SizedBox(height: 20,),
            TextButton(
                child: Text('Did you forget your PIN?',),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CreatePIN()));
                }
                )
          ],
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

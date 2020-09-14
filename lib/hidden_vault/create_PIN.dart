import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:video_editor_app/hidden_vault/confirm_PIN.dart';

class CreatePIN extends StatefulWidget {
  @override
  _CreatePINState createState() => _CreatePINState();
}

class _CreatePINState extends State<CreatePIN> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 200,),
              Icon(Icons.lock_outline,size: 120,),
              SizedBox(height: 30,),
              Text('Create PIN',style: TextStyle(fontSize: 20),),
              SizedBox(height: 60,),
              PinEntryTextField(
                isTextObscure: true,
                showFieldAsBox: true,
                onSubmit: (String pin){

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context)=>ConfirmPIN(pin))
                  );
                },
              ),
            ],
          ),
        )
    );
  }
}


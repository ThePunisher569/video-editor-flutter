import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmPIN extends StatefulWidget {
  final String pin;
  ConfirmPIN(this.pin);
  @override
  _ConfirmPINState createState() => _ConfirmPINState();
}

class _ConfirmPINState extends State<ConfirmPIN> {
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
              Text('Confirm your PIN',style: TextStyle(fontSize: 20),),
              SizedBox(height: 60,),
              PinEntryTextField(
                isTextObscure: true,
                showFieldAsBox: true,
                onSubmit: (String pin) async{
                  if(pin == widget.pin){
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isPINCreated', true);
                    await prefs.setString('PIN', pin).then((value) => print('pin created'));
                    Navigator.pop(context);
                  }
                  else{
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(title: Text('Error'),
                        content: Text('PIN does not match!'));
                    });

                  }

                },
              ),
            ],
          ),
        )
    );
  }
}


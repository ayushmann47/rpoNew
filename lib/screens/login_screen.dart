import 'dart:js';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/home_screen.dart';

enum mobileVeriState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  mobileVeriState currentState = mobileVeriState.SHOW_MOBILE_FORM_STATE;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
String verificationId;
final GlobalKey<ScaffoldState> _scaffold = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
 key: _scaffold ,
      body: Container(
        child: currentState == mobileVeriState.SHOW_MOBILE_FORM_STATE ?
        getMobileformwidget(context) :
        getOTPformWidget(context),
        padding: const EdgeInsets.all(16),
      )

    );
  }

  getMobileformwidget(context) {
    return Column(

        children: [

          Spacer(),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              hintText: "phoneNumber"
            ),
          )
          ,

          SizedBox(height: 16,),

          FlatButton(onPressed: ()async{ {

          }

            _auth.verifyPhoneNumber(phoneNumber: phoneController.text,
                verificationCompleted: (phoneAuthCredential) async{
  signInWithPhoneAuthCredential(phoneAuthCredential);
                },
                verificationFailed: (verificationFailed) async{
_scaffold.currentState.showSnackBar(SnackBar(content: Text(verificationFailed.message)));
                },
                codeSent: (verificationId,resendingToken) async{

              setState(() {
                currentState = mobileVeriState.SHOW_OTP_FORM_STATE;
                this.verificationId = verificationId;
              });

                },
                codeAutoRetrievalTimeout: (verificationId) async{

                },
                );
          }, child: Text("Send"),
          color: Colors.blue,
          textColor: Colors.white,),
          Spacer(),
        ]



    );






  }

  getOTPformWidget( context)

  {
    return Column(

        children: [

          Spacer(),
          TextField(
            controller: otpController,
            decoration: InputDecoration(
                hintText: "enter OTP"
            ),
          )
          ,

          SizedBox(height: 16,),

          FlatButton(onPressed: () async {
            PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: null, smsCode: otpController.text);



                signInWithPhoneAuthCredential(phoneAuthCredential);
          }, child: Text("verify"),
            color: Colors.blue,
            textColor: Colors.white,),
          Spacer(),
        ]



    );

  }

  void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async {

    try {
      final authCrededntial = await _auth.signInWithCredential(
          phoneAuthCredential);
      if (authCrededntial?.user != null) {

     //

      }

  
} on FirebaseAuthException catch(e) {
_scaffold.currentState.showSnackBar(SnackBar(content: Text(e.message)));
}

  }
}

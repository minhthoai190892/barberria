
import 'package:barberria/cloud_firestore/user_ref.dart';
import 'package:barberria/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends ConsumerWidget{
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(0xFFDFDFDF),
          body: SingleChildScrollView(
            child: Column(
              children: [
                //User Profile
                FutureBuilder(
                      //lay tu file user_ref
                future: getUserProfiles(FirebaseAuth.instance.currentUser.phoneNumber),
                builder: (context,snapshot){
                  if(snapshot.connectionState ==ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }else{
                    //background
                    var userModel = snapshot.data as UserModel;
                    return Container(
                      decoration: BoxDecoration(color: Color(0xFF383838)),
                      padding: const EdgeInsets.all(16),

                      child: Row(
                        children: [
                          //Button account
                          CircleAvatar(
                            child: Icon(Icons.person,color: Colors.white,size: 30,),
                            backgroundColor: Colors.black,
                            maxRadius: 30,
                          ),
                          SizedBox(width: 30,),
                          Expanded(child: Column(
                            children: [
                              Text('${userModel.name}',
                                style:
                                GoogleFonts.robotoMono(fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text('${userModel.address}',
                                overflow: TextOverflow.ellipsis,
                                style:
                                GoogleFonts.robotoMono(fontSize: 18,
                                  color: Colors.white,),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ))
                        ],
                      ),
                    );
                  }
                })
              ],

          ),
        )
      )
    );
  }
  
}
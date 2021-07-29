
import 'package:barberria/screens/booking_screen.dart';
import 'package:barberria/screens/home_screen.dart';
import 'package:barberria/state/state_managerment.dart';
import 'package:barberria/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase
  Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // định tuyến
      onGenerateRoute: (settings){
        switch(settings.name){
          case '/home':
            return PageTransition(
                settings: settings,
                child: Homepage(),
                type: PageTransitionType.fade
            );
            break;
          case '/booking':
            return PageTransition(
                settings: settings,
                child: BookingScreen(),
                type: PageTransitionType.fade
            );
            break;


          default:return null;
        }
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key,  this.title}) : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

class MyHomePage extends ConsumerWidget {// trang dang nhap
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // TODO: implement build
    return SafeArea(child: Scaffold(
      key: scaffoldState,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/my_bg.png'),fit: BoxFit.cover
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder(
                  future: checkLoginState(context,false,scaffoldState),
                  builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }else{
                      var userState = snapshot.data as LOGIN_STATE;
                      if(userState == LOGIN_STATE.LOGGED){
                        return Container();
                      }else{
                        return ElevatedButton.icon(onPressed: () => processLogin(context), icon: Icon(Icons.phone),
                          label: Text("LOGIN WITH PHONE"),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.black)
                          ),
                        );
                      }
                    }
                  },

                )
            )
          ],
        ),
      ),

    ));
  }






  processLogin(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    if(user == null)//user not login, show login
        {
      FirebaseAuthUi.instance()
          .launchAuth([AuthProvider.phone()
      ]).then((firebaseUser) async{
        //refesh state
        context.read(userLogged).state = FirebaseAuth.instance.currentUser;
        //Start new screen


        //token
        await checkLoginState(context,true,scaffoldState);
        //hiện thông tin đăng nhập bằng số điện thoại
        ScaffoldMessenger.of(scaffoldState.currentContext)
            .showSnackBar(SnackBar(content: Text('Login Success ${FirebaseAuth.instance.currentUser.phoneNumber}')));

      }).catchError((e){
        if(e is PlatformException){
          if(e.code == FirebaseAuthUi.kUserCancelledError)
          {
            ScaffoldMessenger.of(scaffoldState.currentContext)
                .showSnackBar(SnackBar(content: Text('${e.message}')));
          }
          else{
            ScaffoldMessenger.of(scaffoldState.currentContext)
                .showSnackBar(SnackBar(content: Text('Unk error')));
          }
        }
      });
    }
    else{//user already login, start home page

    }
  }

  Future<LOGIN_STATE> checkLoginState(BuildContext context,bool fromLogin,GlobalKey<ScaffoldState> scaffoldState) async{
    if(!context.read(forceReload).state){
      await Future.delayed(Duration(seconds: fromLogin == true ? 0 : 3)).then((value)=>{
        FirebaseAuth.instance.currentUser.getIdToken().then((token) async{
          // if get token, we print it
          print('$token');
          context.read(userToken).state = token;
          //check user in Firebase
          CollectionReference userRef = FirebaseFirestore.instance.collection('User');
          DocumentSnapshot snapshotUser = await userRef
              .doc(FirebaseAuth.instance.currentUser.phoneNumber)
              .get();
          //force reload state
          context.read(forceReload).state = true;
          if(snapshotUser.exists){
            //and because uer already login, we will start new screen
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }else{
            //if user info doesn't available, show dialog
            //thong tin nguoi dung
            var nameController = TextEditingController();
            var addController = TextEditingController();
            Alert(
                context: context,
                title: "UPDATE PROFILES",
                //noi dung nhap thong tin
                content: Column(
                  children: [
                    //input field
                    TextField(decoration: InputDecoration(
                        icon: Icon(Icons.account_circle),
                        labelText: 'Name'
                    ),controller: nameController,),
                    TextField(decoration: InputDecoration(
                        icon: Icon(Icons.home),
                        labelText: 'Address'
                    ),controller: addController,)
                  ],
                ),
                //button
                buttons: [
                  DialogButton(child: Text("CANCEL"), onPressed: ()=>Navigator.pop(context)),
                  DialogButton(child: Text("UPDATE"), onPressed: (){
                    //update to server
                    userRef.doc(FirebaseAuth.instance.currentUser.phoneNumber)
                        .set({
                      'name':nameController.text,
                      'address':addController.text
                    }).then((value) async{
                      Navigator.pop(context);
                      //in thông báo
                      ScaffoldMessenger.of(scaffoldState.currentContext)
                          .showSnackBar(SnackBar(content: Text('UPDATE PROFILES SUCCESSFULLY')));
                      await Future.delayed(Duration(seconds: 1),(){
                        //and because uer already login, we will start new screen
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      });

                    }).catchError((e){
                      Navigator.pop(context);
                      //in thông báo
                      ScaffoldMessenger.of(scaffoldState.currentContext)
                          .showSnackBar(SnackBar(content: Text('$e')));
                    });
                  })
                ]
            ).show();
          }


        })
      });
    }

    return FirebaseAuth.instance.currentUser !=null?LOGIN_STATE.LOGGED:LOGIN_STATE.NOT_LOGIN;
  }
}

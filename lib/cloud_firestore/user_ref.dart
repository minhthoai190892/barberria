
import 'package:barberria/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<UserModel> getUserProfiles(String phone) async{
  CollectionReference userRef = FirebaseFirestore.instance.collection('User');
  DocumentSnapshot snapshotUser = await userRef
      .doc(phone)
      .get();
  if(snapshotUser.exists){
    var userModel = UserModel.fromJson(snapshotUser.data());
    return userModel;
  }else{
    return UserModel();//empty object
  }
}
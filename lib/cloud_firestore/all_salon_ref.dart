


import 'package:barberria/model/city_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<CityModel>> getCities() async{
  var cites = new List<CityModel>.empty(growable: true);
  var cityRef = FirebaseFirestore.instance.collection("AllSalon");
  var snapshot = await cityRef.get();
  snapshot.docs.forEach((element) {
    cites.add(CityModel.fromJson(element.data()));
  });
  return cites;
}



import 'package:barberria/model/city_model.dart';
import 'package:barberria/model/salon_model.dart';
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

Future<List<SalonModel>> getSalonByCity(String cityName) async{
  var salons = new List<SalonModel>.empty(growable: true);
  //                                                 /AllSalon/Nhà Bè/Branch
  var salonRef = FirebaseFirestore.instance.collection("AllSalon").doc(cityName.replaceAll('', '')).collection("Branch");
  var snapshot = await salonRef.get();
  snapshot.docs.forEach((element) {
    salons.add(SalonModel.fromJson(element.data()));
  });
  return salons;
}
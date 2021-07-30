

import 'package:barberria/cloud_firestore/all_salon_ref.dart';
import 'package:barberria/model/city_model.dart';
import 'package:barberria/model/salon_model.dart';
import 'package:barberria/state/state_managerment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';

class BookingScreen extends ConsumerWidget{
  @override
  Widget build(BuildContext context,watch) {
    var step = watch(currentStep).state;
    var cityWatch = watch(selectedCity).state;
    var salonWatch = watch(selectedSalon).state;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,//bàn phím ảo không đè lên phần thân
        backgroundColor: Color(0xFFFCFBFB),
        body: Column(
          children: [
            //step
            NumberStepper(
              activeStep: step-1,
              direction: Axis.horizontal,
              enableNextPreviousButtons: false,
              enableStepTapping: false,
              numbers: [1,2,3,4,5],
              stepColor: Colors.black,
              activeStepColor: Colors.grey,
              numberStyle: TextStyle(color: Colors.white),
            ),
            //screen
            Expanded(
              child:
              step ==1
                  ? displayCityList()
              :step ==2
                  ?displaySalon(context.read(selectedCity).state)
                  :Container()
              ,
            ),
            //screen
            //button
            Expanded(
                child: Align(alignment: Alignment.bottomCenter,//canh giữa
                  //khung
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //button
                    children: [

                      Expanded(child: ElevatedButton(
                        onPressed: step == 1 ? null:()=>context.read(currentStep).state--,
                        child: Text('Previous'),

                      )),
                      SizedBox(width: 30,),
                      Expanded(child: ElevatedButton(
                          //that mean if first, user not check city, button Next be disable
                        onPressed:(step ==1 &&context.read(selectedCity).state=='')
                            ||(step ==2 &&context.read(selectedSalon).state=='')
                            ?null: step == 5 ? null:()=>context.read(currentStep).state++,

                        child: Text('Next'),

                      ))
                    ],//button

                  ),
                ),
                  //khung
                )
            ),
            //button
          ],
        ),
      )
    );
  }

  displayCityList() {

    return FutureBuilder(
        future: getCities(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return  Center(
              child: CircularProgressIndicator(),
            );
          }else{
            var cities = snapshot.data as List<CityModel>;
            if(cities == null || cities.length==0){
              return Center(child: Text("Can not load city list"),);
            }else{
              return ListView.builder(
                  itemCount: cities.length,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      onTap: ()=>context.read(selectedCity).state=cities[index].name,
                      child: Card(
                        child: ListTile(
                          leading: Icon(Icons.home_work,color: Colors.black,),
                          trailing: context.read(selectedCity).state==cities[index].name?Icon(Icons.check):null,
                          title: Text('${cities[index].name}',style: GoogleFonts.robotoMono(),),
                        ),
                      ),
                    );
                  });
            }
          }


    });
  }

  displaySalon(String cityName) {
    return FutureBuilder(
        future: getSalonByCity(cityName),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return  Center(
              child: CircularProgressIndicator(),
            );
          }else{
            var salons = snapshot.data as List<SalonModel>;
            if(salons == null || salons.length==0){
              return Center(child: Text("Can not load salon list"),);
            }else{
              return ListView.builder(
                  itemCount: salons.length,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      onTap: ()=>context.read(selectedSalon).state=salons[index].name,
                      child: Card(
                        child: ListTile(
                          leading: Icon(Icons.home_outlined,color: Colors.black,),
                          trailing: context.read(selectedSalon).state==salons[index].name?Icon(Icons.check):null,
                          title: Text('${salons[index].name}',style: GoogleFonts.robotoMono(),),
                          subtitle: Text('${salons[index].address}',style: GoogleFonts.robotoMono(fontStyle: FontStyle.italic),),
                        ),
                      ),
                    );
                  });
            }
          }


        });
  }
  //end display
}
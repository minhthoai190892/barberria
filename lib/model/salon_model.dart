
class SalonModel{
  String name,address;
  SalonModel({this.name,this.address});
  SalonModel.fromJson(Map<String,dynamic> json){
    address = json['address'];
    name = json['name'];
  }
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['name']=this.name;
    data['address']=this.address;
    return data;
  }
}
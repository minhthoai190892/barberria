
class ImageModel{
  String image;
  ImageModel({this.image});

  ImageModel.fromJson(Map<String,dynamic> json){
    image = json['image'];//tên field firebase

  }
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['image']=this.image;
    return data;
  }
}
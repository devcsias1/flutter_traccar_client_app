class UserModel{


String? id;
String? name;
String? email;
String? phone;
String? token;
double? latitide;
double? longitude;
int? tracar_id;
String? deviceId;

UserModel({
this.id,
this.name,
this.email,
this.phone,
this.token,
this.latitide,
this.longitude,
this.tracar_id,
this.deviceId,
});

factory UserModel.fromJson(dynamic json)=>UserModel(

name: json['name'],
email: json['email'],
phone: json['phone'],
token: json['token'],
latitide: json['latitude'],
longitude: json['longitude'],
tracar_id: json['id']

);

factory UserModel.fromFJson(dynamic json)=>UserModel(
id: json['id'],
name: json['name'],
email: json['email'],
phone: json['phone'],
token: json['token'],
latitide: json['latitude'],
longitude: json['longitude'],
tracar_id: json['tracar_id'],
deviceId:json['deviceId']

);
Map<String,dynamic> toJson()=>{

"id":tracar_id,
"name":name,
"email":email,
"phone":phone,

"latitude":latitide,
"longitude":longitude,

};
Map<String,dynamic> toFJson()=>{

"id":id,
"name":name,
"email":email,
"phone":phone,
"token":token,
"latitude":latitide,
"longitude":longitude,
"tracar_id":tracar_id,
"deviceId":deviceId


};
}

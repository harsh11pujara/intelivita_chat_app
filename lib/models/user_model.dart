
class UserModel{
  String? id;
  String? name;
  String? email;
  String? phone;
  String? fcmToken;

  UserModel({required this.id, required this.name, required this.email, this.phone, this.fcmToken});

  UserModel.fromJson(Map<String,dynamic> data){
    id = data["id"];
    email = data["email"];
    name = data["name"];
    phone = data["phone"];
    fcmToken = data.containsKey("fcmToken") ? data["fcmToken"] : "";
  }

  Map<String,dynamic> toMap() => {
    'id' : id,
    'name' : name,
    'email' : email,
    'phone' : phone,
    'fcmToken' : fcmToken
  };
}
class Data {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? avatar;
  String? domain;
  bool? available;

  Data(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.gender,
      this.avatar,
      this.domain,
      this.available});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    gender = json['gender'];
    avatar = json['avatar'];
    domain = json['domain'];
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['avatar'] = this.avatar;
    data['domain'] = this.domain;
    data['available'] = this.available;
    return data;
  }
}

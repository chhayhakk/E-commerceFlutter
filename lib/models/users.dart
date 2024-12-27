class Users {
  String columnId = 'id';
  String columnUsername = 'username';
  String columnPassword = 'password';
  String columnEmail = 'email';
  String columnPhone = 'phone';
  String columnAddress = 'address';
  String columnGender = 'gender';
  String columnProfile = 'profile';
  String columnStatus = 'isLoggedIn';

  int? id;
  String? username;
  String? password;
  String? email;
  String? phone;
  String? address;
  String? profile;
  String? gender;
  bool? status;

  Users(
      {this.id,
      this.username,
      this.password,
      this.email,
      this.phone,
      this.address,
      this.status,
      this.gender,
      this.profile});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      username: json['name'],
      password: json['password'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      status: json['status'],
      gender: json['gender'],
      profile: json['profile'],
    );
  }
}

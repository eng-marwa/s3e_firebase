class AppUser {
  final String displayName;
  final String email;
  final String phone;
  final String address;
  String? pic;

  AppUser(
      {required this.displayName,
      required this.email,
      required this.phone,
      required this.address,
      this.pic});

  Map<String, dynamic> toMap() {
    return {
      'displayName': this.displayName,
      'email': this.email,
      'phone': this.phone,
      'address': this.address,
      'pic': this.pic,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      displayName: map['displayName'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
      pic: map['pic'] as String?,
    );
  }
}

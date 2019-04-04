class ClientDetails {
  int id;
  String email;
  String role;
  String firstName;
  String lastName;
  String companyName;
  String address;
  String about;
  bool isLegalEntity;

  ClientDetails.fromJson(map) {
    id = map['id'];
    email = map['email'];
    role = map['role'];
    firstName = map['firstName'] ?? '';
    lastName = map['lastName'] ?? '';
    companyName = map['companyName'] ?? '';
    address = map['address'] ?? '';
    about = map['about'] ?? '';
    isLegalEntity = map['isLegalEntity'];
  }
}
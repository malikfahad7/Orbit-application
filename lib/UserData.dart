class UserData {
  static final UserData _instance = UserData._internal();
  String? email;
  String? username;
  String? floor;

  factory UserData() {
    return _instance;
  }

  UserData._internal();

  // Setters for the fields
  set setEmail(String emailValue) {
    email = emailValue;
  }

  set setUsername(String name) {
    username = name;
  }

  set setFloor(String floorNumber) {
    floor = floorNumber;
  }

  // Getters for the fields
  String? get getEmail => email;
  String? get getUsername => username;
  String? get getFloor => floor;
}

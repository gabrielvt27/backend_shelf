class UserParamsModel {
  String? id;
  String? name;
  String? email;
  String? role;
  String? password;

  UserParamsModel({
    this.id,
    this.name,
    this.email,
    this.role,
    this.password,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'email': email});
    result.addAll({'role': role});

    return result;
  }

  factory UserParamsModel.fromMap(Map<String, dynamic> map) {
    return UserParamsModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
    );
  }
}

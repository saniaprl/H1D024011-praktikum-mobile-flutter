class Login {
  int? code;
  bool? status;
  String? token;
  int? userID;
  String? userEmail;

  Login({
    this.code,
    this.status,
    this.token,
    this.userID,
    this.userEmail,
  });

  factory Login.fromJson(Map<String, dynamic> obj) {
    final data = obj['data'];
    final loginData = data is Map ? data : <String, dynamic>{};
    final userData = loginData['user'];
    final user = userData is Map ? userData : <String, dynamic>{};

    return Login(
      code: obj['code'],
      status: obj['status'],
      token: loginData['token']?.toString(),
      userID: int.tryParse(user['id']?.toString() ?? ''),
      userEmail: user['email']?.toString(),
    );
  }
}

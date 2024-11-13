class UserDefine {
  final String uid;  // Ubah id menjadi uid
  final String username;
  final String email;
  final String password;

  UserDefine({
    required this.uid,  // Gunakan uid sebagai field wajib
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,  // Masukkan uid ke dalam map
      'username': username,
      'email': email,
      'password': password,
    };
  }

  factory UserDefine.fromMap(Map<String, dynamic> map) {
    return UserDefine(
      uid: map['uid'],
      username: map['username'] ?? "Nama Pengguna",
      email: map['email'],
      password: map['password'],
    );
  }

  String toString() {
    return 'UserDefine(uid: $uid, username: $username, email: $email, password: $password)';
  }
}

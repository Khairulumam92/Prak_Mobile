class User {
  final int? id;
  final String nama;
  final String nim;
  final String alamat;
  final String noWa;
  final String email;

  User({
    this.id,
    required this.nama,
    required this.nim,
    required this.alamat,
    required this.noWa,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nim': nim,
      'alamat': alamat,
      'no_wa': noWa,
      'email': email,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      nama: map['nama'] as String,
      nim: map['nim'] as String,
      alamat: map['alamat'] as String,
      noWa: map['no_wa'] as String,
      email: map['email'] as String,
    );
  }
}

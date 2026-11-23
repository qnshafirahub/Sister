class AuthUser {
  final String nis;
  final String nama;
  final String kelas;
  final String sekolah;

  const AuthUser({
    required this.nis,
    required this.nama,
    required this.kelas,
    required this.sekolah,
  });

  Map<String, dynamic> toJson() =>
      {'nis': nis, 'nama': nama, 'kelas': kelas, 'sekolah': sekolah};

  factory AuthUser.fromJson(Map<String, dynamic> j) => AuthUser(
        nis: j['nis'] as String,
        nama: j['nama'] as String,
        kelas: j['kelas'] as String,
        sekolah: j['sekolah'] as String,
      );
}
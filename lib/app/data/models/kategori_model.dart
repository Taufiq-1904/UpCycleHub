// lib/app/data/models/kategori_model.dart
//
// Sesuai tabel `kategori` di upcycle_products:
//   id int PK, nama varchar(100), slug varchar(100), deskripsi text

class KategoriModel {
  final int id;
  final String nama;
  final String slug;
  final String? deskripsi;

  const KategoriModel({
    required this.id,
    required this.nama,
    required this.slug,
    this.deskripsi,
  });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      nama: json['nama']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      deskripsi: json['deskripsi']?.toString(),
    );
  }

  // Dipakai DropdownButtonFormField untuk compare value
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is KategoriModel && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => nama;
}

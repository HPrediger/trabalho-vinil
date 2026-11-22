
class Vinil {
  final int id;
  final String title;
  final String artistName;
  final String genreName;
  final int releaseYear;
  final double price;
  final String condition;
  final int rpmSpeed;
  final int stockQuantity;
  final String? coverUrl;

  Vinil({
    required this.id,
    required this.title,
    required this.artistName,
    required this.genreName,
    required this.releaseYear,
    required this.price,
    required this.condition,
    required this.rpmSpeed,
    required this.stockQuantity,
    this.coverUrl,
  });

  // Converte o JSON da API em um objeto Vinil
  factory Vinil.fromJson(Map<String, dynamic> json) {
    final artista = json['artist'];
    final genero = json['genre'];

    return Vinil(
      id: (json['id'] as num).toInt(),
      title: json['title'] ?? '',
      artistName: artista is Map
          ? artista['name']?.toString() ?? 'Não informado'
          : 'Não informado',
      genreName: genero is Map
          ? genero['name']?.toString() ?? 'Não informado'
          : 'Não informado',
      releaseYear: (json['releaseYear'] as num).toInt(),
      price: double.tryParse(json['price'].toString()) ?? 0,
      condition: json['condition'] ?? '',
      rpmSpeed: (json['rpmSpeed'] as num).toInt(),
      stockQuantity: (json['stockQuantity'] as num).toInt(),
      coverUrl: json['coverUrl']?.toString(),
    );
  }
}

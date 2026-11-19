
class CartItem {
  final int id;
  final String title;
  final double price;
  final String image;
  final double rate;
  final int count;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.rate,
    required this.count,
  });

  // Mengubah data menjadi Map agar bisa disimpan Hive
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
      'rate': rate,
      'count': count,
    };
  }

  // Mengubah Map menjadi objek CartItem
  factory CartItem.fromMap(Map<dynamic, dynamic> map) {
    return CartItem(
      id: map['id'] as int,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      image: map['image'] as String,
      rate: (map['rate'] as num).toDouble(),
      count: map['count'] as int,
    );
  }
}


import 'package:hive_flutter/hive_flutter.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartService {
  static const String boxName = 'cartBox';

  // Mengambil box Hive
  static Box get _box => Hive.box(boxName);

  // Menambahkan produk ke keranjang
  static Future<void> addToCart(Product product) async {
    final existingItem = _box.get(product.id.toString());

    // Mencegah produk yang sama ditambahkan berkali-kali
    if (existingItem != null) {
      return;
    }

    final item = CartItem(
      id: product.id,
      title: product.title,
      price: product.price,
      image: product.image,
      rate: product.rate,
      count: product.count,
    );

    await _box.put(
      product.id.toString(),
      item.toMap(),
    );
  }

  // Mengambil semua produk dalam keranjang
  static List<CartItem> getCartItems() {
    return _box.values.map((item) {
      return CartItem.fromMap(
        Map<dynamic, dynamic>.from(item),
      );
    }).toList();
  }

  // Menghapus produk dari keranjang
  static Future<void> removeFromCart(int id) async {
    await _box.delete(id.toString());
  }

  // Menghitung jumlah produk dalam keranjang
  static int getCartCount() {
    return _box.length;
  }
}


import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../services/cart_service.dart';
import 'product_detail_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    cartItems = CartService.getCartItems();
  }

  void _loadCart() {
    setState(() {
      cartItems = CartService.getCartItems();
    });
  }

  Future<void> _deleteItem(
    int id,
    String productName,
  ) async {
    await CartService.removeFromCart(id);

    if (!mounted) return;

    _loadCart();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Berhasil dihapus dari keranjang'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _openProductDetail(int id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          productId: id,
        ),
      ),
    );

    if (!mounted) return;

    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Saya'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: cartItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Keranjang masih kosong',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(
                      item.image,
                      width: 55,
                      height: 55,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image_not_supported,
                        );
                      },
                    ),

                    title: Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text('\$${item.price}'),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 16,
                            ),
                            Text(
                              '${item.rate} (${item.count})',
                            ),
                          ],
                        ),
                      ],
                    ),

                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _deleteItem(item.id, item.title);
                      },
                    ),

                    onTap: () {
                      _openProductDetail(item.id);
                    },
                  ),
                );
              },
            ),
    );
  }
}

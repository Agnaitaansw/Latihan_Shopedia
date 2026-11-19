
import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../services/cart_service.dart';
import 'cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailPage> createState() =>
      _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<Product> _productFuture;

  bool _isAddedToCart = false;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();

    _productFuture =
        ApiService.getProductDetail(widget.productId);

    _checkCart();
  }

  void _checkCart() {
    final items = CartService.getCartItems();

    _isAddedToCart =
        items.any((item) => item.id == widget.productId);
  }

  Future<void> _addToCart(Product product) async {
    if (_isAdding || _isAddedToCart) return;

    setState(() {
      _isAdding = true;
    });

    try {
      await CartService.addToCart(product);

      if (!mounted) return;

      setState(() {
        _isAddedToCart = true;
      });

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil dimasukkan ke keranjang'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menambahkan produk'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAdding = false;
        });
      }
    }
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CartPage(),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _checkCart();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: _openCart,
          ),
        ],
      ),

      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Gagal memuat detail produk'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _productFuture =
                            ApiService.getProductDetail(
                                widget.productId);
                      });
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    product.image,
                    height: 250,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 100,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  '\$${product.price}',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${product.rate} (${product.count} ulasan)',
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  'Deskripsi Produk',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  product.description,
                  style: const TextStyle(fontSize: 15),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isAdding || _isAddedToCart
                        ? null
                        : () => _addToCart(product),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                    ),
                    child: _isAdding
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            _isAddedToCart
                                ? 'Sudah di Keranjang'
                                : 'Tambah ke Keranjang',
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

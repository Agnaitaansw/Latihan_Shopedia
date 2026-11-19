
import 'package:flutter/material.dart';

// Mengimpor model Product untuk mengelola data produk
import '../models/product.dart';

// Mengimpor ApiService untuk mengambil data produk dari FakeStore API
import '../services/api_service.dart';

// Mengimpor halaman detail produk, keranjang, dan profil
import 'product_detail_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';


// ============================================================
// HOME PAGE
// ============================================================

// Membuat halaman utama aplikasi Shopedia
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  // ============================================================
  // VARIABEL STATE
  // ============================================================

  // Menyimpan index halaman yang sedang dipilih
  // 0 = Home
  // 1 = Profile
  int _selectedIndex = 0;

  // Menyimpan Future yang berisi daftar produk dari API
  // Future digunakan karena pengambilan data membutuhkan waktu
  late Future<List<Product>> _products;

  // Menyimpan kategori yang dipilih pengguna
  // null berarti seluruh kategori ditampilkan
  String? _selectedCategory;


  // ============================================================
  // INIT STATE
  // ============================================================

  @override
  void initState() {
    super.initState();

    // Mengambil daftar produk dari FakeStore API
    // Data disimpan ke dalam variabel _products
    _products = ApiService.getProducts();
  }


  // ============================================================
  // NAVIGASI BOTTOM NAVIGATION BAR
  // ============================================================

  // Mengatur perpindahan halaman berdasarkan index
  void _onItemTapped(int index) {

    // Memperbarui index halaman yang dipilih
    setState(() {
      _selectedIndex = index;
    });
  }


  // ============================================================
  // NAVIGASI HALAMAN KERANJANG
  // ============================================================

  // Membuka halaman CartPage ketika ikon keranjang ditekan
  Future<void> _openCart() async {

    // Berpindah ke halaman keranjang
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CartPage(),
      ),
    );

    // Memperbarui tampilan setelah kembali dari halaman keranjang
    if (mounted) {
      setState(() {});
    }
  }


  // ============================================================
  // NAVIGASI HALAMAN DETAIL PRODUK
  // ============================================================

  // Membuka halaman detail berdasarkan ID produk
  void _openProductDetail(int productId) {

    // Mengirimkan ID produk ke halaman ProductDetailPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          productId: productId,
        ),
      ),
    );
  }


  // ============================================================
  // FILTER KATEGORI PRODUK
  // ============================================================

  // Membuat menu filter berdasarkan kategori produk dari API
  Widget _buildCategoryFilter(List<Product> products) {

    // Mengambil kategori dari setiap produk
    // map() mengambil nilai category dari objek Product
    // toSet() menghilangkan kategori yang berulang
    // toList() mengubah hasilnya menjadi List
    final categories = products
        .map((product) => product.category)
        .toSet()
        .toList();

    // Mengurutkan kategori berdasarkan abjad
    categories.sort();

    // Menampilkan judul dan tombol filter kategori
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        // Judul menu filter
        const Text(
          'Filter Kategori',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 10),

        // Membuat daftar filter yang dapat digeser horizontal
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,

          child: Row(
            children: [

              // Menggabungkan pilihan Semua dengan daftar kategori API
              // null digunakan untuk mewakili pilihan Semua
              ...[
                null,
                ...categories,
              ].map((category) {

                // Memeriksa apakah kategori ini sedang dipilih
                final isSelected = _selectedCategory == category;

                // Memberikan jarak antar tombol filter
                return Padding(
                  padding: const EdgeInsets.only(right: 8),

                  // ChoiceChip digunakan sebagai tombol pilihan kategori
                  child: ChoiceChip(

                    // Menampilkan nama kategori
                    // Jika null, tampilkan tulisan Semua
                    label: Text(
                      category ?? 'Semua',
                    ),

                    // Menandai tombol yang sedang dipilih
                    selected: isSelected,

                    // Warna tombol ketika dipilih
                    selectedColor: Colors.blue,

                    // Warna tombol ketika tidak dipilih
                    backgroundColor: Colors.grey.shade200,

                    // Mengatur warna teks tombol
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),

                    // Menjalankan fungsi ketika tombol ditekan
                    onSelected: (_) {

                      // Menyimpan kategori yang dipilih pengguna
                      // setState memperbarui tampilan dan hasil filter
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              }),

            ],
          ),
        ),
      ],
    );
  }


  // ============================================================
  // BUILD UTAMA
  // ============================================================

  @override
  Widget build(BuildContext context) {

    // Scaffold merupakan kerangka utama halaman
    return Scaffold(

      // ------------------------------------------------------------
      // APP BAR
      // ------------------------------------------------------------

      appBar: AppBar(

        // Judul aplikasi
        title: const Text(
          'Shopedia',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        // Warna latar belakang AppBar
        backgroundColor: Colors.blue,

        // Warna teks dan ikon AppBar
        foregroundColor: Colors.white,

        // Tombol pada sisi kanan AppBar
        actions: [

          // Tombol untuk membuka halaman keranjang
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: _openCart,
          ),

          const SizedBox(width: 8),
        ],
      ),


      // ------------------------------------------------------------
      // BODY / ISI HALAMAN
      // ------------------------------------------------------------

      // Menampilkan Home atau Profile berdasarkan index
      body: _selectedIndex == 0
          ? _buildHome()
          : const ProfilePage(),


      // ------------------------------------------------------------
      // BOTTOM NAVIGATION BAR
      // ------------------------------------------------------------

      bottomNavigationBar: BottomNavigationBar(

        // Index halaman yang sedang aktif
        currentIndex: _selectedIndex,

        // Fungsi ketika menu navigasi ditekan
        onTap: _onItemTapped,

        // Warna menu yang sedang dipilih
        selectedItemColor: Colors.blue,

        // Warna menu yang tidak dipilih
        unselectedItemColor: Colors.grey,

        // Daftar menu navigasi
        items: const [

          // Menu Home
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          // Menu Profile
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),

        ],
      ),
    );
  }


  // ============================================================
  // MENAMPILKAN DAFTAR PRODUK
  // ============================================================

  Widget _buildHome() {

    // FutureBuilder digunakan untuk mengelola proses pengambilan data API
    return FutureBuilder<List<Product>>(

      // Future yang berisi daftar produk
      future: _products,

      builder: (context, snapshot) {

        // ------------------------------------------------------------
        // KONDISI 1: LOADING
        // ------------------------------------------------------------

        // Menampilkan loading ketika data masih diambil dari API
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }


        // ------------------------------------------------------------
        // KONDISI 2: ERROR
        // ------------------------------------------------------------

        // Menampilkan pesan jika terjadi kesalahan saat mengambil data
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                // Ikon kesalahan
                const Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.red,
                ),

                const SizedBox(height: 10),

                // Menampilkan detail kesalahan
                Text(
                  'Terjadi kesalahan:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 15),

                // Tombol untuk mencoba mengambil data kembali
                ElevatedButton(

                  onPressed: () {

                    // Mengambil ulang data produk dari API
                    setState(() {
                      _products = ApiService.getProducts();
                    });
                  },

                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }


        // ------------------------------------------------------------
        // KONDISI 3: DATA KOSONG
        // ------------------------------------------------------------

        // Memeriksa apakah data produk tersedia
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Produk tidak ditemukan'),
          );
        }


        // ------------------------------------------------------------
        // MENGAMBIL DATA PRODUK
        // ------------------------------------------------------------

        // Menyimpan seluruh produk yang berhasil diambil dari API
        final products = snapshot.data!;


        // ------------------------------------------------------------
        // LOGIKA FILTER KATEGORI
        // ------------------------------------------------------------

        // Jika tidak ada kategori yang dipilih,
        // tampilkan seluruh produk
        //
        // Jika ada kategori yang dipilih,
        // tampilkan hanya produk dengan kategori yang sesuai
        final filteredProducts = _selectedCategory == null
            ? products
            : products.where((product) {

                // Membandingkan kategori produk dengan kategori pilihan pengguna
                return product.category == _selectedCategory;

              }).toList();


        // ------------------------------------------------------------
        // TAMPILAN HOME DAN GRID PRODUK
        // ------------------------------------------------------------

        return Padding(
          padding: const EdgeInsets.all(10),

          // Column menyusun filter, jumlah produk, dan GridView secara vertikal
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // Menampilkan menu filter kategori
              // Daftar kategori diambil dari produk API
              _buildCategoryFilter(products),

              const SizedBox(height: 12),


              // ------------------------------------------------------------
              // INFORMASI JUMLAH PRODUK
              // ------------------------------------------------------------

              // Menampilkan jumlah produk setelah proses filter
              Text(
                '${filteredProducts.length} produk ditemukan',

                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 8),


              // ------------------------------------------------------------
              // GRID PRODUK
              // ------------------------------------------------------------

              // Expanded memberikan ruang yang tersisa untuk GridView
              Expanded(

                // Memeriksa apakah hasil filter memiliki produk
                child: filteredProducts.isEmpty

                    // Menampilkan pesan jika tidak ada produk pada kategori tersebut
                    ? const Center(
                        child: Text(
                          'Tidak ada produk dalam kategori ini',
                          textAlign: TextAlign.center,
                        ),
                      )

                    // Menampilkan produk dalam bentuk grid
                    : GridView.builder(

                        // Jumlah item mengikuti hasil filter
                        itemCount: filteredProducts.length,

                        // Pengaturan tata letak GridView
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(

                          // Dua produk dalam satu baris
                          crossAxisCount: 2,

                          // Jarak horizontal antarproduk
                          crossAxisSpacing: 10,

                          // Jarak vertikal antarproduk
                          mainAxisSpacing: 10,

                          // Perbandingan lebar dan tinggi kartu
                          childAspectRatio: 0.65,
                        ),

                        // Membuat setiap kartu produk
                        itemBuilder: (context, index) {

                          // Mengambil produk berdasarkan index dari hasil filter
                          final product = filteredProducts[index];

                          // GestureDetector memungkinkan kartu produk ditekan
                          return GestureDetector(

                            // Membuka halaman detail ketika produk ditekan
                            onTap: () {
                              _openProductDetail(product.id);
                            },

                            child: Card(

                              // Bayangan kartu produk
                              elevation: 3,

                              // Memotong konten agar sesuai batas kartu
                              clipBehavior: Clip.antiAlias,

                              // Jarak konten dari tepi kartu
                              child: Padding(
                                padding: const EdgeInsets.all(8),

                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [

                                    // ------------------------------------------------
                                    // GAMBAR PRODUK
                                    // ------------------------------------------------

                                    // Menampilkan gambar produk dari URL API
                                    Expanded(
                                      child: Center(
                                        child: Image.network(
                                          product.image,

                                          // Menyesuaikan gambar agar tidak terpotong
                                          fit: BoxFit.contain,

                                          // Menampilkan ikon jika gambar gagal dimuat
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                              color: Colors.grey,
                                            );
                                          },
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 8),


                                    // ------------------------------------------------
                                    // NAMA PRODUK
                                    // ------------------------------------------------

                                    Text(
                                      product.title,

                                      // Maksimal dua baris untuk nama produk
                                      maxLines: 2,

                                      // Memotong teks jika terlalu panjang
                                      overflow: TextOverflow.ellipsis,

                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 5),


                                    // ------------------------------------------------
                                    // HARGA PRODUK
                                    // ------------------------------------------------

                                    // Menampilkan harga produk dengan dua angka desimal
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',

                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),

                                    const SizedBox(height: 5),


                                    // ------------------------------------------------
                                    // RATING DAN JUMLAH ULASAN
                                    // ------------------------------------------------

                                    Row(
                                      children: [

                                        // Ikon bintang rating
                                        const Icon(
                                          Icons.star,
                                          color: Colors.orange,
                                          size: 18,
                                        ),

                                        const SizedBox(width: 4),

                                        // Menampilkan rating dan jumlah ulasan
                                        Expanded(
                                          child: Text(
                                            '${product.rate} (${product.count})',

                                            // Mencegah teks keluar dari kartu
                                            overflow: TextOverflow.ellipsis,

                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),

            ],
          ),
        );
      },
    );
  }
}

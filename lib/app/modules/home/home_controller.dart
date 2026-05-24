import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/models/kategori_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/providers/api_client.dart';

class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxBool isLoading = false.obs;
  final RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  final RxList<ProductModel> latestProducts = <ProductModel>[].obs;
  final RxList<ProductModel> popularProducts = <ProductModel>[].obs;

  // ✅ Ganti String → KategoriModel supaya punya id & nama
  // Di view, tampilkan dengan kategori.nama
  // Saat filter produk, kirim kategori.slug atau kategori.id
  final RxList<KategoriModel> categories = <KategoriModel>[].obs;

  // Kategori yang sedang dipilih untuk filter (null = semua)
  final Rxn<KategoriModel> selectedCategory = Rxn<KategoriModel>();

  late final ProductRepository _productRepo;

  final List<Map<String, String>> banners = [
    {
      'title': 'Belanja Produk Upcycle',
      'subtitle': 'Temukan produk daur ulang berkualitas',
      'color': '#2D6A4F',
    },
    {
      'title': 'Jual Kreasi Upcycle-mu',
      'subtitle': 'Daftarkan produkmu sekarang',
      'color': '#52B788',
    },
    {
      'title': 'Gratis Ongkir Hari Ini!',
      'subtitle': 'Minimum belanja Rp 150.000',
      'color': '#1B4332',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _productRepo = ProductRepository(ApiClient());
    loadData();
  }

  void changePage(int index) => currentIndex.value = index;

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _loadCategories(),
        _loadFeaturedProducts(),
        _loadLatestProducts(),
        _loadPopularProducts(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCategories() async {
    // getCategories() sekarang return List<KategoriModel>
    categories.value = await _productRepo.getCategories();
  }

  // Filter produk berdasarkan kategori yang dipilih
  void selectCategory(KategoriModel? kategori) {
    selectedCategory.value = kategori;
    _loadFeaturedProducts(kategori: kategori);
  }

  Future<void> _loadFeaturedProducts({KategoriModel? kategori}) async {
    final products = await _productRepo.getProducts(
      limit: 6,
      // Kirim slug ke query param — backend pakai slug sebagai identifier kategori
      category: kategori?.slug,
    );
    featuredProducts.value = products;
  }

  Future<void> _loadLatestProducts() async {
    final products = await _productRepo.getProducts(sort: 'newest', limit: 6);
    latestProducts.value = products;
  }

  Future<void> _loadPopularProducts() async {
    final products = await _productRepo.getProducts(sort: 'popular', limit: 6);
    popularProducts.value = products;
  }
}

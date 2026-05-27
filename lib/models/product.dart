class ZProduct {
  final String id;
  final String name;
  final String brand;
  final String category;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final List<String> images;
  final List<String> sizes;
  final List<String> colors;
  final double rating;
  final int reviewCount;
  final String description;
  final bool isNew;
  final bool isFeatured;

  const ZProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.images,
    required this.sizes,
    required this.colors,
    required this.rating,
    required this.reviewCount,
    required this.description,
    this.isNew = false,
    this.isFeatured = false,
  });

  factory ZProduct.fromFirestore(Map<String, dynamic> map, String id) {
    return ZProduct(
      id: id,
      name: map['name'] as String? ?? '',
      brand: map['brand'] as String? ?? '',
      category: map['category'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (map['originalPrice'] as num?)?.toDouble(),
      imageUrl: map['imageUrl'] as String? ?? '',
      images: (map['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      sizes: (map['sizes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      colors: (map['colors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (map['reviewCount'] as int?) ?? 0,
      description: map['description'] as String? ?? '',
      isNew: map['isNew'] as bool? ?? false,
      isFeatured: map['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brand': brand,
      'category': category,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'images': images,
      'sizes': sizes,
      'colors': colors,
      'rating': rating,
      'reviewCount': reviewCount,
      'description': description,
      'isNew': isNew,
      'isFeatured': isFeatured,
    };
  }
}

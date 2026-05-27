import '../models/product.dart';
import '../models/category.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/review.dart';
import '../models/user.dart';
import '../models/address.dart';
import '../models/promo_banner.dart';
import '../config/app_theme.dart';

class MockData {
  // --- USER ---
  static const currentUser = ZUser(
    id: 'U-001',
    name: 'Sarah Perera',
    email: 'sarah.perera@example.com',
    phone: '+94 77 123 4567',
    avatarInitials: 'SP',
  );

  // --- ADDRESSES ---
  static const addresses = [
    ZAddress(
      id: 'ADDR-001',
      label: 'Home',
      fullName: 'Sarah Perera',
      line1: '123/A Galle Road, Kollupitiya',
      city: 'Colombo 03',
      postalCode: '00300',
      phone: '+94 77 123 4567',
      isDefault: true,
    ),
    ZAddress(
      id: 'ADDR-002',
      label: 'Office',
      fullName: 'Sarah Perera',
      line1: 'World Trade Center, Echelon Square',
      city: 'Colombo 01',
      postalCode: '00100',
      phone: '+94 77 123 4567',
      isDefault: false,
    ),
  ];

  // --- CATEGORIES ---
  static const categories = [
    ZCategory(id: 'c-all', label: 'All', icon: 'all'),
    ZCategory(id: 'c-women', label: 'Women', icon: 'women'),
    ZCategory(id: 'c-men', label: 'Men', icon: 'men'),
    ZCategory(id: 'c-acc', label: 'Accessories', icon: 'accessories'),
    ZCategory(id: 'c-sale', label: 'Sale', icon: 'sale'),
    ZCategory(id: 'c-new', label: 'New', icon: 'new'),
  ];

  // --- BANNERS ---
  static const banners = [
    ZPromoBanner(
      id: 'b-001',
      headline: 'Summer Collection',
      subline: 'Bright & breezy styles for the season.',
      ctaLabel: 'Shop Now',
      imageUrl:
          'https://images.unsplash.com/photo-1523381294911-8d3cead13475?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      bgColor: ZColors.primary,
    ),
    ZPromoBanner(
      id: 'b-002',
      headline: 'Minimalist Wardrobe',
      subline: 'Elevate your everyday look.',
      ctaLabel: 'Explore',
      imageUrl:
          'https://images.unsplash.com/photo-1434389678278-be43e4aa2187?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      bgColor: ZColors.accent,
    ),
  ];

  // --- REVIEWS ---
  static final sampleReviews = [
    ZReview(
      id: 'r-001',
      userName: 'Amandi W.',
      rating: 5.0,
      comment: 'Absolutely love the quality. Fits perfectly and looks elegant.',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ZReview(
      id: 'r-002',
      userName: 'Kavindu M.',
      rating: 4.5,
      comment: 'Very comfortable material. Shipping was fast as well.',
      date: DateTime.now().subtract(const Duration(days: 10)),
    ),
    ZReview(
      id: 'r-003',
      userName: 'Tanya R.',
      rating: 4.0,
      comment:
          'Great design, slightly darker color than in the pictures, but still lovely.',
      date: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  // --- PRODUCTS ---
  static const products = [
    ZProduct(
      id: 'p-001',
      name: 'Linen Blend Midi Dress',
      brand: 'Zuha Exclusive',
      category: 'Women',
      price: 8500.0,
      imageUrl:
          'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1595777457583-95e059d581b8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      sizes: ['S', 'M', 'L'],
      colors: ['Cream', 'Olive', 'Rust'],
      rating: 4.8,
      reviewCount: 124,
      description:
          'A breathable linen blend midi dress perfect for warm, tropical days. Features a flattering V-neck and a relaxed fit.',
      isNew: true,
      isFeatured: true,
    ),
    ZProduct(
      id: 'p-002',
      name: 'Classic Oxford Shirt',
      brand: 'Zuha Men',
      category: 'Men',
      price: 6500.0,
      imageUrl:
          'https://images.unsplash.com/photo-1596755094514-f87e32f85e2c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1596755094514-f87e32f85e2c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      sizes: ['M', 'L', 'XL'],
      colors: ['White', 'Light Blue'],
      rating: 4.6,
      reviewCount: 89,
      description:
          'A premium cotton oxford shirt tailored for a smart-casual look. Lightweight and durable.',
      isFeatured: true,
    ),
    ZProduct(
      id: 'p-003',
      name: 'Vegan Leather Tote Bag',
      brand: 'Zuha Accessories',
      category: 'Accessories',
      price: 12500.0,
      imageUrl:
          'https://images.unsplash.com/photo-1584916201218-f4242ceb4809?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1584916201218-f4242ceb4809?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1591561954557-26941169b49e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      sizes: ['One Size'],
      colors: ['Tan', 'Black'],
      rating: 4.9,
      reviewCount: 201,
      description:
          'Spacious everyday tote bag crafted from high-quality vegan leather. Includes an interior zip pocket for essentials.',
      isNew: true,
    ),
    ZProduct(
      id: 'p-004',
      name: 'Ribbed Knit Sweater',
      brand: 'Zuha Comfort',
      category: 'Women',
      price: 5900.0,
      originalPrice: 7500.0,
      imageUrl:
          'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1620799139507-2a76f79c2f4d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      sizes: ['S', 'M', 'L'],
      colors: ['Beige', 'Charcoal'],
      rating: 4.5,
      reviewCount: 45,
      description:
          'Cozy up in this soft ribbed knit sweater. Perfect for layering and transitioning between seasons.',
    ),
    ZProduct(
      id: 'p-005',
      name: 'Slim Fit Chinos',
      brand: 'Zuha Men',
      category: 'Men',
      price: 7200.0,
      imageUrl:
          'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1555689502-c4b22d76c56f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      sizes: ['30', '32', '34', '36'],
      colors: ['Navy', 'Khaki'],
      rating: 4.7,
      reviewCount: 112,
      description:
          'Versatile slim-fit chinos constructed with a hint of stretch for comfort all day long.',
    ),
    ZProduct(
      id: 'p-006',
      name: 'Layered Gold Necklace',
      brand: 'Zuha Fine',
      category: 'Accessories',
      price: 3500.0,
      imageUrl:
          'https://images.unsplash.com/photo-1599643478524-fb66f7ca065b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1599643478524-fb66f7ca065b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1599643477877-530eb83abc8e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      sizes: ['One Size'],
      colors: ['Gold'],
      rating: 4.8,
      reviewCount: 78,
      description:
          'A dainty layered necklace made of 18k gold-plated brass. Adds a subtle elegance to any outfit.',
      isNew: true,
      isFeatured: true,
    ),
    ZProduct(
      id: 'p-007',
      name: 'Pleated A-Line Skirt',
      brand: 'Zuha Exclusive',
      category: 'Women',
      price: 6800.0,
      imageUrl:
          'https://images.unsplash.com/photo-1582142306909-195724d33ffc?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1582142306909-195724d33ffc?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1582142407894-ec85a1260a46?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      sizes: ['XS', 'S', 'M', 'L'],
      colors: ['Forest Green', 'Black'],
      rating: 4.4,
      reviewCount: 34,
      description:
          'Elegant pleated midi skirt with an A-line silhouette. Easy to dress up or down.',
    ),
    ZProduct(
      id: 'p-008',
      name: 'Denim Trucker Jacket',
      brand: 'Zuha Essentials',
      category: 'Men',
      price: 9500.0,
      originalPrice: 11000.0,
      imageUrl:
          'https://images.unsplash.com/photo-1495105787522-5334e3ffa0e1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1495105787522-5334e3ffa0e1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1516257984-b1b4d707412e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Vintage Blue'],
      rating: 4.6,
      reviewCount: 92,
      description:
          'A timeless staple. This denim jacket is crafted from mid-weight cotton with classic metal hardware detailing.',
    ),
    ZProduct(
      id: 'p-009',
      name: 'Satin Slip Dress',
      brand: 'Zuha Evening',
      category: 'Women',
      price: 11500.0,
      imageUrl:
          'https://images.unsplash.com/photo-1539008835657-9e8e9680c956?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1539008835657-9e8e9680c956?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1596459344426-17b5f5cc1138?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      sizes: ['S', 'M', 'L'],
      colors: ['Champagne', 'Midnight Blue'],
      rating: 4.9,
      reviewCount: 65,
      description:
          'Luxurious silk-satin slip dress featuring a cowled neckline and adjustable spaghetti straps.',
      isFeatured: true,
    ),
    ZProduct(
      id: 'p-010',
      name: 'Cotton Basic Tee',
      brand: 'Zuha Essentials',
      category: 'Men',
      price: 2500.0,
      imageUrl:
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['White', 'Black', 'Grey'],
      rating: 4.5,
      reviewCount: 310,
      description:
          'The perfectly tailored everyday t-shirt made with 100% organic cotton jersey.',
    ),
    ZProduct(
      id: 'p-011',
      name: 'Cat-Eye Sunglasses',
      brand: 'Zuha Optix',
      category: 'Accessories',
      price: 4200.0,
      imageUrl:
          'https://images.unsplash.com/photo-1511499767150-a48a237f0083?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1511499767150-a48a237f0083?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1473496169904-658ba7c44d8a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      sizes: ['One Size'],
      colors: ['Tortoiseshell', 'Black'],
      rating: 4.7,
      reviewCount: 52,
      description:
          'Vintage-inspired cat-eye frame sunglasses with polarized UV400 lenses.',
      isNew: true,
    ),
    ZProduct(
      id: 'p-012',
      name: 'High-Rise Straight Jeans',
      brand: 'Zuha Denim',
      category: 'Women',
      price: 8900.0,
      imageUrl:
          'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1582552938357-32b906df40ff?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      sizes: ['26', '28', '30', '32'],
      colors: ['Light Wash', 'Black'],
      rating: 4.6,
      reviewCount: 176,
      description:
          'Flattering high-rise denim with a classic straight leg fit. Rigid look but with hidden stretch for comfort.',
      isFeatured: true,
    ),
  ];

  // --- ORDERS ---
  static final orders = [
    ZOrder(
      id: 'ZH-2025-001',
      date: DateTime.now().subtract(const Duration(days: 3)),
      items: [
        ZCartItem(
          product: products[0],
          selectedSize: 'S',
          selectedColor: 'Cream',
          quantity: 1,
        ),
        ZCartItem(
          product: products[2],
          selectedSize: 'One Size',
          selectedColor: 'Tan',
          quantity: 1,
        ),
      ],
      total: 21000.0,
      status: 'Delivered',
      estimatedDelivery:
          'Delivered on ${DateTime.now().subtract(const Duration(days: 1)).toString().split(' ')[0]}',
    ),
    ZOrder(
      id: 'ZH-2025-002',
      date: DateTime.now().subtract(const Duration(days: 1)),
      items: [
        ZCartItem(
          product: products[3],
          selectedSize: 'M',
          selectedColor: 'Beige',
          quantity: 1,
        ),
      ],
      total: 5900.0,
      status: 'Shipped',
      estimatedDelivery:
          'Expected by ${DateTime.now().add(const Duration(days: 2)).toString().split(' ')[0]}',
    ),
    ZOrder(
      id: 'ZH-2025-003',
      date: DateTime.now(),
      items: [
        ZCartItem(
          product: products[1],
          selectedSize: 'L',
          selectedColor: 'Light Blue',
          quantity: 2,
        ),
      ],
      total: 13000.0,
      status: 'Pending',
      estimatedDelivery:
          'Expected by ${DateTime.now().add(const Duration(days: 4)).toString().split(' ')[0]}',
    ),
  ];
}

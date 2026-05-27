import 'package:flutter/material.dart';

// Import all screens
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/product/product_detail_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/checkout/order_confirmation_screen.dart';
import '../screens/orders/order_history_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const explore = '/explore';
  static const search = '/search';
  static const product = '/product';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const confirmed = '/confirmed';
  static const orders = '/orders';
  static const profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    explore: (context) => const ExploreScreen(),
    search: (context) => const SearchScreen(),
    product: (context) =>
        const ProductDetailScreen(), // Pass args via ModalRoute in practice
    cart: (context) => const CartScreen(),
    checkout: (context) => const CheckoutScreen(),
    confirmed: (context) =>
        const OrderConfirmationScreen(), // Pass args via ModalRoute
    orders: (context) => const OrderHistoryScreen(),
    profile: (context) => const ProfileScreen(),
  };
}

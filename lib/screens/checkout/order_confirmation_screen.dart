import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'dart:math';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  final FirestoreService _firestoreService = FirestoreService();

  late final String _orderId;
  late final String _deliveryDate;

  @override
  void initState() {
    super.initState();
    final rand = Random();
    _orderId = 'ZH-${90000000 + rand.nextInt(9999999)}';
    final delivery = DateTime.now().add(const Duration(days: 5));
    _deliveryDate =
        '${_monthName(delivery.month)} ${delivery.day}, ${delivery.year}';

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _monthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthProvider>().currentUser?.id;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF9F5),
        body: Stack(
          children: [
            Positioned(
              bottom: -20,
              right: -40,
              child: IgnorePointer(
                child: Text(
                  'Zuha',
                  style: TextStyle(
                    fontFamily: 'DMSerifDisplay',
                    fontSize: 160,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF705347).withOpacity(0.04),
                    height: 1,
                  ),
                ),
              ),
            ),
            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 68)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Column(
                        children: [
                          ScaleTransition(
                            scale: _scaleAnim,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Color(0xFFC7E8CB),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF4C6952),
                                size: 44,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Order Placed!',
                            style: TextStyle(
                              fontFamily: 'DMSerifDisplay',
                              fontSize: 36,
                              color: Color(0xFF705347),
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Your order is being prepared with care\nand will be dispatched soon.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 13,
                              color: const Color(0xFF504440).withOpacity(0.7),
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (userId != null)
                  StreamBuilder<List>(
                    stream: _firestoreService.getUserOrders(userId),
                    builder: (context, snapshot) {
                      final orders = snapshot.data ?? [];
                      if (orders.isEmpty) {
                        return const SliverToBoxAdapter(child: SizedBox());
                      }
                      final lastOrder = orders.first;
                      final firstItem = lastOrder.items.isNotEmpty
                          ? lastOrder.items.first
                          : null;
                      final product = firstItem?.product;
                      final addressWidget = const SizedBox.shrink();

                      return SliverToBoxAdapter(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(24, 32, 24, 0),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F3EF),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _InfoCell(
                                      label: 'Order ID',
                                      value: lastOrder.id,
                                      align: CrossAxisAlignment.start,
                                    ),
                                    _InfoCell(
                                      label: 'Delivery Date',
                                      value: _deliveryDate,
                                      align: CrossAxisAlignment.end,
                                    ),
                                  ],
                                ),
                              ),
                              if (product != null) ...[
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1EDE9),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        child: SizedBox(
                                          width: 72,
                                          height: 88,
                                          child: Image.network(
                                            product.imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                Container(
                                                    color: const Color(
                                                        0xFFEBE7E4)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name,
                                              style: const TextStyle(
                                                fontFamily: 'DMSans',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF1C1C19),
                                              ),
                                              maxLines: 2,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${product.colors.first} / ${product.sizes.first}',
                                              style: TextStyle(
                                                fontFamily: 'DMSerifDisplay',
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                                color: const Color(0xFF504440)
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'LKR ${product.price.toStringAsFixed(0)}',
                                                  style: const TextStyle(
                                                    fontFamily: 'DMSans',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF1C1C19),
                                                  ),
                                                ),
                                                if (lastOrder.items.length > 1)
                                                  Text(
                                                    '+ ${lastOrder.items.length - 1} more',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'DMSerifDisplay',
                                                      fontSize: 11,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: const Color(
                                                              0xFF504440)
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 12),
                              addressWidget,
                            ],
                          ),
                        ),
                      );
                    },
                  )
                else
                  const SliverToBoxAdapter(child: SizedBox()),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/orders'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF705347),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: const StadiumBorder(),
                            ),
                            icon:
                                const Icon(Icons.map_outlined, size: 18),
                            label: const Text(
                              'Track Order',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: TextButton(
                            onPressed: () =>
                                Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (route) => false,
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF705347),
                              shape: const StadiumBorder(),
                            ),
                            child: const Text(
                              'Continue Shopping',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFFD4C3BD),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    color: const Color(0xFFFDF9F5).withOpacity(0.82),
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 8,
                      bottom: 10,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Zuha',
                          style: TextStyle(
                            fontFamily: 'DMSerifDisplay',
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF705347),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/cart'),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Color(0xFF705347),
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment align;

  const _InfoCell({
    required this.label,
    required this.value,
    required this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: const Color(0xFF504440).withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1C1C19),
          ),
        ),
      ],
    );
  }
}

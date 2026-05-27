import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../models/order.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../widgets/common/zuha_bottom_nav.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String _activeFilter = 'All';
  final List<String> _filters = ['All', 'Pending', 'Shipped', 'Delivered'];
  final FirestoreService _firestoreService = FirestoreService();

  String _formatDate(DateTime date) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AuthProvider>().currentUser?.id;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF9F5),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 88)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Past Collections',
                          style: TextStyle(
                            fontFamily: 'DMSerifDisplay',
                            fontSize: 38,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF705347),
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Reflecting on your curated journey through our atelier.',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 13,
                            color: const Color(0xFF504440).withOpacity(0.8),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 72,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, i) {
                        final filter = _filters[i];
                        final isActive = filter == _activeFilter;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _activeFilter = filter),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFF705347)
                                  : const Color(0xFFF1EDE9),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              filter,
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isActive
                                    ? Colors.white
                                    : const Color(0xFF504440),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (userId == null)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Please log in to view orders',
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 14,
                          color: const Color(0xFF504440).withOpacity(0.5),
                        ),
                      ),
                    ),
                  )
                else
                  StreamBuilder<List<ZOrder>>(
                    stream: _firestoreService.getUserOrders(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF705347),
                              ),
                            ),
                          ),
                        );
                      }

                      var allOrders = snapshot.data ?? <ZOrder>[];
                      if (_activeFilter != 'All') {
                        allOrders = allOrders
                            .where((o) => o.status == _activeFilter)
                            .toList();
                      }

                      if (allOrders.isEmpty) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 48,
                                  color: const Color(0xFF504440)
                                      .withOpacity(0.25),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No ${_activeFilter.toLowerCase()} orders',
                                  style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 14,
                                    color: const Color(0xFF504440)
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding:
                            const EdgeInsets.fromLTRB(24, 4, 24, 120),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final order = allOrders[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _OrderCard(
                                  order: order,
                                  formatDate: _formatDate,
                                ),
                              );
                            },
                            childCount: allOrders.length,
                          ),
                        ),
                      );
                    },
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
                        Row(
                          children: [
                            Icon(
                              Icons.menu,
                              color: const Color(0xFF705347),
                              size: 22,
                            ),
                            const SizedBox(width: 14),
                            const Text(
                              'My Orders',
                              style: TextStyle(
                                fontFamily: 'DMSerifDisplay',
                                fontSize: 22,
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF705347),
                              ),
                            ),
                          ],
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
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ZuhaBottomNav(
                currentIndex: 3,
                onTap: (i) {
                  if (i == 3) return;
                  ZuhaBottomNav.navigate(context, i);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final ZOrder order;
  final String Function(DateTime) formatDate;

  const _OrderCard({required this.order, required this.formatDate});

  Color _statusBg() {
    switch (order.status) {
      case 'Delivered':
        return const Color(0xFFC7E8CB);
      case 'Shipped':
        return const Color(0xFFD4C3BD).withOpacity(0.3);
      default:
        return const Color(0xFFE6E2DE);
    }
  }

  Color _statusFg() {
    switch (order.status) {
      case 'Delivered':
        return const Color(0xFF4C6952);
      case 'Shipped':
        return const Color(0xFF705347);
      default:
        return const Color(0xFF504440);
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstItem = order.items.first;
    final product = firstItem.product;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3EF),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            height: 132,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.08),
              colorBlendMode: BlendMode.darken,
              errorBuilder: (_, __, ___) =>
                  Container(color: const Color(0xFFE6E2DE)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: const Color(0xFF82746F),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _statusBg(),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          order.status.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                            color: _statusFg(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontFamily: 'DMSerifDisplay',
                      fontSize: 20,
                      color: Color(0xFF1C1C19),
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ordered: ${formatDate(order.date)}',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 12,
                      color: const Color(0xFF504440).withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL AMOUNT',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              color: const Color(0xFF82746F),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'LKR ${order.total.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF705347),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            const Text(
                              'DETAILS',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: Color(0xFF705347),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: Color(0xFF705347),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

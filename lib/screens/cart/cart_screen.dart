import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../models/cart_item.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/common/zuha_bottom_nav.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;
    final isEmpty = items.isEmpty;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF9F5),
        extendBody: true,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 72)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My Cart',
                          style: TextStyle(
                            fontFamily: 'DMSerifDisplay',
                            fontSize: 36,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF504440),
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${items.length} ITEM${items.length != 1 ? 'S' : ''} SELECTED',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                            color: const Color(0xFF82746F).withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 64,
                            color: const Color(0xFF705347).withOpacity(0.2),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Your atelier bag is empty',
                            style: TextStyle(
                              fontFamily: 'DMSerifDisplay',
                              fontSize: 22,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF504440),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Discover pieces you\'ll love',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 13,
                              color: const Color(0xFF504440).withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 28),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(
                                context, '/explore'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF705347),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'EXPLORE NOW',
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _CartItemCard(
                            item: items[i],
                            onRemove: () =>
                                context.read<CartProvider>().removeItem(
                                      items[i].docId,
                                    ),
                            onIncrement: () =>
                                context.read<CartProvider>().updateQuantity(
                                      items[i].docId,
                                      items[i].quantity + 1,
                                    ),
                            onDecrement: () =>
                                context.read<CartProvider>().updateQuantity(
                                      items[i].docId,
                                      items[i].quantity - 1,
                                    ),
                          ),
                        ),
                        childCount: items.length,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _promoController,
                              style: const TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 14,
                                color: Color(0xFF1C1C19),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Promo code',
                                hintStyle: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 14,
                                  color: const Color(0xFF82746F)
                                      .withOpacity(0.6),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF7F3EF),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(999),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(999),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(999),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC7E8CB),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24),
                                shape: const StadiumBorder(),
                              ),
                              child: const Text(
                                'APPLY',
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                  color: Color(0xFF4C6952),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: _OrderSummary(cart: cart),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 160)),
                ],
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
                      bottom: 12,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.menu),
                          color: const Color(0xFF705347),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const Spacer(),
                        const Text(
                          'Zuha',
                          style: TextStyle(
                            fontFamily: 'DMSerifDisplay',
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF705347),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.shopping_bag_outlined),
                          color: const Color(0xFF705347),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (!isEmpty)
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 72,
                left: 24,
                right: 24,
                child: Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/checkout'),
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      decoration: BoxDecoration(
                        color: const Color(0xFF705347),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF705347).withOpacity(0.3),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'GO TO CHECKOUT',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward,
                              color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: ZuhaBottomNav(
          currentIndex: 2,
          onTap: (i) {
            if (i == 2) return;
            ZuhaBottomNav.navigate(context, i);
          },
        ),
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final ZCartItem item;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartItemCard({
    required this.item,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${item.product.id}-${item.selectedSize}-${item.selectedColor}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFFFDAD6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline,
            color: Color(0xFFBA1A1A), size: 24),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F3EF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 88,
                height: 112,
                child: Image.network(
                  item.product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFFEBE7E4)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 112,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          style: const TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1C1C19),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Size: ${item.selectedSize}  ·  ${item.selectedColor}',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 12,
                            color: const Color(0xFF504440).withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1EDE9),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _MiniStepBtn(
                                  icon: Icons.remove, onTap: onDecrement),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1C1C19),
                                  ),
                                ),
                              ),
                              _MiniStepBtn(
                                  icon: Icons.add, onTap: onIncrement),
                            ],
                          ),
                        ),
                        Text(
                          'LKR ${(item.product.price * item.quantity).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontFamily: 'DMSerifDisplay',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1C1C19),
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
      ),
    );
  }
}

class _MiniStepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MiniStepBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(icon, color: const Color(0xFF705347), size: 16),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final CartProvider cart;

  const _OrderSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    final shipping = cart.subtotal > 0 ? 500.0 : 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEBE7E4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SUMMARY',
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: Color(0xFF504440),
            ),
          ),
          const SizedBox(height: 20),
          _SummaryRow(
            label: 'Subtotal',
            value: 'LKR ${cart.subtotal.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: 'Shipping',
            value: shipping > 0
                ? 'LKR ${shipping.toStringAsFixed(0)}'
                : 'Free',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              color: Color(0xFFD4C3BD),
              thickness: 1,
              height: 1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1C19),
                ),
              ),
              Text(
                'LKR ${cart.total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontFamily: 'DMSerifDisplay',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF705347),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 13,
            color: const Color(0xFF504440).withOpacity(0.8),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1C1C19),
          ),
        ),
      ],
    );
  }
}

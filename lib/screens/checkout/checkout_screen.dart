import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../models/cart_item.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  int _selectedPayment = 0;
  bool _isPlacingOrder = false;
  final FirestoreService _firestoreService = FirestoreService();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _postalCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId == null) return;
    final address = await _firestoreService.getDefaultAddress(userId);
    if (address != null && mounted) {
      final parts = address.fullName.split(' ');
      _firstNameCtrl.text = parts.isNotEmpty ? parts.first : '';
      _lastNameCtrl.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      _addressCtrl.text = address.line1;
      _cityCtrl.text = address.city;
      _postalCtrl.text = address.postalCode;
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _postalCtrl.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    setState(() => _isPlacingOrder = true);

    final cart = context.read<CartProvider>();
    final userId = context.read<AuthProvider>().currentUser?.id;

    if (userId == null) {
      if (!mounted) return;
      setState(() => _isPlacingOrder = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please log in to place an order.'),
          backgroundColor: const Color(0xFF705347),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final items = List<ZCartItem>.from(cart.items);
    final total = cart.total;

    await _firestoreService.placeOrder(userId, items, total);
    cart.clearCart();

    if (!mounted) return;
    setState(() => _isPlacingOrder = false);
    Navigator.pushReplacementNamed(context, '/confirmed');
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF9F5),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 68)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: _ProgressStepper(currentStep: _currentStep),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: _DeliverySection(
                      firstNameCtrl: _firstNameCtrl,
                      lastNameCtrl: _lastNameCtrl,
                      addressCtrl: _addressCtrl,
                      cityCtrl: _cityCtrl,
                      postalCtrl: _postalCtrl,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: AnimatedOpacity(
                    opacity: _currentStep >= 1 ? 1.0 : 0.45,
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                      child: _PaymentSection(
                        selectedIndex: _selectedPayment,
                        onSelect: _currentStep >= 1
                            ? (i) => setState(() => _selectedPayment = i)
                            : null,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: _OrderSummarySection(cart: cart),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: _TrustBadge(
                            icon: Icons.eco_outlined,
                            label: 'Sustainable Packaging',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _TrustBadge(
                            icon: Icons.refresh_rounded,
                            label: '30-Day Returns',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isPlacingOrder ? null : _placeOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF705347),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: const StadiumBorder(),
                        ),
                        child: _isPlacingOrder
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'PLACE ORDER',
                                    style: TextStyle(
                                      fontFamily: 'DMSans',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward, size: 18),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                    child: Text(
                      'By placing this order you agree to our Terms of Service and Privacy Policy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 10,
                        letterSpacing: 0.5,
                        color: const Color(0xFF504440).withOpacity(0.4),
                        height: 1.6,
                      ),
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
                    color: const Color(0xFFFDF9F5).withOpacity(0.85),
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
                        Row(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 14,
                              color: const Color(0xFF504440).withOpacity(0.6),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'SECURE CHECKOUT',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                                color: const Color(0xFF504440).withOpacity(0.6),
                              ),
                            ),
                          ],
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

class _ProgressStepper extends StatelessWidget {
  final int currentStep;
  const _ProgressStepper({required this.currentStep});

  static const _steps = ['Delivery', 'Payment', 'Review'];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          left: 20,
          right: 20,
          child: Container(
            height: 1,
            color: const Color(0xFFD4C3BD).withOpacity(0.3),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_steps.length, (i) {
            final isActive = i <= currentStep;
            return Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF705347)
                        : const Color(0xFFF1EDE9),
                    shape: BoxShape.circle,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: const Color(0xFF705347).withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isActive
                            ? Colors.white
                            : const Color(0xFF504440).withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _steps[i].toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 9,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w400,
                    letterSpacing: 1,
                    color: isActive
                        ? const Color(0xFF1C1C19)
                        : const Color(0xFF504440).withOpacity(0.4),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class _DeliverySection extends StatelessWidget {
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController postalCtrl;

  const _DeliverySection({
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.addressCtrl,
    required this.cityCtrl,
    required this.postalCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shipping Details',
          style: TextStyle(
            fontFamily: 'DMSerifDisplay',
            fontSize: 32,
            fontStyle: FontStyle.italic,
            color: Color(0xFF1C1C19),
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Where should we send your pieces?',
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 13,
            color: const Color(0xFF504440).withOpacity(0.7),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _LabeledField(
                  label: 'First Name',
                  controller: firstNameCtrl,
                  hint: 'Julianne'),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _LabeledField(
                  label: 'Last Name',
                  controller: lastNameCtrl,
                  hint: 'Vandervort'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _LabeledField(
          label: 'Street Address',
          controller: addressCtrl,
          hint: '242 Rue de Rivoli',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _LabeledField(
                  label: 'City', controller: cityCtrl, hint: 'Colombo'),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 2,
              child: _LabeledField(
                label: 'Postal Code',
                controller: postalCtrl,
                hint: '00300',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  const _LabeledField({
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: const Color(0xFF504440).withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 14,
            color: Color(0xFF1C1C19),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 14,
              color: const Color(0xFF504440).withOpacity(0.3),
            ),
            filled: true,
            fillColor: const Color(0xFFF1EDE9),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFF705347).withOpacity(0.2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentSection extends StatelessWidget {
  final int selectedIndex;
  final void Function(int)? onSelect;

  const _PaymentSection({required this.selectedIndex, this.onSelect});

  static const _methods = [
    (icon: Icons.credit_card_outlined, label: 'Card'),
    (icon: Icons.account_balance_wallet_outlined, label: 'Wallet'),
    (icon: Icons.payments_outlined, label: 'Cash'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontFamily: 'DMSerifDisplay',
            fontSize: 24,
            fontStyle: FontStyle.italic,
            color: Color(0xFF1C1C19),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Secured and encrypted',
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 13,
            color: const Color(0xFF504440).withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: List.generate(_methods.length, (i) {
            final isSelected = i == selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: onSelect != null ? () => onSelect!(i) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: i < _methods.length - 1 ? 12 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF705347).withOpacity(0.08)
                        : const Color(0xFFF1EDE9),
                    borderRadius: BorderRadius.circular(14),
                    border: isSelected
                        ? Border.all(
                            color: const Color(0xFF705347).withOpacity(0.3))
                        : Border.all(color: Colors.transparent),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _methods[i].icon,
                        size: 28,
                        color: isSelected
                            ? const Color(0xFF705347)
                            : const Color(0xFF504440).withOpacity(0.5),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _methods[i].label,
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isSelected
                              ? const Color(0xFF705347)
                              : const Color(0xFF504440).withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _OrderSummarySection extends StatelessWidget {
  final CartProvider cart;
  const _OrderSummarySection({required this.cart});

  @override
  Widget build(BuildContext context) {
    final items = cart.items;
    final shipping = cart.subtotal > 0 ? 500.0 : 0.0;
    final tax = cart.subtotal * 0.08;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3EF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontFamily: 'DMSerifDisplay',
              fontSize: 20,
              fontStyle: FontStyle.italic,
              color: Color(0xFF1C1C19),
            ),
          ),
          const SizedBox(height: 20),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 64,
                      height: 76,
                      child: Image.network(
                        item.product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: const Color(0xFFEBE7E4)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          style: const TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1C1C19),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${item.selectedColor} / ${item.selectedSize}',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 10,
                            letterSpacing: 1,
                            color: const Color(0xFF504440).withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'LKR ${item.product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1C1C19),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
              color: const Color(0xFFD4C3BD).withOpacity(0.4),
              thickness: 1,
              height: 24),
          _TotalRow(
              label: 'Subtotal',
              value: 'LKR ${cart.subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 10),
          _TotalRow(
            label: 'Shipping',
            value: shipping > 0
                ? 'LKR ${shipping.toStringAsFixed(0)}'
                : 'Complimentary',
            valueColor: shipping == 0 ? const Color(0xFF48654E) : null,
            isSmallValue: shipping == 0,
          ),
          const SizedBox(height: 10),
          _TotalRow(
              label: 'Tax (8%)',
              value: 'LKR ${tax.toStringAsFixed(0)}'),
          Divider(
              color: const Color(0xFFD4C3BD).withOpacity(0.3),
              thickness: 1,
              height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontFamily: 'DMSerifDisplay',
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF1C1C19),
                ),
              ),
              Text(
                'LKR ${(cart.subtotal + shipping + tax).toStringAsFixed(0)}',
                style: const TextStyle(
                  fontFamily: 'DMSerifDisplay',
                  fontSize: 20,
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

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isSmallValue;

  const _TotalRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isSmallValue = false,
  });

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
            color: const Color(0xFF504440).withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: isSmallValue ? 11 : 14,
            fontWeight: FontWeight.w500,
            letterSpacing: isSmallValue ? 1 : 0,
            color: valueColor ?? const Color(0xFF1C1C19),
          ),
        ),
      ],
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: const Color(0xFF48654E)),
          const SizedBox(height: 8),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: const Color(0xFF504440).withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

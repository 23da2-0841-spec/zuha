import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../models/product.dart';
import '../../services/firestore_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';
  final FirestoreService _firestoreService = FirestoreService();

  static const _recentSearches = [
    'Cotton Tunic',
    'Wool Blazer',
    'Handcrafted Leather Bag',
  ];

  static const _trending = [
    ('The Summer Linen Edit', '2.4k people searching'),
    ('Artisanal Gold Jewellery', '1.8k people searching'),
    ('Neutral Palette Essentials', '940 people searching'),
  ];

  static const _collections = [
    (
      label: 'The Atelier',
      imageUrl:
          'https://images.unsplash.com/photo-1523381294911-8d3cead13475?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
    ),
    (
      label: 'Raw Textures',
      imageUrl:
          'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _setQuery(String value) {
    setState(() {
      _query = value;
      _searchController.text = value;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: value.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = _query.isNotEmpty;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF9F5),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 72)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Search',
                          style: TextStyle(
                            fontFamily: 'DMSerifDisplay',
                            fontSize: 40,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF1C1C19),
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 58,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1EDE9),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Icon(
                                  Icons.search,
                                  color: Color(0xFF82746F),
                                  size: 22,
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  focusNode: _focusNode,
                                  onChanged: (v) =>
                                      setState(() => _query = v),
                                  style: const TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 16,
                                    color: Color(0xFF1C1C19),
                                  ),
                                  decoration: InputDecoration(
                                    hintText:
                                        'Linen dresses, silk scarves...',
                                    hintStyle: TextStyle(
                                      fontFamily: 'DMSans',
                                      fontSize: 15,
                                      color: const Color(0xFF504440)
                                          .withOpacity(0.4),
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              if (hasQuery)
                                GestureDetector(
                                  onTap: () => setState(() {
                                    _query = '';
                                    _searchController.clear();
                                  }),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 14),
                                    child: Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF705347)
                                            .withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Color(0xFF705347),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (hasQuery) ...[
                  StreamBuilder<List<ZProduct>>(
                    stream: _firestoreService.getProducts(),
                    builder: (context, snapshot) {
                      final allProducts = snapshot.data ?? <ZProduct>[];
                      final q = _query.toLowerCase();
                      final results = allProducts
                          .where((p) =>
                              p.name.toLowerCase().contains(q) ||
                              p.brand.toLowerCase().contains(q) ||
                              p.category.toLowerCase().contains(q))
                          .toList();

                      return SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(24, 24, 24, 0),
                            child: Text(
                              '${results.length} result${results.length != 1 ? 's' : ''} for "$_query"',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 12,
                                color: const Color(0xFF504440)
                                    .withOpacity(0.6),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          if (results.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.search_off_rounded,
                                      size: 48,
                                      color: const Color(0xFF504440)
                                          .withOpacity(0.2),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No results for "$_query"',
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
                            )
                          else
                            ...results.map(
                              (product) => Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(24, 16, 24, 0),
                                child: _SearchResultRow(
                                  product: product,
                                  onTap: () => Navigator.pushNamed(
                                      context, '/product',
                                      arguments: product),
                                ),
                              ),
                            ),
                        ]),
                      );
                    },
                  ),
                ] else ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'RECENT SEARCHES',
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2,
                                  color: const Color(0xFF504440)
                                      .withOpacity(0.6),
                                ),
                              ),
                              Text(
                                'CLEAR ALL',
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  color: const Color(0xFF705347),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _recentSearches
                                .map(
                                  (term) => GestureDetector(
                                    onTap: () => _setQuery(term),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F3EF),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            term,
                                            style: const TextStyle(
                                              fontFamily: 'DMSans',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF504440),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.history,
                                            size: 14,
                                            color: const Color(0xFFD4C3BD)
                                                .withOpacity(0.8),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TRENDING NOW',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: const Color(0xFF504440).withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ..._trending.asMap().entries.map((entry) {
                            final i = entry.key;
                            final item = entry.value;
                            return _TrendingRow(
                              number: '0${i + 1}',
                              title: item.$1,
                              subtitle: item.$2,
                              onTap: () => _setQuery(item.$1),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DISCOVER COLLECTIONS',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: const Color(0xFF504440).withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _CollectionCard(
                                  label: _collections[0].label,
                                  imageUrl: _collections[0].imageUrl,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 32),
                                  child: _CollectionCard(
                                    label: _collections[1].label,
                                    imageUrl: _collections[1].imageUrl,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
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
                        const Text(
                          'Zuha',
                          style: TextStyle(
                            fontFamily: 'DMSerifDisplay',
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF705347),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'CLOSE',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: Color(0xFF705347),
                            ),
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

class _SearchResultRow extends StatelessWidget {
  final ZProduct product;
  final VoidCallback onTap;

  const _SearchResultRow({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F3EF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 64,
                height: 80,
                child: Image.network(
                  product.imageUrl,
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
                    product.brand.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: const Color(0xFF504440).withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C19),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'LKR ${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF705347),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Color(0xFFD4C3BD),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendingRow extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TrendingRow({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: Row(
          children: [
            Text(
              number,
              style: TextStyle(
                fontFamily: 'DMSerifDisplay',
                fontSize: 28,
                fontStyle: FontStyle.italic,
                color: const Color(0xFFD4C3BD).withOpacity(0.5),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1C1C19),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 11,
                      color: const Color(0xFF504440).withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_outward,
              size: 16,
              color: const Color(0xFFD4C3BD).withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final String label;
  final String imageUrl;

  const _CollectionCard({required this.label, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 240,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: const Color(0xFFEBE7E4)),
            ),
            Container(color: Colors.black.withOpacity(0.12)),
            Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'DMSerifDisplay',
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

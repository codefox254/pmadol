import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/gallery_models.dart';
import 'providers/gallery_provider.dart';
import 'providers/home_provider.dart';
import 'widgets/footer_widget.dart';
import 'config/api_config.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String selectedCategory = 'All';
  GalleryItem? selectedItem;
  final TextEditingController _searchController = TextEditingController();

  String? _resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return '${ApiConfig.baseUrl}$path';
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<GalleryProvider>().loadGalleryItems();
      context.read<HomeProvider>().loadHomeData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Consumer2<GalleryProvider, HomeProvider>(
      builder: (context, galleryProvider, homeProvider, child) {
        final homeData = homeProvider.homeData;

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildPageHeader(),
              _buildSearchBar(isMobile, galleryProvider),
              _buildCategoryFilter(isMobile, galleryProvider),
              _buildGalleryGrid(isMobile, galleryProvider),
              if (homeData != null) FooterWidget(settings: homeData.siteSettings),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageHeader() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5886BF), Color(0xFF283D57)],
        ),
      ),
      child: Stack(
        children: [
          Container(color: Colors.black.withOpacity(0.2)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'OUR MOMENTS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 3.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Gallery',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Explore our chess community events and activities',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isMobile, GalleryProvider galleryProvider) {
    final horizontalPadding = isMobile ? 16.0 : 80.0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: horizontalPadding),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFE8EFF7)),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.search, color: Color(0xFF707781), size: 20),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search gallery items...',
                  hintStyle: TextStyle(color: Color(0xFFB0B8C1)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (query) {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(bool isMobile, GalleryProvider galleryProvider) {
    final items = galleryProvider.items;
    final categories = ['All', ...items.map((i) => i.categoryName ?? 'Other').toSet()];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 20 : 30,
        horizontal: isMobile ? 16 : 80,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: isMobile ? 10 : 15,
          children: categories.map((category) {
            final isSelected = selectedCategory == category;
            return GestureDetector(
              onTap: () {
                setState(() => selectedCategory = category);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 24,
                  vertical: isMobile ? 10 : 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF5886BF) : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? Color(0xFF5886BF) : Color(0xFFE8EFF7),
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Color(0xFF404957),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildGalleryGrid(bool isMobile, GalleryProvider galleryProvider) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 80,
        vertical: 40,
      ),
      child: Consumer<GalleryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return SizedBox(
              height: 300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF5886BF), strokeWidth: 3),
                    SizedBox(height: 16),
                    Text('Loading gallery...', style: TextStyle(color: Color(0xFF707781))),
                  ],
                ),
              ),
            );
          }

          if (provider.error != null && provider.error!.isNotEmpty) {
            return Container(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red.withOpacity(0.6)),
                  SizedBox(height: 16),
                  Text(
                    'Error loading gallery',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF0B131E)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    provider.error ?? 'Unknown error',
                    style: TextStyle(color: Color(0xFF707781), fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => provider.loadGalleryItems(),
                    icon: Icon(Icons.refresh),
                    label: Text('Retry'),
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF5886BF)),
                  ),
                ],
              ),
            );
          }

          var filteredItems = selectedCategory == 'All'
              ? provider.items
              : provider.items.where((i) => i.categoryName == selectedCategory).toList();

          if (_searchController.text.isNotEmpty) {
            final q = _searchController.text.toLowerCase();
            filteredItems = filteredItems
                .where((i) =>
                    i.title.toLowerCase().contains(q) ||
                    (i.description?.toLowerCase().contains(q) ?? false))
                .toList();
          }

          if (filteredItems.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image_not_supported_outlined, size: 48, color: Color(0xFF707781).withOpacity(0.4)),
                    SizedBox(height: 16),
                    Text(
                      'No gallery items found',
                      style: TextStyle(fontSize: 18, color: Color(0xFF707781)),
                    ),
                  ],
                ),
              ),
            );
          }

          final gridColumns = isMobile ? 2 : (MediaQuery.of(context).size.width > 1200 ? 4 : 3);

          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridColumns,
              crossAxisSpacing: isMobile ? 12 : 20,
              mainAxisSpacing: isMobile ? 12 : 20,
              childAspectRatio: 1,
            ),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return _buildGalleryItem(filteredItems[index], isMobile, provider);
            },
          );
        },
      ),
    );
  }

  Widget _buildGalleryItem(GalleryItem item, bool isMobile, GalleryProvider provider) {
    return GestureDetector(
      onTap: () {
        _showImageDialog(item, isMobile, provider);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
            color: Color(0xFFF8FAFC),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color(0xFFF8FAFC),
                  image: item.image.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(_resolveImageUrl(item.image)!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: item.image.isEmpty
                    ? Center(
                        child: Icon(Icons.image_not_supported_outlined,
                            size: 50, color: Color(0xFF707781).withOpacity(0.3)),
                      )
                    : null,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 13 : 15,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Color(0xFF5886BF).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.categoryName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(Icons.zoom_in, color: Color(0xFF5886BF), size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageDialog(GalleryItem item, bool isMobile, GalleryProvider provider) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.95),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(isMobile ? 16 : 40),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.image.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.75,
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                          ),
                          child: Image.network(
                            _resolveImageUrl(item.image)!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[900],
                                child: Center(
                                  child: Icon(Icons.error, color: Colors.red, size: 48),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(24),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.85,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              color: Color(0xFF0B131E),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Color(0xFF5886BF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item.categoryName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (item.description != null && item.description!.isNotEmpty) ...[
                            SizedBox(height: 16),
                            Text(
                              item.description!,
                              style: TextStyle(
                                color: Color(0xFF404957),
                                fontSize: 15,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(Icons.close, color: Color(0xFF0B131E), size: 24),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

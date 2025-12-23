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

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<GalleryProvider>().loadGalleryItems();
      context.read<HomeProvider>().loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GalleryProvider, HomeProvider>(
      builder: (context, galleryProvider, homeProvider, child) {
        if (galleryProvider.isLoading || homeProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF5886BF)),
          );
        }

        final homeData = homeProvider.homeData;
        if (homeData == null) {
          return const Center(child: Text('No data available'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildPageHeader(),
              _buildCategoryFilter(galleryProvider),
              _buildGalleryGrid(galleryProvider),
              _buildVideoSection(galleryProvider),
              FooterWidget(settings: homeData.siteSettings),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageHeader() {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5886BF),
            Color(0xFF283D57),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'OUR MOMENTS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Gallery',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Text(
                    'Capturing the spirit of chess excellence',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(GalleryProvider provider) {
    // Extract unique categories from gallery items
    final categories = ['All', ...{
      for (var item in provider.items) item.categoryName
    }];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 80),
      color: Colors.white,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: categories.map((category) {
          final isSelected = selectedCategory == category;
          return InkWell(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF5886BF) : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFF5886BF),
                  width: 2,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: Color(0xFF5886BF).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ] : [],
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Color(0xFF283D57),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGalleryGrid(GalleryProvider provider) {
    // Filter items: only images (not videos) and by category
    final images = provider.images.where((item) =>
      selectedCategory == 'All' || item.categoryName == selectedCategory
    ).toList();

    if (images.isEmpty) {
      return Container(
        padding: EdgeInsets.all(80),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No images found in this category',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color(0xFFF0F4F9),
          ],
        ),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return _buildGalleryItem(images[index]);
        },
      ),
    );
  }

  Widget _buildGalleryItem(GalleryItem item) {
    return InkWell(
      onTap: () {
        _showImageDialog(context, item);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item.image.isNotEmpty
                ? Image.network(
                    '${ApiConfig.baseUrl}${item.image}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Color(0xFFF0F4F9),
                      child: Icon(Icons.photo, size: 48, color: Color(0xFF5886BF)),
                    ),
                  )
                : Container(
                    color: Color(0xFFF0F4F9),
                    child: Icon(Icons.photo, size: 48, color: Color(0xFF5886BF)),
                  ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.75),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    item.categoryName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.zoom_in, color: Color(0xFF5886BF), size: 18),
              ),
            ),
            if (item.isFeatured)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF5886BF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'FEATURED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, GalleryItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    child: item.image.isNotEmpty
                      ? Image.network(
                          '${ApiConfig.baseUrl}${item.image}',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Color(0xFFF0F4F9),
                            child: Center(
                              child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
                            ),
                          ),
                        )
                      : Container(
                          color: Color(0xFFF0F4F9),
                          child: Center(
                            child: Icon(Icons.photo, size: 64, color: Color(0xFF5886BF)),
                          ),
                        ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0B131E),
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF5886BF).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item.categoryName,
                                    style: TextStyle(
                                      color: Color(0xFF5886BF),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (item.description != null && item.description!.isNotEmpty) ...[
                              SizedBox(height: 12),
                              Text(
                                item.description!,
                                style: TextStyle(
                                  color: Color(0xFF404957),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 28),
                        color: Color(0xFF404957),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoSection(GalleryProvider provider) {
    // Filter only video items by category
    final videos = provider.videos.where((item) =>
      selectedCategory == 'All' || item.categoryName == selectedCategory
    ).toList();

    if (videos.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF0F4F9),
            Color(0xFFE8EFF7),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFF5886BF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'VIDEO HIGHLIGHTS',
              style: TextStyle(
                color: Color(0xFF283D57),
                fontSize: 12,
                letterSpacing: 3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Watch Our Journey',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 48,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 60),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: 16 / 9,
            ),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              return _buildVideoCard(videos[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(GalleryItem item) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: item.image.isNotEmpty
              ? Image.network(
                  '${ApiConfig.baseUrl}${item.image}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Color(0xFFF0F4F9),
                    child: Icon(Icons.videocam, size: 48, color: Color(0xFF5886BF)),
                  ),
                )
              : Container(
                  color: Color(0xFFF0F4F9),
                  child: Icon(Icons.videocam, size: 48, color: Color(0xFF5886BF)),
                ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF5886BF),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF5886BF).withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(Icons.play_arrow, color: Colors.white, size: 40),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.description != null && item.description!.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Text(
                    item.description!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (item.isFeatured)
            Positioned(
              top: 15,
              right: 15,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF5886BF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'FEATURED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

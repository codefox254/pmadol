# Guide: Modernizing Remaining Screens

This guide shows how to apply the same modern design pattern to the remaining screens.

## Pattern to Follow

### 1. Import Required Packages
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/home_provider.dart';
import 'widgets/footer_widget.dart';
```

### 2. Create StatefulWidget
```dart
class [ScreenName]Screen extends StatefulWidget {
  const [ScreenName]Screen({super.key});

  @override
  State<[ScreenName]Screen> createState() => _[ScreenName]ScreenState();
}

class _[ScreenName]ScreenState extends State<[ScreenName]Screen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    Future.microtask(() {
      context.read<HomeProvider>().loadHomeData();
    });
  }
}
```

### 3. Build Method with Consumer
```dart
@override
Widget build(BuildContext context) {
  return Consumer<HomeProvider>(
    builder: (context, homeProvider, child) {
      // Loading state
      if (homeProvider.isLoading) {
        return Center(
          child: CircularProgressIndicator(color: Color(0xFF5886BF)),
        );
      }

      // Error state
      if (homeProvider.error != null) {
        return _buildErrorWidget();
      }

      // Data state
      final homeData = homeProvider.homeData;
      if (homeData == null) {
        return Center(child: Text('No data available'));
      }

      // Render content
      return SingleChildScrollView(
        child: Column(
          children: [
            _buildPageHeader(homeData.siteSettings),
            _buildMainContent(),
            FooterWidget(settings: homeData.siteSettings),
          ],
        ),
      );
    },
  );
}
```

## Color Palette

Use these gradients for different sections:

```dart
// Light Blue Gradient
gradient: LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFF0F4F9),
    Color(0xFFE8EFF7),
  ],
),

// Clean White Gradient
gradient: LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Color(0xFFFFFFFF),
    Color(0xFFF8FAFC),
  ],
),

// Blue Gradient (Primary)
gradient: LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF5886BF),
    Color(0xFF3D5A8F),
  ],
),
```

## Section Component Pattern

```dart
Widget _buildSection(String title, String subtitle, List<Widget> children) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 80, horizontal: 80),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFF0F4F9),
          Color(0xFFE8EFF7),
        ],
      ),
    ),
    child: Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFF5886BF),
            fontSize: 14,
            letterSpacing: 3.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20),
        Text(
          subtitle,
          style: TextStyle(
            color: Color(0xFF0B131E),
            fontSize: 48,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 60),
        ...children,
      ],
    ),
  );
}
```

## Card Component Pattern

```dart
Widget _buildCard(String title, String description, IconData icon) {
  return Container(
    width: 220,
    padding: EdgeInsets.all(30),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xFF5886BF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(icon, color: Color(0xFF5886BF), size: 30),
        ),
        SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF0B131E),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 15),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF707781),
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    ),
  );
}
```

## Recommended Screens to Update

### Services Screen
```
Header (Gradient)
  ↓
Services Grid (Cards with icons)
  ↓
Service Details Section
  ↓
Pricing Section
  ↓
CTA Section
  ↓
Footer
```

### Gallery Screen
```
Header (Gradient)
  ↓
Gallery Grid/Masonry
  ↓
Category Filter
  ↓
Lightbox/Detail View
  ↓
Footer
```

### Blog Screen
```
Header (Gradient)
  ↓
Blog Posts Grid
  ↓
Category/Tag Filter
  ↓
Search
  ↓
Pagination
  ↓
Footer
```

### Shop Screen
```
Header (Gradient)
  ↓
Products Grid
  ↓
Category Filter
  ↓
Price Range Filter
  ↓
Product Details
  ↓
Footer
```

## Key Styling Guidelines

### Typography
- Page Title: 48px, Bold, Primary color
- Section Subtitle: 36px, Bold, Dark color
- Card Title: 18px, Semi-bold, Dark color
- Body Text: 16px, Regular, Gray color
- Small Text: 14px, Regular, Light gray

### Spacing
- Vertical padding sections: 80px
- Horizontal padding sections: 80px
- Card padding: 30px
- Between sections: 60px gap

### Colors
- Primary: #5886BF (Buttons, highlights)
- Secondary: #283D57 (Important text)
- Dark: #0B131E (Main text)
- Gray: #707781 (Body text)
- Light: #F0F4F9 (Backgrounds)

### Shadows
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.08),
  blurRadius: 10,
  offset: Offset(0, 4),
),
```

### Border Radius
- Small elements: 8px
- Cards: 12px
- Large containers: 16px

## Testing Checklist

For each screen:
- [ ] Loading state shows spinner
- [ ] Error state shows retry button
- [ ] Data loads correctly from API
- [ ] Footer displays properly
- [ ] All gradients render correctly
- [ ] Text is readable on all backgrounds
- [ ] Cards have proper spacing
- [ ] Responsive on different screen sizes
- [ ] Buttons are clickable
- [ ] Images load properly

## Quick Start Command

After making changes:
```bash
cd frontend/frontend
flutter pub get
flutter run -d web-server
```

---

Happy modernizing! 🎨

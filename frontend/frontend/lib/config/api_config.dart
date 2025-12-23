// ============================================
// lib/config/api_config.dart
// ============================================
class ApiConfig {
  // Change this to your machine's IP address if testing on physical device
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String apiUrl = '$baseUrl/api';
  
  // API Endpoints
  static const String authLogin = '$apiUrl/auth/login/';
  static const String authRegister = '$apiUrl/auth/users/register/';
  static const String authRefresh = '$apiUrl/auth/refresh/';
  static const String userProfile = '$apiUrl/auth/users/me/';
  
  // Core endpoints
  static const String homepage = '$apiUrl/core/homepage/';
  static const String siteSettings = '$apiUrl/core/site-settings/current/';
  static const String statistics = '$apiUrl/core/statistics/current/';
  static const String testimonials = '$apiUrl/core/testimonials/';
  static const String testimonialsFeatured = '$apiUrl/core/testimonials/featured/';
  static const String partners = '$apiUrl/core/partners/';
  static const String teamMembers = '$apiUrl/core/team-members/';
  static const String about = '$apiUrl/core/about/current/';
  static const String faqs = '$apiUrl/core/faqs/';
  
  // Blog endpoints
  static const String blogPosts = '$apiUrl/blog/posts/';
  static const String blogFeatured = '$apiUrl/blog/posts/featured/';
  static const String blogCategories = '$apiUrl/blog/categories/';
  static const String blogComments = '$apiUrl/blog/comments/';
  
  // Services endpoints
  static const String services = '$apiUrl/services/services/';
  static const String pricingPlans = '$apiUrl/services/pricing-plans/';
  static const String bookings = '$apiUrl/services/bookings/';
  
  // Shop endpoints
  static const String products = '$apiUrl/shop/products/';
  static const String cart = '$apiUrl/shop/cart/';
  static const String orders = '$apiUrl/shop/orders/';
  
  // Gallery endpoints
  static const String galleryItems = '$apiUrl/gallery/items/';
  static const String galleryPhotos = '$apiUrl/gallery/photos/';
  static const String galleryVideos = '$apiUrl/gallery/videos/';
  
  // Contact endpoints
  static const String contactInfo = '$apiUrl/contact/info/current/';
  static const String contactMessage = '$apiUrl/contact/messages/';
  static const String consultation = '$apiUrl/contact/consultations/';
}
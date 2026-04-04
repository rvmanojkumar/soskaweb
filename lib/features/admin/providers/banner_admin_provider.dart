import 'package:flutter/material.dart';
import '../../shared/data/banner_api.dart';
import '../../../core/models/banner.dart';

class BannerAdminProvider extends ChangeNotifier {
  final BannerApi _bannerApi = BannerApi();

  List<BannerModel> _banners = [];
  bool _isLoading = false;
  String? _error;

  List<BannerModel> get banners => _banners;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAllBanners() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _banners = await _bannerApi.getBanners();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBanner(BannerModel banner) async {
    // Implementation for adding banner via API
    // This would be used in admin panel
  }

  Future<void> updateBanner(BannerModel banner) async {
    // Implementation for updating banner
  }

  Future<void> deleteBanner(String bannerId) async {
    // Implementation for deleting banner
  }
}

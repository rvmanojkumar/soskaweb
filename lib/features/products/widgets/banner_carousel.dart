import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/banner.dart';

class BannerCarousel extends StatefulWidget {
  final List<BannerModel> banners;
  final double height;
  final bool autoPlay;
  final Duration autoPlayInterval;

  const BannerCarousel({
    Key? key,
    required this.banners,
    this.height = 200,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 5),
  }) : super(key: key);

  @override
  _BannerCarouselState createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: Container(
          color: Colors.grey[200],
          child: Center(
            child: Text('No banners available'),
          ),
        ),
      );
    }

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: widget.height,
            autoPlay: widget.autoPlay,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            autoPlayInterval: widget.autoPlayInterval,
            pauseAutoPlayOnTouch: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.banners.map((banner) {
            return _buildBannerItem(banner);
          }).toList(),
        ),
        SizedBox(height: 12),
        // Indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.banners.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Theme.of(context).primaryColor
                    : Colors.grey.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerItem(BannerModel banner) {
    return GestureDetector(
      onTap: () {
        if (banner.ctaLink != null && banner.ctaLink!.isNotEmpty) {
          // Handle navigation based on CTA link
          if (banner.ctaLink!.startsWith('/')) {
            Navigator.pushNamed(context, banner.ctaLink!);
          } else if (banner.ctaLink!.startsWith('http')) {
            // Open external link
            // You can add url_launcher here
          }
        }
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: banner.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: widget.height,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Failed to load image',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Optional: Overlay text
            Positioned(
              left: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (banner.title.isNotEmpty)
                    Text(
                      banner.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  if (banner.subtitle != null && banner.subtitle!.isNotEmpty)
                    Text(
                      banner.subtitle!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  if (banner.ctaText != null && banner.ctaText!.isNotEmpty)
                    SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (banner.ctaLink != null &&
                          banner.ctaLink!.isNotEmpty) {
                        Navigator.pushNamed(context, banner.ctaLink!);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(banner.ctaText!),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

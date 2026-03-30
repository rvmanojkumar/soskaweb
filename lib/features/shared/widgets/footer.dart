import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          // Desktop Layout
          if (MediaQuery.of(context).size.width > 800)
            _buildDesktopFooter()
          else
            _buildMobileFooter(),

          SizedBox(height: 32),
          Divider(color: Colors.grey[800]),
          SizedBox(height: 16),
          Text(
            '© 2024 Soskali Lifestyles. All rights reserved.',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFooter() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SOSKALI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Your one-stop destination for trendy fashion and lifestyle products.',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Links',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              _buildFooterLink('About Us', () {}),
              _buildFooterLink('Contact Us', () {}),
              _buildFooterLink('FAQs', () {}),
              _buildFooterLink('Privacy Policy', () {}),
              _buildFooterLink('Terms & Conditions', () {}),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Info',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Email: support@soskalifestyles.com',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
              SizedBox(height: 8),
              Text(
                'Phone: +1 234 567 8900',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Follow Us',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  _buildSocialIcon(Icons.facebook, Colors.blue, () {}),
                  SizedBox(width: 12),
                  _buildSocialIcon(
                      Icons.camera_alt, Colors.purple, () {}), // Instagram
                  SizedBox(width: 12),
                  _buildSocialIcon(
                      Icons.message, Colors.lightBlue, () {}), // Twitter
                  SizedBox(width: 12),
                  _buildSocialIcon(
                      Icons.play_circle_filled, Colors.red, () {}), // YouTube
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Subscribe to Newsletter',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Your email',
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text('Subscribe'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SOSKALI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Your one-stop destination for trendy fashion and lifestyle products.',
          style: TextStyle(color: Colors.grey[400]),
        ),
        SizedBox(height: 24),
        Text(
          'Quick Links',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        _buildFooterLink('About Us', () {}),
        _buildFooterLink('Contact Us', () {}),
        _buildFooterLink('FAQs', () {}),
        _buildFooterLink('Privacy Policy', () {}),
        _buildFooterLink('Terms & Conditions', () {}),
        SizedBox(height: 24),
        Text(
          'Contact Info',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Email: support@soskalifestyles.com',
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        SizedBox(height: 8),
        Text(
          'Phone: +1 234 567 8900',
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        SizedBox(height: 24),
        Text(
          'Follow Us',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            _buildSocialIcon(Icons.facebook, Colors.blue, () {}),
            SizedBox(width: 12),
            _buildSocialIcon(Icons.camera_alt, Colors.purple, () {}),
            SizedBox(width: 12),
            _buildSocialIcon(Icons.message, Colors.lightBlue, () {}),
            SizedBox(width: 12),
            _buildSocialIcon(Icons.play_circle_filled, Colors.red, () {}),
          ],
        ),
        SizedBox(height: 24),
        Text(
          'Subscribe to Newsletter',
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Your email',
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text('Subscribe'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterLink(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

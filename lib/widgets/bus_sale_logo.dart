import 'package:flutter/material.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';

/// Atelier seal (geometric 4) + BUS · SALE wordmark — the mark David approved.
class BusSaleLogo extends StatelessWidget {
  const BusSaleLogo({
    super.key,
    this.size = 160,
    this.showWordmark = true,
  });

  final double size;
  final bool showWordmark;

  static const _badgeAsset = 'assets/images/bus_sale_badge.png';
  static const _logoAsset = 'assets/images/bus_sale_logo.png';

  @override
  Widget build(BuildContext context) {
    if (showWordmark) {
      return Image.asset(
        _logoAsset,
        width: size * 1.2,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, _, _) => _fallback(),
      );
    }

    return Image.asset(
      _badgeAsset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, _, _) => _fallback(),
    );
  }

  Widget _fallback() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: _AtelierSealPainter()),
        ),
        if (showWordmark) ...[
          SizedBox(height: size * 0.1),
          Text(
            'BUS · SALE',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size * 0.23,
              fontWeight: FontWeight.w900,
              letterSpacing: size * 0.016,
              color: AppColors.ink,
              height: 1.1,
            ),
          ),
          SizedBox(height: size * 0.05),
          Text(
            'BUSINESSES FOR SALE',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size * 0.072,
              fontWeight: FontWeight.w700,
              letterSpacing: size * 0.008,
              color: AppColors.claret,
              height: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}

class _AtelierSealPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - size.width * 0.03;

    canvas.drawCircle(center, radius, Paint()..color = AppColors.ivory);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.champagne
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.028,
    );
    canvas.drawCircle(
      center,
      radius * 0.875,
      Paint()
        ..color = AppColors.claret
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.012,
    );

    final h = size.height * 0.42;
    final stroke = h * 0.118;
    final cx = center.dx;
    final cy = center.dy - size.height * 0.01;
    final top = cy - h * 0.50;
    final bottom = cy + h * 0.50;
    final stemX = cx + h * 0.10;
    final crossY = cy + h * 0.08;
    final left = cx - h * 0.40;
    final right = stemX + h * 0.26;
    final fill = Paint()..color = AppColors.claret;

    final triangle = Path()
      ..moveTo(stemX - stroke * 0.48, top + h * 0.02)
      ..lineTo(left, crossY + stroke * 0.48)
      ..lineTo(stemX - stroke * 0.48, crossY + stroke * 0.48)
      ..close();
    canvas.drawPath(triangle, fill);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(left, crossY - stroke * 0.48, right, crossY + stroke * 0.48),
        Radius.circular(stroke * 0.08),
      ),
      fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(stemX - stroke * 0.48, top, stemX + stroke * 0.48, bottom),
        Radius.circular(stroke * 0.08),
      ),
      fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

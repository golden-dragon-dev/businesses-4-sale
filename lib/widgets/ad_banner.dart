import 'dart:async';

import 'package:flutter/material.dart';
import 'package:businesses_4_sale/config/app_config.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';

class AdSlide {
  const AdSlide({
    required this.title,
    required this.subtitle,
    this.color = AppColors.red,
    this.imageAsset,
  });

  final String title;
  final String subtitle;
  final Color color;
  /// Optional full-bleed image (e.g. Pack p1 flyer).
  final String? imageAsset;
}

/// Rotating advertisement strip.
/// Default height is **1/3 of screen** (double the original Pack 1/6 slot).
/// First slide is David's Pack p1 flyer.
///
/// Swipe the ad strip left/right to change ads manually. Prev / pause / next
/// also work. Autoplay pauses as soon as you take control (press play to resume).
class AdBanner extends StatefulWidget {
  const AdBanner({
    super.key,
    this.slides = const [
      AdSlide(
        title: 'Businesses 4 Sale',
        subtitle: 'List your business for sale.',
        imageAsset: 'assets/ads/p1_flyer.png',
      ),
      AdSlide(
        title: 'List your business',
        subtitle: 'Retiring or resigning? Join and reach local buyers.',
      ),
      AdSlide(
        title: 'Browse current listings',
        subtitle: 'See businesses listed in the last 2 days.',
        color: Color(0xFF1A5F2A),
      ),
      AdSlide(
        title: 'Support the app',
        subtitle: 'Donate via Stripe — one-off or monthly.',
        color: Color(0xFF0B3D91),
      ),
    ],
    this.autoPlay = true,
  });

  final List<AdSlide> slides;
  final bool autoPlay;

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  late final PageController _controller;
  Timer? _timer;
  int _index = 0;
  bool _paused = false;
  bool _programmatic = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    if (widget.autoPlay) {
      _startTimer();
    } else {
      _paused = true;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(AppConfig.adRotateInterval, (_) {
      if (!mounted || _paused || widget.slides.isEmpty) return;
      final next = (_index + 1) % widget.slides.length;
      _animateTo(next);
    });
  }

  Future<void> _animateTo(int page) async {
    _programmatic = true;
    await _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    _programmatic = false;
  }

  void _takeManualControl({required int delta}) {
    if (widget.slides.isEmpty) return;
    setState(() => _paused = true);
    var next = (_index + delta) % widget.slides.length;
    if (next < 0) next = widget.slides.length - 1;
    _animateTo(next);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    // Double the original ≈1/6 slot → ≈1/3 of screen for the ad creative.
    final adContentHeight = (screenHeight / 3).clamp(180.0, 340.0);
    const controlsHeight = 40.0;

    return SizedBox(
      height: adContentHeight + controlsHeight,
      child: Column(
        children: [
          SizedBox(
            height: adContentHeight,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                // Finger drag on the ad — stop autoplay so the user stays in control.
                if (notification is ScrollStartNotification &&
                    notification.dragDetails != null &&
                    !_paused) {
                  setState(() => _paused = true);
                }
                return false;
              },
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.slides.length,
                onPageChanged: (value) {
                  setState(() {
                    _index = value;
                    if (!_programmatic) _paused = true;
                  });
                },
                itemBuilder: (context, index) {
                  final slide = widget.slides[index];
                  if (slide.imageAsset != null) {
                    return ColoredBox(
                      color: AppColors.ivory,
                      child: Image.asset(
                        slide.imageAsset!,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (_, _, _) => _TextAd(slide: slide),
                      ),
                    );
                  }
                  return _TextAd(slide: slide);
                },
              ),
            ),
          ),
          ColoredBox(
            color: AppColors.lightGrey,
            child: SizedBox(
              height: controlsHeight,
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Previous',
                    onPressed: () => _takeManualControl(delta: -1),
                    icon: const Icon(Icons.skip_previous, size: 20),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    tooltip: _paused ? 'Play' : 'Pause',
                    onPressed: () {
                      setState(() {
                        _paused = !_paused;
                        if (!_paused) _startTimer();
                      });
                    },
                    icon: Icon(_paused ? Icons.play_arrow : Icons.pause, size: 20),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    tooltip: 'Next',
                    onPressed: () => _takeManualControl(delta: 1),
                    icon: const Icon(Icons.skip_next, size: 20),
                    visualDensity: VisualDensity.compact,
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      '${_index + 1}/${widget.slides.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextAd extends StatelessWidget {
  const _TextAd({required this.slide});

  final AdSlide slide;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: slide.color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    slide.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    slide.subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

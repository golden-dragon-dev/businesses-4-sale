import 'dart:async';

import 'package:flutter/material.dart';
import 'package:businesses_4_sale/config/app_config.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';

class AdSlide {
  const AdSlide({
    required this.title,
    required this.subtitle,
    this.color = AppColors.red,
  });

  final String title;
  final String subtitle;
  final Color color;
}

/// Rotating advertisement / breaking-news strip (≈1/6 screen, 5s interval).
class AdBanner extends StatefulWidget {
  const AdBanner({
    super.key,
    this.slides = const [
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
  bool _enlarged = false;

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
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _go(int delta) {
    if (widget.slides.isEmpty) return;
    final next = (_index + delta) % widget.slides.length;
    final target = next < 0 ? widget.slides.length - 1 : next;
    _controller.animateToPage(
      target,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final baseHeight = (screenHeight / 6).clamp(96.0, 160.0);
    final height = _enlarged ? baseHeight * 2 : baseHeight;

    return SizedBox(
      height: height,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _paused = true;
                  _enlarged = true;
                });
              },
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.slides.length,
                onPageChanged: (value) => setState(() => _index = value),
                itemBuilder: (context, index) {
                  final slide = widget.slides[index];
                  return ColoredBox(
                    color: slide.color,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
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
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  slide.subtitle,
                                  maxLines: _enlarged ? 4 : 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          ColoredBox(
            color: AppColors.lightGrey,
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Previous',
                    onPressed: () => _go(-1),
                    icon: const Icon(Icons.skip_previous, size: 20),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    tooltip: _paused ? 'Play' : 'Pause',
                    onPressed: () {
                      setState(() {
                        _paused = !_paused;
                        if (!_paused) {
                          _enlarged = false;
                          _startTimer();
                        }
                      });
                    },
                    icon: Icon(_paused ? Icons.play_arrow : Icons.pause, size: 20),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    tooltip: 'Next',
                    onPressed: () => _go(1),
                    icon: const Icon(Icons.skip_next, size: 20),
                    visualDensity: VisualDensity.compact,
                  ),
                  const Spacer(),
                  if (_enlarged)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _enlarged = false;
                          _paused = false;
                          _startTimer();
                        });
                      },
                      child: const Text('Back'),
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

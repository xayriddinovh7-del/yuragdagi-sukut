import 'package:flutter/material.dart';

// ─── Shimmer Placeholder ───────────────────────────────────────────────────────
class ShimmerPlaceholder extends StatefulWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const ShimmerPlaceholder({
    super.key,
    required this.height,
    this.width,
    this.borderRadius = 0,
  });

  @override
  State<ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: false);
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Container(
          height: widget.height,
          width: widget.width ?? double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: const [
                Color(0xFF1A1A2E),
                Color(0xFF2A2A42),
                Color(0xFF2E2B50),
                Color(0xFF2A2A42),
                Color(0xFF1A1A2E),
              ],
              stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
            ),
          ),
        );
      },
    );
  }
}

// ─── Cinematic Image Widget ────────────────────────────────────────────────────
class CinematicImage extends StatelessWidget {
  final String url;
  final double height;
  final Color bgColor;
  final double topPurpleTint;

  const CinematicImage({
    super.key,
    required this.url,
    required this.height,
    required this.bgColor,
    this.topPurpleTint = 0.20,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          // Base image
          Positioned.fill(
            child: Image.asset(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF1A1A2E),
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.white24,
                  size: 48,
                ),
              ),
            ),
          ),
          // Bottom gradient fade to background
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    bgColor.withValues(alpha: 0.7),
                    bgColor,
                  ],
                  stops: const [0.0, 0.35, 0.75, 1.0],
                ),
              ),
            ),
          ),
          // Top purple tint overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF9B59B6).withValues(alpha: topPurpleTint),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

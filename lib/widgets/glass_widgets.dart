import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'water_drop_ripple.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Harmonized color tokens used across all glass widgets
// ─────────────────────────────────────────────────────────────────────────────
class _GlassPalette {
  static Color ripple(Color accent) =>
      Color.lerp(accent, const Color(0xFFEC4899), 0.35)!
          .withValues(alpha: 0.85);

  static Color glow(Color accent) => accent.withValues(alpha: 0.30);
  static Color border(Color accent, bool active) => active
      ? accent.withValues(alpha: 0.65)
      : Colors.white.withValues(alpha: 0.12);
}

// ─── Glass Card ───────────────────────────────────────────────────────────────
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double sigmaX;
  final double sigmaY;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double bgOpacity;
  final double borderOpacity;
  final Color? glowColor;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.sigmaX = 20,
    this.sigmaY = 20,
    this.padding,
    this.margin,
    this.bgOpacity = 0.08,
    this.borderOpacity = 0.15,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isLight = themeData.brightness == Brightness.light;
    final glow = glowColor ?? const Color(0xFF9B59B6);

    // Dynamically adjust opacities for light/sepia themes to ensure high readability
    final resolvedBgOpacity = isLight
        ? (bgOpacity == 0.08 ? 0.72 : bgOpacity)
        : bgOpacity;
    final resolvedBorderOpacity = isLight
        ? (borderOpacity == 0.15 ? 0.50 : borderOpacity)
        : borderOpacity;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: glow.withValues(alpha: isLight ? 0.06 : 0.18),
            blurRadius: 48,
            spreadRadius: -4,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isLight ? 0.08 : 0.28),
            blurRadius: 64,
            offset: const Offset(0, 28),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: resolvedBgOpacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: isLight
                    ? Colors.white.withValues(alpha: resolvedBorderOpacity)
                    : Colors.white.withValues(alpha: resolvedBorderOpacity),
                width: 1.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─── Glass Button (with water-drop ripple) ────────────────────────────────────
class GlassButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color? accentColor;
  final bool selected;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  const GlassButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.accentColor,
    this.selected = false,
    this.fontSize = 13,
    this.padding,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _scaleCtrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _scaleCtrl.forward();
  void _onTapUp(_) => _scaleCtrl.reverse();
  void _onTapCancel() => _scaleCtrl.reverse();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isLight = themeData.brightness == Brightness.light;
    final accent = widget.accentColor ?? themeData.colorScheme.primary;
    final active = widget.selected || _hovered;

    // High contrast styling for light/sepia themes when inactive
    final inactiveTextColor = isLight
        ? themeData.colorScheme.onSurface.withValues(alpha: 0.72)
        : Colors.white.withValues(alpha: 0.80);
    final inactiveIconColor = isLight
        ? themeData.colorScheme.onSurface.withValues(alpha: 0.58)
        : Colors.white.withValues(alpha: 0.65);
    final inactiveBg = isLight
        ? Colors.black.withValues(alpha: 0.04)
        : Colors.white.withValues(alpha: 0.06);
    final inactiveBorder = isLight
        ? Colors.black.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.12);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: ScaleTransition(
          scale: _scale,
          child: WaterDropRipple(
            rippleColor: _GlassPalette.ripple(accent),
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                // Harmonized: active shows a gradient shimmer
                gradient: active
                    ? LinearGradient(
                        colors: [
                          accent.withValues(alpha: 0.28),
                          _GlassPalette.ripple(accent).withValues(alpha: 0.14),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: active ? null : inactiveBg,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: active ? _GlassPalette.border(accent, active) : inactiveBorder,
                  width: 1.5,
                ),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: _GlassPalette.glow(accent),
                          blurRadius: 22,
                          spreadRadius: -2,
                        )
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: 15,
                      color: active ? accent : inactiveIconColor,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Flexible(
                    child: Text(
                      widget.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: widget.fontSize,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                        color: active ? accent : inactiveTextColor,
                        letterSpacing: active ? 0.3 : 0,
                      ),
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

// ─── Icon Glass Pill Button (with water-drop ripple) ──────────────────────────
class GlassPillIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  final String? tooltip;

  const GlassPillIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.color,
    this.tooltip,
  });

  @override
  State<GlassPillIconButton> createState() => _GlassPillIconButtonState();
}

class _GlassPillIconButtonState extends State<GlassPillIconButton>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _scaleCtrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isLight = themeData.brightness == Brightness.light;
    
    // Resolve dynamic colors for light/sepia contrast
    final defaultIconColor = isLight
        ? themeData.colorScheme.onSurface.withValues(alpha: 0.85)
        : Colors.white.withValues(alpha: 0.88);
    final iconColor = widget.color ?? defaultIconColor;

    final rippleColor = widget.color != null
        ? _GlassPalette.ripple(widget.color!)
        : const Color(0xFFAB68D0);

    final pillBg = isLight
        ? Colors.black.withValues(alpha: _hovered ? 0.06 : 0.03)
        : Colors.white.withValues(alpha: _hovered ? 0.14 : 0.07);
    final pillBorderColor = isLight
        ? Colors.black.withValues(alpha: _hovered ? 0.20 : 0.08)
        : Colors.white.withValues(alpha: _hovered ? 0.28 : 0.11);

    return Tooltip(
      message: widget.tooltip ?? '',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTapDown: (_) => _scaleCtrl.forward(),
          onTapUp: (_) => _scaleCtrl.reverse(),
          onTapCancel: () => _scaleCtrl.reverse(),
          child: ScaleTransition(
            scale: _scale,
            child: WaterDropRipple(
              rippleColor: rippleColor,
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: _hovered && !isLight
                      ? LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.18),
                            Colors.white.withValues(alpha: 0.08),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : _hovered && isLight
                          ? LinearGradient(
                              colors: [
                                Colors.black.withValues(alpha: 0.08),
                                Colors.black.withValues(alpha: 0.02),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                  color: _hovered ? null : pillBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: pillBorderColor,
                    width: 1.2,
                  ),
                  boxShadow: _hovered
                      ? [
                          BoxShadow(
                            color: isLight
                                ? Colors.black.withValues(alpha: 0.05)
                                : Colors.white.withValues(alpha: 0.08),
                            blurRadius: 12,
                          )
                        ]
                      : [],
                ),
                child: Icon(widget.icon, size: 18, color: iconColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Glow Divider Line ─────────────────────────────────────────────────────────
class GlowLine extends StatelessWidget {
  final double width;
  final Color color;

  const GlowLine({super.key, this.width = 60, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 1.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            color.withValues(alpha: 0.8),
            color,
            color.withValues(alpha: 0.8),
            Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.45),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

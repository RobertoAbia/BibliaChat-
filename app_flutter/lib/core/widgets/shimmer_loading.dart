import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_theme.dart';

/// Colores base para shimmer - con contraste visible en tema claro
class ShimmerColors {
  static Color get baseColor => const Color(0xFFD8DEE8);  // Gris-azulado claro
  static Color get highlightColor => const Color(0xFFEDF2F8);  // Casi blanco
  static Color get goldBaseColor => AppTheme.primaryColor.withOpacity(0.15);
  static Color get goldHighlightColor => AppTheme.primaryColor.withOpacity(0.3);
}

/// Wrapper base para efectos shimmer
class ShimmerWrapper extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool useGold;

  const ShimmerWrapper({
    super.key,
    required this.child,
    this.isLoading = true,
    this.useGold = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return Shimmer.fromColors(
      baseColor: useGold ? ShimmerColors.goldBaseColor : ShimmerColors.baseColor,
      highlightColor:
          useGold ? ShimmerColors.goldHighlightColor : ShimmerColors.highlightColor,
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
}

/// Shimmer para texto (línea simple)
class ShimmerText extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerText({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 4,
  });

  /// Línea corta (título)
  factory ShimmerText.short({double height = 20}) {
    return ShimmerText(
      width: 120,
      height: height,
      borderRadius: 4,
    );
  }

  /// Línea mediana
  factory ShimmerText.medium({double height = 16}) {
    return ShimmerText(
      width: 200,
      height: height,
      borderRadius: 4,
    );
  }

  /// Línea larga (párrafo)
  factory ShimmerText.long({double height = 14}) {
    return ShimmerText(
      width: double.infinity,
      height: height,
      borderRadius: 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ShimmerColors.baseColor,
      highlightColor: ShimmerColors.highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Shimmer para avatar circular
class ShimmerAvatar extends StatelessWidget {
  final double size;

  const ShimmerAvatar({
    super.key,
    this.size = 48,
  });

  /// Avatar pequeño
  factory ShimmerAvatar.small() => const ShimmerAvatar(size: 32);

  /// Avatar mediano
  factory ShimmerAvatar.medium() => const ShimmerAvatar(size: 48);

  /// Avatar grande
  factory ShimmerAvatar.large() => const ShimmerAvatar(size: 64);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ShimmerColors.baseColor,
      highlightColor: ShimmerColors.highlightColor,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size / 4),
        ),
      ),
    );
  }
}

/// Shimmer para tarjeta completa
class ShimmerCard extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const ShimmerCard({
    super.key,
    this.width,
    this.height = 120,
    this.borderRadius = 20,
    this.margin,
  });

  /// Card pequeña
  factory ShimmerCard.small({EdgeInsetsGeometry? margin}) {
    return ShimmerCard(
      height: 80,
      borderRadius: 16,
      margin: margin,
    );
  }

  /// Card mediana (típica)
  factory ShimmerCard.medium({EdgeInsetsGeometry? margin}) {
    return ShimmerCard(
      height: 120,
      borderRadius: 20,
      margin: margin,
    );
  }

  /// Card grande (verse card)
  factory ShimmerCard.large({EdgeInsetsGeometry? margin}) {
    return ShimmerCard(
      height: 180,
      borderRadius: 20,
      margin: margin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ShimmerColors.baseColor,
      highlightColor: ShimmerColors.highlightColor,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Shimmer para lista de items
class ShimmerList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final double spacing;
  final double borderRadius;
  final bool showAvatar;
  final EdgeInsetsGeometry? padding;
  final Axis scrollDirection;

  const ShimmerList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.spacing = 12,
    this.borderRadius = 16,
    this.showAvatar = true,
    this.padding,
    this.scrollDirection = Axis.vertical,
  });

  /// Lista de chat (burbujas)
  factory ShimmerList.chat({int itemCount = 6}) {
    return ShimmerList(
      itemCount: itemCount,
      itemHeight: 60,
      spacing: 16,
      showAvatar: false,
    );
  }

  /// Lista de contenido (cards)
  factory ShimmerList.content({int itemCount = 3}) {
    return ShimmerList(
      itemCount: itemCount,
      itemHeight: 100,
      spacing: 16,
      showAvatar: true,
    );
  }

  /// Lista horizontal (chips, tabs)
  factory ShimmerList.horizontal({int itemCount = 4}) {
    return ShimmerList(
      itemCount: itemCount,
      itemHeight: 40,
      spacing: 12,
      scrollDirection: Axis.horizontal,
      showAvatar: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ShimmerColors.baseColor,
      highlightColor: ShimmerColors.highlightColor,
      child: scrollDirection == Axis.vertical
          ? Column(
              children: List.generate(itemCount, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: index < itemCount - 1 ? spacing : 0),
                  child: _buildItem(),
                );
              }),
            )
          : SizedBox(
              height: itemHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: padding,
                itemCount: itemCount,
                separatorBuilder: (_, __) => SizedBox(width: spacing),
                itemBuilder: (_, __) => _buildHorizontalItem(),
              ),
            ),
    );
  }

  Widget _buildItem() {
    return Container(
      height: itemHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (showAvatar) ...[
            Container(
              width: itemHeight - 32,
              height: itemHeight - 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular((itemHeight - 32) / 4),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalItem() {
    return Container(
      width: 100,
      height: itemHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Shimmer para el verse card (especial)
class ShimmerVerseCard extends StatelessWidget {
  const ShimmerVerseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ShimmerColors.baseColor,
      highlightColor: ShimmerColors.highlightColor,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Container(
              height: 24,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),
            // Text lines
            Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 16,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            // Reference
            Container(
              height: 14,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer para content card (devocional, oración)
class ShimmerContentCard extends StatelessWidget {
  const ShimmerContentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ShimmerColors.baseColor,
      highlightColor: ShimmerColors.highlightColor,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 18,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            // Chevron placeholder
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer para el week calendar
class ShimmerWeekCalendar extends StatelessWidget {
  const ShimmerWeekCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ShimmerColors.baseColor,
      highlightColor: ShimmerColors.highlightColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            return Column(
              children: [
                Container(
                  width: 20,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

/// Convenience class with static factory methods for shimmer widgets
class ShimmerLoading {
  ShimmerLoading._();

  /// Create a shimmer card placeholder
  static Widget card({double height = 120, double? width}) {
    return ShimmerCard(height: height, width: width);
  }

  /// Create a shimmer text placeholder
  static Widget text({double width = double.infinity, double height = 16}) {
    return ShimmerText(width: width, height: height);
  }

  /// Create a shimmer list placeholder
  static Widget list({int itemCount = 5}) {
    return ShimmerList(itemCount: itemCount);
  }

  /// Create a shimmer avatar placeholder
  static Widget avatar({double size = 48}) {
    return ShimmerAvatar(size: size);
  }
}

/// Shimmer para botón con efecto especial
class ShimmerButton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerButton({
    super.key,
    this.width = double.infinity,
    this.height = 56,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ShimmerColors.goldBaseColor,
      highlightColor: ShimmerColors.goldHighlightColor,
      period: const Duration(milliseconds: 1800),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

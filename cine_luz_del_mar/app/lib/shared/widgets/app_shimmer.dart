import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Placeholder de carga con efecto shimmer coherente con el tema monocromo.
class AppShimmer extends StatelessWidget {
  const AppShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.radius = 8,
  });

  const AppShimmer.circle({super.key, double size = 48})
    : width = size,
      height = size,
      radius = 999;

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: scheme.surfaceContainer,
      highlightColor: scheme.surfaceContainerHigh,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Lista vertical de shimmers para estados de carga de listados.
class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key, this.itemCount = 6, this.itemHeight = 88});

  final int itemCount;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => AppShimmer(height: itemHeight, radius: 12),
    );
  }
}

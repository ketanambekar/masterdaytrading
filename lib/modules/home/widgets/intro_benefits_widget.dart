import 'package:flutter/material.dart';
import 'package:masterdaytrading/theme/app_colors.dart';

class IntroBenefitsWidget extends StatelessWidget {
  final List<String> benefits;

  const IntroBenefitsWidget({super.key, required this.benefits});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final backgroundColor = isDark ? Colors.black.withOpacity(0.9) : Colors.white.withOpacity(0.9);
    final borderColor = isDark ? Colors.white24 : Colors.black12;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🎯 Main Heading
            AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: 1,
              child: Text(
                'Sikh lijiye meri secret strategies\njo aapka trading career badal ke rakh degi!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'cabin',
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🎯 List of Benefits
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: benefits
                  .asMap()
                  .entries
                  .map((entry) => _AnimatedBenefitTile(
                text: entry.value,
                delay: entry.key * 200,
                isDark: isDark,
                textColor: textColor,
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedBenefitTile extends StatelessWidget {
  final String text;
  final int delay;
  final bool isDark;
  final Color textColor;

  const _AnimatedBenefitTile({
    required this.text,
    required this.delay,
    required this.isDark,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 5000),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle,
                color: isDark ? Colors.greenAccent : Colors.green, size: 20),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontFamily: 'cabin',
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
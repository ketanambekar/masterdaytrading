import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'offer_timer_controller.dart';

class BottomOfferBar extends StatefulWidget {
  final VoidCallback onPressed;

  const BottomOfferBar({super.key, required this.onPressed});

  @override
  State<BottomOfferBar> createState() => _BottomOfferBarState();
}

class _BottomOfferBarState extends State<BottomOfferBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  late final OfferTimerController _timerController;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _shakeAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    // Use Get.find to avoid multiple instances
    _timerController = Get.find<OfferTimerController>();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Prevent overflow
                  children: [
                    const Text(
                      "₹10,000.00",
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Now ₹ 999.00",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                        children: [
                          const TextSpan(text: "Offer expires in "),
                          TextSpan(
                            text: _timerController.formattedTime,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Shaking Button
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: ElevatedButton(
                      onPressed: widget.onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 54, vertical: 24),
                      ),
                      child: const Text(
                        "Buy Now",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}

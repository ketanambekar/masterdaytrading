import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masterdaytrading/services/buy_now/check_out_controller.dart';

final checkoutController = Get.put(CheckoutController());

void showCheckoutSheet() {
  Get.bottomSheet(
    Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // 🔹 Background blur and dim
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),

          // 🔹 Bottom sheet content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔺 Close button
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 🔸 Headline
                    Text("Complete Your Purchase",
                        style: GoogleFonts.poppins(
                            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))
                        .animate().fade(duration: 400.ms).slideY(begin: 0.2),

                    const SizedBox(height: 8),

                    Text(
                      "Unlock lifetime access to premium trading strategies, tools & mentorship. "
                          "Join 1500+ successful traders.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                    ),

                    const SizedBox(height: 30),

                    // 🔸 Input Fields
                    _inputField("Full Name", checkoutController.nameCtrl, Icons.person),
                    const SizedBox(height: 12),
                    _inputField("Email Address", checkoutController.emailCtrl, Icons.email),
                    const SizedBox(height: 12),
                    _inputField("Mobile Number", checkoutController.phoneCtrl, Icons.phone),

                    const SizedBox(height: 20),

                    // 🔸 Terms & Conditions
                    Row(
                      children: [
                        const Icon(Icons.privacy_tip_outlined, color: Colors.white60, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "By continuing, you agree to our Terms & Conditions and Privacy Policy.",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // 🔹 Full Width Pay Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: checkoutController.onPayPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 10,
                        ),
                        child: Text("Pay Now",
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                      ).animate().fade().scale(delay: 200.ms),
                    ),
                    const SizedBox(height: 10),

                    Divider(color: Colors.white24),

                    const SizedBox(height: 12),

                    Text("Already purchased?",
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),

                    const SizedBox(height: 8),

                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to login or open login modal
                        Get.back(); // Optional: close current popup
                        // showLoginSheet(); // Define your login sheet/page here
                      },
                      child: Text("Login to access your course",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                          )),
                    ),

                    const SizedBox(height: 20),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

Widget _inputField(String hint, TextEditingController ctrl, IconData icon) {
  return TextField(
    controller: ctrl,
    keyboardType: hint.contains("Mobile") ? TextInputType.phone : TextInputType.text,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  ).animate().fade().slideY(begin: 0.3);
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:html' as html;

class CheckoutController extends GetxController {
  late Razorpay razorpay;
  final name = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void onPayPressed() {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final phone = phoneCtrl.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      Get.snackbar("Missing Information", "Please fill in all fields.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    final phoneRegex = RegExp(r"^[6-9]\d{9}$");

    if (!emailRegex.hasMatch(email)) {
      Get.snackbar("Invalid Email", "Please enter a valid email address.",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (!phoneRegex.hasMatch(phone)) {
      Get.snackbar("Invalid Mobile", "Enter a valid 10-digit mobile number.",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    // All good, proceed to payment
    Get.back();
    if (kIsWeb) {
      initiateWebPayment();
    } else {
      initiatePayment(); // For mobile (razorpay_flutter)
    }
  }

  void initiateWebPayment() {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final phone = phoneCtrl.text.trim();

    final script = html.ScriptElement()
      ..type = 'text/javascript'
      ..innerHtml = '''
      var options = {
        "key": "YOUR_RAZORPAY_KEY", // Replace with your Razorpay key
        "amount": 100,
        "currency": "INR",
        "name": "Master Day Trading",
        "description": "Course Purchase",
        "handler": function (response) {
          alert('Payment Successful! Payment ID: ' + response.razorpay_payment_id);
          // TODO: Call backend/API to verify and send access email
        },
        "prefill": {
          "name": "$name",
          "email": "$email",
          "contact": "$phone"
        },
        "theme": {
          "color": "#0D47A1"
        }
      };
      var rzp = new Razorpay(options);
      rzp.open();
    ''';

    html.document.body!.append(script);
  }


  void initiatePayment() {
    var options = {
      'key': 'YOUR_RAZORPAY_KEY',
      'amount': 100, // ₹499.00 (in paise)
      'name': 'Master Day Trading',
      'description': 'Course Purchase',
      'prefill': {
        'contact': phoneCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
        'name': nameCtrl.text.trim(),
      },
      'theme': {
        'color': '#0D47A1',
      },
      'modal': {
        'ondismiss': () {
          Get.snackbar("Payment Cancelled", "You exited the payment screen.");
        }
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      Get.snackbar("Error", "Payment gateway error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // 🔄 Call backend API to verify & store payment
    // ✅ Then send email/SMS with course access
    Get.snackbar("Payment Successful", "Transaction ID: ${response.paymentId}",
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("Payment Failed", "${response.message}",
        backgroundColor: Colors.redAccent, colorText: Colors.white);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("Wallet Selected", "Wallet: ${response.walletName}");
  }
}

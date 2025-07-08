import 'package:flutter/material.dart';

class FAQSection extends StatelessWidget {
  const FAQSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final List<_FAQ> faqs = [
      _FAQ(question: 'Who is this course for?'),
      _FAQ(question: 'What is covered in the course?'),
      _FAQ(question: 'Is this course live or recorded?'),
      _FAQ(
        question: 'Do I need prior trading experience?',
        answer:
        'No, prior experience is not required. The course starts from the basics and is beginner-friendly.',
      ),
      _FAQ(question: 'Do I get lifetime access?'),
      _FAQ(
        question: 'Why did you create an index options course if you discourage them?',
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      width: double.infinity,
      color: Colors.grey.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: isMobile ? 22 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 4,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),
          ...faqs.map((faq) => _buildTile(faq)).toList(),
        ],
      ),
    );
  }

  Widget _buildTile(_FAQ faq) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: ExpansionTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            faq.question,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          children: [
            if (faq.answer != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  faq.answer!,
                  style: const TextStyle(color: Colors.black87, height: 1.4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FAQ {
  final String question;
  final String? answer;

  _FAQ({required this.question, this.answer});
}

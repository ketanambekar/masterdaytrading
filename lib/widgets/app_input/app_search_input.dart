// widgets/app_search_input.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterdaytrading/modules/home/home_controller.dart';

class AppSearchInput extends StatelessWidget {
  final String label;
  final HomeController controller;

  const AppSearchInput({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          onChanged: controller.search,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Obx(() {
          final results = controller.filteredItems;
          if (results.isEmpty) return const SizedBox();

          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: results.length,
              itemBuilder: (context, index) {
                final item = results[index];
                return ListTile(
                  title: Text(item['name'] ?? ''),
                  subtitle: Text(item['trading_symbol'] ?? ''),
                  onTap: () {
                    controller.selectItem(item);
                    textController.text = item['name'] ?? '';
                    FocusScope.of(context).unfocus();
                  },
                );
              },
            ),
          );
        }),
      ],
    );
  }
}

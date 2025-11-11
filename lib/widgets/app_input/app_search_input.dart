// widgets/app_search_input.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterdaytrading/modules/home/home_controller.dart';
import 'package:masterdaytrading/routes/app_pages.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          onChanged: controller.search,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          cursorColor: Colors.amberAccent,
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: true,
            fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Colors.amberAccent, width: 1.2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Obx(() {
          final results = controller.filteredItems;
          if (results.isEmpty) return const SizedBox();

          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF121212) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
              ),
              boxShadow: [
                if (isDark)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                else
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: results.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
              ),
              itemBuilder: (context, index) {
                final item = results[index];
                return ListTile(
                  title: Text(
                    item['name'] ?? '',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    item['trading_symbol'] ?? '',
                    style: TextStyle(
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),
                  onTap: () {
                    controller.selectItem(item);
                    textController.text = item['name'] ?? '';
                    Get.toNamed(Routes.chartPage);
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

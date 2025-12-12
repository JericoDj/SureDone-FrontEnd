import 'package:flutter/material.dart';

import '../../../../core/utils/colors.dart';

class CustomHomeAppBar extends StatelessWidget {
  final double? height;

  const CustomHomeAppBar({
    super.key,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final double resolvedHeight =
        height ?? MediaQuery.sizeOf(context).height * 0.12; // default height

    return SizedBox(
      height: resolvedHeight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// LOGO
            GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: resolvedHeight * 0.34,
                child: Image.asset("assets/SureDoneLogo-homebutton.png"),
              ),
            ),

            /// SEARCH
            Expanded(
              child: Container(
                height: resolvedHeight * 0.45,
                margin: const EdgeInsets.symmetric(horizontal:8),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, size: 20, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      "Search services...",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            /// ACCOUNT BUTTON
            Container(
              padding: const EdgeInsets.all(2), // thickness of border
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryCyan,
                  width: 2,
                ),
              ),
              child: const CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.primaryCyan,
                child: Icon(Icons.person, color: Colors.white),
              ),
            )

          ],
        ),
      ),
    );
  }
}

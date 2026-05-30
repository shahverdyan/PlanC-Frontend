import 'package:flutter/material.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';

class CustomDescriptiveCard extends StatelessWidget {

  final String title;
  final TextStyle? titleStyle;
  final String description;
  final TextStyle? descrStyle;
  final Widget asset;
  final ShapeBorder? shapeBorder;
  final EdgeInsets padd;
  final Color? backgroundColor;
  final double elevation;
  
  const CustomDescriptiveCard({
    super.key,
    required this.title,
    this.titleStyle = const TextStyle(fontSize: 20, color: AppColors.neutral0, fontFamily: 'Helvetica', fontWeight: FontWeight.w700),
    required this.description,
    this.descrStyle = const TextStyle(fontSize: 16, color: AppColors.neutral0),
    required this.asset,
    this.shapeBorder = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
    this.padd = const EdgeInsets.all(16.0),
    this.backgroundColor = AppColors.orange500,
    this.elevation = 4.0,

  });

@override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: backgroundColor,
      shape: shapeBorder,
      child: Padding(
        padding: padd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                asset,
                const SizedBox(width: 12.0),
                Flexible(
                  child: Text(
                    title,
                    style: titleStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: descrStyle,
            )
          ],
        ),
      ),
    );
  }
}
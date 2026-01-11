import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';

/// 导航栏项组件
///
/// 用于自定义 NavigationRail 的导航项外观
class NavRailItem extends StatelessWidget {
  const NavRailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: AppSizes.navRailWidth - 16,
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.spacingMedium,
          horizontal: AppSizes.spacingSmall,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.2)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppSizes.navIconSize,
              color: isSelected
                  ? AppTheme.navRailSelectedColor
                  : AppTheme.textSecondary,
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            Text(
              label,
              style: TextStyle(
                fontSize: AppSizes.navLabelSize,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppTheme.navRailSelectedColor
                    : AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

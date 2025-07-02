import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// App icons class containing SVG icons and standardized sizes
class AppIcons {
  static const String _basePath = 'assets/icons/';

  // SVG icon paths
  static const String doctor = '${_basePath}doctor.svg';
  static const String person = '${_basePath}person.svg';
  static const String video = '${_basePath}video.svg';
  static const String mike = '${_basePath}mike.svg';
  static const String test = '${_basePath}test.svg';
  static const String phone = '${_basePath}phone.svg';

  // Icon sizes
  static const double small = 16.0;
  static const double medium = 24.0;
  static const double large = 32.0;
  static const double xl = 48.0;
  static const double doubleXl = 64.0;

  // SVG widgets
  static Widget doctorIcon({
    IconSize size = IconSize.medium,
    double? width,
    double? height,
    Color? color,
  }) {
    final double iconSize = _getIconSize(size);
    return SvgPicture.asset(
      doctor,
      width: width ?? iconSize,
      height: height ?? iconSize,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget personIcon({
    IconSize size = IconSize.medium,
    double? width,
    double? height,
    Color? color,
  }) {
    final double iconSize = _getIconSize(size);
    return SvgPicture.asset(
      person,
      width: width ?? iconSize,
      height: height ?? iconSize,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget videoIcon({
    IconSize size = IconSize.medium,
    double? width,
    double? height,
    Color? color,
  }) {
    final double iconSize = _getIconSize(size);
    return SvgPicture.asset(
      video,
      width: width ?? iconSize,
      height: height ?? iconSize,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget mikeIcon({
    IconSize size = IconSize.medium,
    double? width,
    double? height,
    Color? color,
  }) {
    final double iconSize = _getIconSize(size);
    return SvgPicture.asset(
      mike,
      width: width ?? iconSize,
      height: height ?? iconSize,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget testIcon({
    IconSize size = IconSize.medium,
    double? width,
    double? height,
    Color? color,
  }) {
    final double iconSize = _getIconSize(size);
    return SvgPicture.asset(
      test,
      width: width ?? iconSize,
      height: height ?? iconSize,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget phoneIcon({
    IconSize size = IconSize.medium,
    double? width,
    double? height,
    Color? color,
  }) {
    final double iconSize = _getIconSize(size);
    return SvgPicture.asset(
      phone,
      width: width ?? iconSize,
      height: height ?? iconSize,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  /// Helper method to get icon size based on the enum
  static double _getIconSize(IconSize size) {
    switch (size) {
      case IconSize.small:
        return small;
      case IconSize.medium:
        return medium;
      case IconSize.large:
        return large;
      case IconSize.xl:
        return xl;
      case IconSize.doubleXl:
        return doubleXl;
    }
  }
}

/// Icon size enum for standardized icon sizing
enum IconSize { small, medium, large, xl, doubleXl }

class ProfileIcons {
  static const String _basePath = 'assets/icons/profile_icons/';

  static const String profileUnselected = '${_basePath}profile_unselected.png';
  static const String profileSelected = '${_basePath}profile_selected.png';
  static const String conditionUnselected =
      '${_basePath}condition_unselected.png';
  static const String conditionSelected = '${_basePath}condition_selected.png';
  static const String careUnselected = '${_basePath}care_unselected.png';
  static const String careSelected = '${_basePath}care_selected.png';
  static const String familySelected = '${_basePath}family_selected.png';
  static const String familyUnselected = '${_basePath}family_unselected.png';
  static const String ausaContentSelected =
      '${_basePath}ausa_content_selected.png';
  static const String ausaContentUnselected =
      '${_basePath}ausa_content_unselected.png';

  static const String ausaLogo = '${_basePath}ausa_logo.png';
}

import 'package:flutter/material.dart';

class AppIcons {
  static Widget getIcon(String iconName, {double size = 24, Color? color}) {
    IconData iconData;
    
    switch (iconName) {
      case 'eye':
        iconData = Icons.visibility;
        break;
      case 'zap':
        iconData = Icons.flash_on;
        break;
      case 'git_compare':
        iconData = Icons.compare_arrows;
        break;
      case 'history':
        iconData = Icons.history;
        break;
      case 'settings':
        iconData = Icons.settings;
        break;
      case 'share':
        iconData = Icons.share;
        break;
      case 'camera':
        iconData = Icons.camera_alt;
        break;
      default:
        iconData = Icons.help_outline;
    }
    
    return Icon(
      iconData,
      size: size,
      color: color,
    );
  }
} 
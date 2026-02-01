import 'package:flutter/widgets.dart';

extension ResponsiveContext on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width < 600;
  bool get isTablet {
    final w = MediaQuery.of(this).size.width;
    return w >= 600 && w < 1150;
  }
  bool get isDesktop => MediaQuery.of(this).size.width >= 1150;
}

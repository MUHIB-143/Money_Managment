/// Standardized spacing system for consistent layout
class AppSpacing {
  // Base spacing unit (8px)
  static const double unit = 8.0;

  // Spacing values
  static const double xs = unit * 0.5; // 4px
  static const double sm = unit; // 8px
  static const double md = unit * 2; // 16px
  static const double lg = unit * 3; // 24px
  static const double xl = unit * 4; // 32px
  static const double xxl = unit * 6; // 48px

  // Screen padding
  static const double screenPadding = md; // 16px
  static const double cardPadding = md; // 16px
  static const double sectionPadding = lg; // 24px

  // Vertical spacing between elements
  static const double verticalXs = xs; // 4px
  static const double verticalSm = sm; // 8px
  static const double verticalMd = md; // 16px
  static const double verticalLg = lg; // 24px
  static const double verticalXl = xl; // 32px

  // List item spacing
  static const double listItemGap = sm; // 8px between cards
  static const double listItemPadding = md; // 16px inside cards

  // Section spacing
  static const double sectionGap = lg; // 24px between sections
}

/// Standardized border radius
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double full = 9999.0; // Fully rounded
}

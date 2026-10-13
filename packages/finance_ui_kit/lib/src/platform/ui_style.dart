import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Which component set to render. Material on Android (and web for now),
/// Cupertino on iOS once that set exists.
enum UiStyle {
  material,
  cupertino;

  static UiStyle of(BuildContext context) => forPlatform(defaultTargetPlatform);

  static UiStyle forPlatform(TargetPlatform platform) => switch (platform) {
    TargetPlatform.iOS || TargetPlatform.macOS => UiStyle.cupertino,
    _ => UiStyle.material,
  };
}

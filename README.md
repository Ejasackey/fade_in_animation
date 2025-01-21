<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# FadeInAnimation
Animate a single widget or multiple widgets beautifully with `FadeInAnimation`

## Preview

TODO: List what your package can do. Maybe include images, gifs, or videos.


## Simple Usage

Import `fade_in_animation.dart`

```dart
import "package:fade_in_animation/fade_in_animation.dart";
```

Wrap the target widget with `FadeInAnimation`
```dart
FadeInAnimation(
    child: SomeWidget(),
)
```

## Advanced Usage
This is a higly customizable animation widget, so feel free to play with the fields.
Description for each field is included, hover on the fields to learn more about them.
```dart
FadeInAnimation(
    key: GlobalKey(),
    delayIndex: 1,
    forwardCurve: Curves.easeOutCubic,
    animationType: AnimationType.scaleTranslate,
    scaleFactor: .9,
    animationDuration: 1000,
    direction: AnimationDirection.rightward,
    reverse: state == AuthFieldState.loginOff,
    child: SomeWidget(),
)
```


## Additional information
When animating multiple widgets be sure to asign the`key` field of the `FadeInAnimation` widget.

#### Don't forget to leave a like 👍

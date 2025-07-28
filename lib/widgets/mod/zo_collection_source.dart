import 'package:flutter/material.dart';
import 'package:zo_collection_animation/src/zo_collection_animation.dart';
class ZoCollectionSource extends StatefulWidget {
      /// The child widget displayed by this source .
  final Widget child;

  /// A [GlobalKey] that identifies the target widget where the collection animation ends.
  final GlobalKey destinationKey;

  /// A callback invoked after the animation completes.
  final VoidCallback onAnimationComplete;

  /// The widget used to represent the animated item (e.g., a coin).
  ///
  /// Defaults to an amber monetization icon.
  final Widget collectionWidget;

  /// Optional callback triggered on tap before starting the animation.
  final Function()? onTap;

  /// Optional animation curve to customize the movement trajectory.
  final Curve? animationCurve;

  /// Optional duration for the animation.
  final Duration? animationDuration;

  /// Optional number of items to animate.
  ///
  /// Defaults to 1 if not provided.
  final int? count;
  const ZoCollectionSource({
    super.key,
    required this.child,
    required this.destinationKey,
    required this.onAnimationComplete,
    this.collectionWidget = const Icon(
      Icons.monetization_on,
      size: 30,
      color: Colors.amber,
    ),
    this.onTap,
    this.animationCurve,
    this.animationDuration,
    this.count,
  });

  @override
  ZoCollectionSourceState createState() => ZoCollectionSourceState();
}

class ZoCollectionSourceState extends State<ZoCollectionSource> {
  void startAnimation(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final startPosition = box.localToGlobal(Offset.zero);

    final renderBox = widget.destinationKey.currentContext!.findRenderObject() as RenderBox;
    final endPosition = renderBox.localToGlobal(Offset.zero);

    AnimationEmitter.emit(
      context: context,
      start: startPosition,
      end: endPosition,
      count: widget.count ?? 1,
      onAnimationFinised: widget.onAnimationComplete,
      collectionWidget: widget.collectionWidget,
      animationCurve: widget.animationCurve,
      animationDuration: widget.animationDuration,
    );
  }

  // Método público para activar desde fuera
  void simulateTap() {
    if (widget.onTap != null) {
      widget.onTap!(); // Ejecuta el callback onTap
    }
    startAnimation(context); // Inicia la animación
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: simulateTap, // Usa el método interno
      child: widget.child,
    );
  }
}
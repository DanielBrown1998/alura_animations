import 'package:flutter/material.dart';

class CategoryTransition extends StatefulWidget {
  final String imagePath;
  final bool isHighLight;
  final Duration duration;
  const CategoryTransition(
      {super.key,
      required this.isHighLight,
      required this.imagePath,
      required this.duration});
  @override
  State<CategoryTransition> createState() => _CategoryTransitionState();
}

class _CategoryTransitionState extends State<CategoryTransition>
    with TickerProviderStateMixin {
  late AnimationController scaleAnimationController;
  late AnimationController imageColorAnimationController;

  @override
  void initState() {
    super.initState();
    scaleAnimationController = AnimationController(
        vsync: this,
        duration: widget.duration,
        lowerBound: 0.8,
        upperBound: 1.0);
    imageColorAnimationController = AnimationController(
        vsync: this, duration: widget.duration, lowerBound: 0, upperBound: 1);
    if (widget.isHighLight) {
      scaleAnimationController.repeat(
        reverse: true,
      );
      imageColorAnimationController.repeat(
        reverse: true,
      );
    } else {
      scaleAnimationController.animateTo(1);
      imageColorAnimationController.animateTo(0);
    }
  }

  @override
  void dispose() {
    scaleAnimationController.dispose();
    imageColorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCategory(
        imageColorAnimationController: imageColorAnimationController,
        scaleAnimationController: scaleAnimationController,
        pathImage: widget.imagePath);
  }
}

class AnimatedCategory extends AnimatedWidget {
  final Animation<double> scaleAnimationController;
  final Animation<double> imageColorAnimationController;
  final String pathImage;
  const AnimatedCategory(
      {super.key,
      required this.imageColorAnimationController,
      required this.scaleAnimationController,
      required this.pathImage})
      : super(
          listenable: imageColorAnimationController,
        );

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      alignment: Alignment.center,
      filterQuality: FilterQuality.medium,
      scale: scaleAnimationController,
      child: Center(
        child: Image.asset(
          pathImage,
          fit: BoxFit.fitHeight,
          color: Color.fromARGB(255, 255, 255,
              (255 * (imageColorAnimationController.value - 1).abs()).floor()),
        ),
      ),
    );
  }
}

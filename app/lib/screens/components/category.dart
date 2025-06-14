// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hyrule/controllers/api_controller.dart';
import 'package:hyrule/screens/results.dart';
import 'package:hyrule/utils/consts/categories.dart';

import '../../domain/models/entry.dart';

class Category extends StatefulWidget {
  const Category({
    super.key,
    required this.category,
    required this.isHighLight,
  });
  final String category;
  final bool isHighLight;
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> with TickerProviderStateMixin {
  final ApiController apiController = ApiController();

  late AnimationController scaleAnimationController;
  late AnimationController imageColorAnimationController;
  Future<List<Entry>> getEntries() async {
    return await apiController.getEntriesByCategory(category: widget.category);
  }

  @override
  void initState() {
    super.initState();
    scaleAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
        lowerBound: 0.8,
        upperBound: 1.0);
    imageColorAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
        lowerBound: 0,
        upperBound: 1);
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
    return Column(
      children: <Widget>[
        Flexible(
          child: InkWell(
            onTap: () async {
              await getEntries().then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Results(entries: value, category: widget.category))));
            },
            borderRadius: BorderRadius.circular(16.0),
            child: Ink(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  border:
                      Border.all(width: 2.0, color: const Color(0xFF0079CF)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 6.0,
                        color: const Color(0xFF0079CF).withOpacity(0.2),
                        blurStyle: BlurStyle.outer),
                  ]),
              child: ScaleTransition(
                alignment: Alignment.center,
                filterQuality: FilterQuality.medium,
                scale: scaleAnimationController,
                child: AnimatedBuilder(
                  animation: imageColorAnimationController,
                  builder: (context, child) => Center(
                    child: Image.asset(
                      "$imagePath${widget.category}.png",
                      fit: BoxFit.fitHeight,
                      color: Color.fromARGB(
                          255,
                          255,
                          255,
                          (255 *
                                  (imageColorAnimationController.value - 1)
                                      .abs())
                              .floor()),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(categories[widget.category]!,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: const Color(0xFF0079CF))),
        ),
      ],
    );
  }
}

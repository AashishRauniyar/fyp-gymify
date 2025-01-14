import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoadingAnimation extends StatelessWidget {
  const CustomLoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return Center(
      child: LoadingAnimationWidget.dotsTriangle(
        color: Theme.of(context).primaryColor,
        size: size * 0.09,
      ),
    );
  }
}

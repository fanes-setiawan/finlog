import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:flutter/material.dart';

class FancyFab extends StatefulWidget {
  final List<FabItem> items;

  const FancyFab({Key? key, required this.items}) : super(key: key);

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;

  final Curve _curve = Curves.easeOut;
  final double _fabHeight = 56.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget toggle() {
    return FloatingActionButton(
      backgroundColor: _buttonColor.value,
      onPressed: animate,
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        for (int i = 0; i < widget.items.length; i++)
          Visibility(
            visible: isOpened,
            child: Transform(
              transform: Matrix4.translationValues(
                0.0,
                _translateButton.value * (i),
                0.0,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: FloatingActionButton(
                  mini: false,
                  shape: const CircleBorder(),
                  backgroundColor:
                      widget.items[i].backgroundColor ?? AppColors.white,
                  onPressed: () {
                    widget.items[i].onPressed();
                    animate();
                  },
                  tooltip: widget.items[i].tooltip,
                  child: Icon(widget.items[i].icon,color: AppColors.neutral1,),
                ),
              ),
            ),
          ),
        toggle(),
      ],
    );
  }
}

class FabItem {
  final Color? backgroundColor;
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  FabItem({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
  });
}

library flutter_expand_cards;

import 'package:flutter/material.dart';

///
/// 可扩展的卡片列表，效果参考iPhone的提醒事项APP
///
/// @author luodongseu@github.com
///
class ExpandableCards extends StatefulWidget {
  @override
  _ExpandableCardsState createState() => _ExpandableCardsState();
}

class _ExpandableCardsState extends State<ExpandableCards>
    with TickerProviderStateMixin {
  bool _lockScroll = false;
  double _currentValue = 0.0;
  double _currentPos = 0.0;
  double _swiperWidth;
  double _swiperHeight;
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    print('xxxxx');
    _animationController = new AnimationController(vsync: this, value: 0.0);
    Tween<double> tween = new Tween(begin: 0.0, end: 1.0);
    _animation = tween.animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
//    widget.controller.removeListener(_onController);
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback(_getSize);
    super.didChangeDependencies();
  }

  void _getSize(_) {
    afterRender();
  }

  @mustCallSuper
  void afterRender() {
    RenderObject renderObject = context.findRenderObject();
    Size size = renderObject.paintBounds.size;
    _swiperWidth = size.width;
    _swiperHeight = size.height;
    setState(() {});
  }

  void _onPanEnd(DragEndDetails details) {
    if (_lockScroll) return;

    double velocity = details.velocity.pixelsPerSecond.dy;
  }

  void _onPanStart(DragStartDetails details) {
    if (_lockScroll) return;
    _currentValue = _animationController.value;
    _currentPos = details.globalPosition.dy;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_lockScroll) return;
    double value = _currentValue +
        (details.globalPosition.dy - _currentPos) / _swiperWidth / 2;
    _animationController.value = value;
  }

  buildItem(int index, double animationValue) {
    double offset = index * 30.0 + 10 * animationValue;
    print('offset $offset');
    return new Opacity(
      opacity: 1.0,
      child: new Transform.rotate(
        angle: 0.0,
        child: new Transform.translate(
          // key: new ValueKey<int>(index + i),
          offset: new Offset(0, offset),
          child: new Transform.scale(
            scale: 1.0,
            alignment: Alignment.centerLeft,
            child: new SizedBox(
              width: 300,
              height: 120,
              child: new Container(
                padding: EdgeInsets.all(32.0),
                height: 120,
                color: Colors.purple.withOpacity(index / 8),
                child: Text("aaaaa $index"),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(_animation);
    if (_animation == null) {
      return new Container();
    }
    double animationValue = _animation?.value ?? 0;
    return Container(
      width: 200,
      height: 300,
      color: Colors.red,
      child: new ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          new AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext c, Widget w) => new GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: _onPanStart,
                  onPanEnd: _onPanEnd,
                  onPanUpdate: _onPanUpdate,
                  child: Stack(
                    overflow: Overflow.clip,
                    fit: StackFit.expand,
                    children: <Widget>[
                      buildItem(0, animationValue),
                      buildItem(1, animationValue),
                      buildItem(2, animationValue),
                      buildItem(3, animationValue),
                      buildItem(4, animationValue),
                      buildItem(5, animationValue),
                    ],
                  ),
                ),
          ),
        ],
      ),
    );
  }
}


part of "../eui.dart";

///
/// 扩散动画
///
class SpreadAnimation extends StatefulWidget {
  final Widget child;
  final double radius;
  final double maxRadius;
  final Color color;
  final Duration duration;
  final ImageProvider image;
  final Curve curve;
  final Tuple2<double,double> opacity;

  SpreadAnimation({
    Key key,
    this.child,
    @required this.radius,
    @required this.maxRadius,
    this.image,
    this.color = Colors.grey,
    this.curve = Curves.linear,
    this.opacity = const Tuple2(0.9, 0.1),
    this.duration = const Duration(milliseconds: 1500),
  }) :  assert(radius != null),
        assert(maxRadius != null),
        super(key: key);

  @override
  _SpreadAnimationState createState() => _SpreadAnimationState();
}

class _SpreadAnimationState extends State<SpreadAnimation>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.radius,
      height: widget.radius,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _AnimatedSpread(
            parent: _controller,
            curve: widget.curve,
            opacity: widget.opacity,
            child: ClipOval(
              child: Container(
                color: widget.color,
              ),
            ),
            scale: widget.maxRadius / widget.radius,
          ),
          CircleAvatar(
              child: widget.child,
              radius: widget.radius,
              backgroundImage: widget.image)
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _AnimatedSpread extends StatelessWidget {
  final Widget child;
  final Animation parent;
  final Animation _opacity;
  final Animation _scale;
  final double scale;
  final Curve curve;
  final Tuple2 opacity;

  _AnimatedSpread({this.child, this.parent, this.scale, this.curve,this.opacity})
      : _opacity = Tween(begin: opacity.item1, end: opacity.item2)
            .animate(CurvedAnimation(parent: parent, curve: curve)),
        _scale = Tween<double>(begin: 1.0, end: scale)
            .animate(CurvedAnimation(parent: parent, curve: curve));

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: parent,
      child: child,
      builder: (ctx, child) {
        return Transform.scale(
          scale: _scale.value,
          child: Opacity(opacity: _opacity.value, child: child),
        );
      },
    );
  }
}

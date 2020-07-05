
part of "../eui.dart";


///
/// 文本闪烁控件
///
class FlashingText extends StatefulWidget {

  final String data;
  final TextStyle style;
  final TextDirection textDirection;
  final Duration duration;
  final Color flashingColor;
  final Curve curve;

  FlashingText(this.data,{
    Key key,
    this.style,
    this.textDirection,
    @required this.flashingColor,
    @required this.duration,
    this.curve = Curves.linear,
  }) :  assert(flashingColor != null),
        assert(duration != null),
        super(key: key);

  @override
  _FlashingTextState createState() => _FlashingTextState();
}

class _FlashingTextState extends State<FlashingText> with SingleTickerProviderStateMixin{

  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this,duration: widget.duration);
    CurvedAnimation curvedAnimation = CurvedAnimation(parent: _controller,curve: widget.curve);
    _animation = Tween(begin: 0.0,end: 1.0).animate(curvedAnimation);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: Text(widget.data,style:widget.style),
      builder: (ctx,child){
        return DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[widget.style.color, widget.flashingColor, widget.style.color],
                stops: <double>[_animation.value-0.2,_animation.value,_animation.value+0.2]
            ),
            backgroundBlendMode:BlendMode.lighten,
          ),
          child: child,
        );
      },
    );
  }
}



//class FlashingText extends ImplicitlyAnimatedWidget{
//
//  final String data;
//  final TextStyle style;
//  final TextDirection textDirection;
//
//  FlashingText(this.data,{
//    Key key,
//    this.style,
//    this.textDirection,
//    @required Duration duration,
//    Curve curve = Curves.linear,
//  }) :super(key: key, curve: curve, duration: duration);
//
//  @override
//  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() => _FlashingTextState();
//}
//
//class _FlashingTextState extends AnimatedWidgetBaseState<FlashingText>{
//  Tween<double> _tween;
//
//  @override
//  Widget build(BuildContext context) {
//    return DecoratedBox(
//      position: DecorationPosition.foreground,
//      decoration: BoxDecoration(
//          gradient: LinearGradient(
//              begin: Alignment.centerLeft,
//              end: Alignment.centerRight,
//              colors: <Color>[Colors.grey, Color(0xfffd8403), Colors.grey],
//              stops: <double>[animation.value-0.2,animation.value,animation.value+0.2]
//          ),
//          backgroundBlendMode:BlendMode.lighten,
//      ),
//      child: Text(widget.data,),
//    );
//  }
//
//  @override
//  void forEachTween(TweenVisitor<dynamic> visitor) {
//    _tween = visitor(_tween, 1.0, (value) => Tween<double>(begin: 0.0));
//  }
//
//}
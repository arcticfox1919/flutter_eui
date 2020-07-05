part of "../eui.dart";


class FallingText extends StatefulWidget {
  final String data;
  final TextStyle style;
  final StrutStyle strutStyle;
  final TextDirection textDirection;
  final Duration duration;
  final AnimationStatusListener listener;
  final Curve curve;

  FallingText(
    this.data, {
    Key key,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.listener,
    this.curve = Curves.bounceOut,
    @required this.duration,
  }):assert(duration != null),super(key:key);

  @override
  _FallingTextState createState() => _FallingTextState();
}

class _FallingTextState extends State<FallingText>
    with TickerProviderStateMixin {
  final GlobalKey _gk = GlobalKey();

  /// 文本底部的y轴坐标值
  double _textBottomHeight = 0;

  List<Animation> _animationList;
  List<_FallingTextController> _controllerList;

  @override
  void initState() {
    super.initState();
//    timeDilation = 5.0;
    _createController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // 获取控件的高度
      double height = _gk.currentContext.size.height;
      RenderBox box = _gk.currentContext.findRenderObject();

      // 将控件内部的相对位置转换为屏幕上的绝对坐标值
      Offset offset = box.localToGlobal(Offset(0, height));
      _textBottomHeight = offset.dy;

      _createAnimation();
      // 启动动画
      _controllerList.forEach((e) {
        e.start();
      });
    });
  }

  _createController() {
    int len = widget.data.length;
    int milliseconds = widget.duration.inMilliseconds ~/ len;
    _controllerList = List<_FallingTextController>.generate(len, (index) {
      return _FallingTextController(
          vsync: this,
          duration: Duration(milliseconds: milliseconds),
          startDuration: Duration(milliseconds: index * milliseconds));
    });

    if(widget.listener != null){
      _controllerList.first.controller.addStatusListener((status) {
        if(status == AnimationStatus.forward){
          widget.listener.call(status);
        }
      });

      _controllerList.last.controller.addStatusListener((status) {
        if(status == AnimationStatus.completed){
          widget.listener.call(status);
        }
      });
    }
  }

  _createAnimation() {
    _animationList = List<Animation>.generate(widget.data.length, (index) {
      CurvedAnimation curvedAnimation = CurvedAnimation(
          parent: _controllerList[index].controller, curve: widget.curve);
      return Tween<double>(begin: -_textBottomHeight, end: 0)
          .animate(curvedAnimation);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        key: _gk,
        textDirection: widget.textDirection,
        mainAxisSize: MainAxisSize.min,
        children: _separate(),
      ),
    );
  }

  List<Widget> _separate() {
    return List<Widget>.generate(widget.data.length, (index) {
      return FallingAnimation(
        child: Text(widget.data[index],style: widget.style,strutStyle:widget.strutStyle),
        animation: _animationList == null ? null : _animationList[index],
      );
    });
  }

  @override
  void dispose() {
    _controllerList.forEach((e) {
      e.dispose();
    });
    super.dispose();
  }
}

class _FallingTextController {
  final AnimationController controller;
  final Duration startDuration;
  Timer _timer;

  _FallingTextController(
      {@required TickerProvider vsync,
      Duration duration,
      @required this.startDuration})
      : controller = AnimationController(vsync: vsync, duration: duration);

  void start() {
    _timer = Timer(startDuration, () {
      controller.forward();
    });
  }

  void dispose() {
    _timer?.cancel();
    controller?.dispose();
  }
}

class FallingAnimation extends StatelessWidget {
  final Widget child;
  final Animation animation;

  FallingAnimation({@required this.child, @required this.animation});

  @override
  Widget build(BuildContext context) {
    return animation == null
        ? child
        : AnimatedBuilder(
            child: this.child,
            animation: this.animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, animation.value),
                child: child,
              );
            });
  }
}

part of "../eui.dart";

///
///  封装圆角按钮
///
class RoundButton extends StatelessWidget {
  final String text;
  final List<Color> colors;
  final Color color;
  final double radius;
  final Gradient gradient;
  final double width;
  final double height;
  final Color textColor;
  final double textSize;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final FontWeight textFontWeight;
  final List<BoxShadow> boxShadow;

  RoundButton(
      {@required this.text,
        this.color,
        this.radius = 0,
        this.gradient,
        this.colors,
        this.width,
        this.height,
        this.textColor,
        this.textSize,
        this.textFontWeight = FontWeight.w400,
        this.padding,
        this.boxShadow,
        @required this.onPressed,
        Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LinearGradient linearGradient;
    if (color == null && gradient == null && colors != null) {
      linearGradient = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: this.colors);
    }

    TextStyle ts;
    ts = TextStyle(
        color: textColor, fontSize: textSize, fontWeight: textFontWeight);

    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            boxShadow: boxShadow,
            color: color,
            gradient: gradient ?? linearGradient,
            borderRadius: BorderRadius.circular(radius)),
        child: Text(
          text,
          style: ts,
        ),
      ),
    );
  }
}

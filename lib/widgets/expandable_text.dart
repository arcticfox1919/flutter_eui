part of "../eui.dart";


extension _TextMeasurer on RichText {
  List<TextBox> measure(BuildContext context, Constraints constraints) {
    final renderObject = createRenderObject(context)..layout(constraints);
    return renderObject.getBoxesForSelection(
      TextSelection(
        baseOffset: 0,
        extentOffset: text.toPlainText().length,
      ),
    );
  }
}

class ExpandableText extends StatelessWidget {
  final TextSpan textSpan;
  final TextSpan moreSpan;
  final int maxLines;
  final bool isExpanded;

  const ExpandableText({
    Key key,
    this.textSpan,
    this.maxLines,
    this.moreSpan,
    this.isExpanded = false
  })  : assert(textSpan != null),
        assert(maxLines != null),
        assert(moreSpan != null),
        super(key: key);


  static const String _ellipsis = "\u2026\u0020"; // Unicode symbols for "… "


  String get _lineEnding => "$_ellipsis${moreSpan.text}";


  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final richText =
      Text.rich(textSpan).build(context) as RichText;
      final boxes = richText.measure(context, constraints);

      if (boxes.length <= maxLines || isExpanded) {
        return RichText(text: textSpan);
      } else {
        final croppedText = _ellipsizeText(boxes);
        final ellipsizedText =
        _buildEllipsizedText(croppedText);

        if (ellipsizedText.measure(context, constraints).length <=
            maxLines) {
          return ellipsizedText;
        } else {
          final fixedEllipsizedText = croppedText.substring(
              0, croppedText.length - _lineEnding.length);
          return _buildEllipsizedText(fixedEllipsizedText);
        }
      }
    },
  );

  String _ellipsizeText(List<TextBox> boxes) {
    final text = textSpan.text;

    double _calculateLinesLength(List<TextBox> boxes) => boxes
        .map((box) => box.right - box.left)
        .reduce((acc, value) => acc += value);

    final requiredLength = _calculateLinesLength(boxes.sublist(0, maxLines));
    final totalLength = _calculateLinesLength(boxes);

    final requiredTextFraction = requiredLength / totalLength;
    return text.substring(0, (text.length * requiredTextFraction).floor());
  }

  RichText _buildEllipsizedText(String text) =>
      RichText(
        text: TextSpan(
            text: "$text$_ellipsis",
            style: textSpan.style,
            children: [moreSpan]),
      );
}


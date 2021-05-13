library timer_button;

import 'dart:async';

import 'package:flutter/material.dart';

enum ButtonType { RaisedButton, FlatButton, OutlineButton }
enum LabelWitchStyle { main, sub }
enum EndDecoration {
  splitter, //|
  enParentheses, //()
  cnParentheses, //（）
  squareBrackets, //[]
  squareHeadBrackets, //【】
  hollowSquareHeadBrackets, //〖〗
  cnCurlyBraces, //「」
  hexagonBrackets, //〔〕
  quotationMarksDouble, //《 》
  quotationMarksSingle, //〈 〉
  enQuotationMarksSingle, //<>
  enQuotesDouble, //""
  enQuotesSignle, //'
  cnQuotesDouble, //“ ”
  cnQuotesSignle, //‘ ’
  none //
}

const int aSec = 1;

const String secPostFix = 's';
const String labelSplitter = " |  ";

class TimerButton extends StatefulWidget {
  /// Create a TimerButton button.
  ///
  /// The [label], [onPressed], and [timeOutInSeconds]
  /// arguments must not be null.

  ///label
  final String label;
  final String reLabel;
  final LabelWitchStyle labelwitchStyle;
  final bool isBeginAfaterLoaded;

  ///[timeOutInSeconds] after which the button is enabled
  final int timeOutInSeconds;

  ///

  final String showUnit;
  final EndDecoration endDecortiaon;

  ///[onPressed] Called when the button is tapped or otherwise activated.
  final VoidCallback onPressed;

  /// Defines the button's base colors
  final Color color;

  /// The color to use for this button's text when the button is disabled.
  final Color disabledColor;

  /// activeTextStyle
  final TextStyle activeTextStyle;

  ///disabledTextStyle
  final TextStyle disabledTextStyle;

  ///buttonType
  final ButtonType buttonType;

  ///If resetTimerOnPressed is true reset the timer when the button is pressed : default to true
  final bool resetTimerOnPressed;

  const TimerButton({
    Key key,
    @required this.label,
    @required this.onPressed,
    @required this.timeOutInSeconds,
    this.reLabel = '',
    this.labelwitchStyle = LabelWitchStyle.sub,
    this.showUnit = secPostFix,
    this.isBeginAfaterLoaded = true,
    this.endDecortiaon = EndDecoration.none,
    this.color = Colors.blue,
    this.resetTimerOnPressed = true,
    this.disabledColor,
    this.buttonType = ButtonType.RaisedButton,
    this.activeTextStyle = const TextStyle(color: Colors.white),
    this.disabledTextStyle = const TextStyle(color: Colors.black45),
  })  : assert(label != null),
        assert(activeTextStyle != null),
        assert(disabledTextStyle != null),
        super(key: key);

  @override
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  bool timeUpFlag = false;
  int timeCounter = 0;
  bool _isFirstFire = true;
  String get timerText => '$timeCounter${widget.showUnit}';

  @override
  void initState() {
    super.initState();
    timeCounter = widget.timeOutInSeconds;
    if (widget.isBeginAfaterLoaded == true) {
      _isFirstFire = false;
      _timerUpdate();
    } else {
      _isFirstFire = true;
    }
    setState(() {});
  }

  _timerUpdate() {
    Timer(const Duration(seconds: aSec), () async {
      setState(() {
        timeCounter--;
      });
      if (timeCounter != 0)
        _timerUpdate();
      else
        timeUpFlag = true;
    });
  }

  Widget _buildChild() {
    String timeStr = '';
    String labelStr = '';
    if (_isFirstFire == true) {
      timeStr = widget.label;
    } else {
      labelStr = widget.labelwitchStyle == LabelWitchStyle.main
          ? widget.label
          : (widget.reLabel.length > 0 ? widget.reLabel : widget.label);
      switch (widget.endDecortiaon) {
        case EndDecoration.splitter:
          timeStr = '$labelStr$labelSplitter$timerText';
          break;
        case EndDecoration.enParentheses:
          timeStr = '$labelStr($timerText )';
          break;
        case EndDecoration.cnParentheses:
          timeStr = '$labelStr（$timerText）';
          break;
        case EndDecoration.squareBrackets:
          timeStr = '$labelStr[$timerText]';
          break;
        case EndDecoration.squareHeadBrackets:
          timeStr = '$labelStr【$timerText】';
          break;
        case EndDecoration.hollowSquareHeadBrackets:
          timeStr = '$labelStr〖$timerText〗';
          break;
        case EndDecoration.hexagonBrackets:
          timeStr = '$labelStr〔$timerText〕';
          break;
        case EndDecoration.cnCurlyBraces:
          timeStr = '$labelStr「$timerText」';
          break;
        case EndDecoration.quotationMarksDouble:
          timeStr = '$labelStr《$timerText》';
          break;
        case EndDecoration.quotationMarksSingle:
          timeStr = '$labelStr〈$timerText〉';
          break;
        case EndDecoration.enQuotationMarksSingle:
          timeStr = '$labelStr<$timerText>';
          break;
        case EndDecoration.enQuotesDouble:
          timeStr = '$labelStr\"$timerText\"';
          break;
        case EndDecoration.enQuotesSignle:
          timeStr = '$labelStr\'$timerText\'';
          break;
        case EndDecoration.cnCurlyBraces:
          timeStr = '$labelStr‘$timerText’';
          break;
        default:
          timeStr = '$labelStr$timerText';
      }
    }

    return Container(
      child: timeUpFlag
          ? Text(
              widget.labelwitchStyle == LabelWitchStyle.main
                  ? widget.label
                  : widget.reLabel,
              style: (widget.buttonType == ButtonType.OutlineButton)
                  ? widget.activeTextStyle.copyWith(color: widget.color)
                  : widget.activeTextStyle,
            )
          : Text(
              timeStr,
              style: widget.disabledTextStyle,
            ),
    );
  }

  _onPressed() {
    _isFirstFire = false;
    if (timeUpFlag) {
      setState(() {
        timeUpFlag = false;
      });
      timeCounter = widget.timeOutInSeconds;

      if (widget.onPressed != null) {
        widget.onPressed();
      }
      // reset the timer when the button is pressed
      if (widget.resetTimerOnPressed) {
        _timerUpdate();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.buttonType) {
      case ButtonType.RaisedButton:
        //TODO: (Ajay) Remove deprecated members
        // ignore: deprecated_member_use
        return RaisedButton(
          disabledColor: widget.disabledColor,
          color: widget.color,
          onPressed: _onPressed,
          child: _buildChild(),
        );
        break;
      case ButtonType.FlatButton:
        // ignore: deprecated_member_use
        return FlatButton(
          color: widget.color,
          disabledColor: widget.disabledColor,
          onPressed: _onPressed,
          child: _buildChild(),
        );
        break;
      case ButtonType.OutlineButton:
        // ignore: deprecated_member_use
        return OutlineButton(
          borderSide: BorderSide(
            color: widget.color,
          ),
          disabledBorderColor: widget.disabledColor,
          onPressed: _onPressed,
          child: _buildChild(),
        );
        break;
    }

    return Container();
  }
}

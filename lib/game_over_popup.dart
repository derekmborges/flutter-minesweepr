import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PopupLayout extends ModalRoute {
  double top;
  double bottom;
  double left;
  double right;
  Color bgColor;
  final Widget child;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get maintainState => false;

  @override
  String get barrierLabel => null;

  @override
  Color get barrierColor => bgColor == null ? Colors.black.withOpacity(0.5) : bgColor;

  @override
  bool get barrierDismissible => false;

  @override
  bool get opaque => false;

  PopupLayout({
    Key key,
    this.bgColor,
    @required this.child,
    this.top,
    this.bottom,
    this.left,
    this.right
  });

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    if (top == null) this.top = 10;
    if (bottom == null) this.bottom = 20;
    if (left == null) this.left = 20;
    if (right == null) this.right = 20;

    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          bottom: true,
          child: _buildOverlayContent(context),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: this.bottom,
        left: this.left,
        right: this.right,
        top: this.top
      ),
      child: child
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

}

class PopupContent extends StatefulWidget {
  final Widget content;

  const PopupContent({Key key, this.content}) : super(key: key);

  @override
  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.content,
    );
  }
}

showGameOverPopup(BuildContext context, Widget widget, String title, {BuildContext popupContext}) {
  Navigator.push(
    context,
    PopupLayout(
      top: 300,
      left: 50,
      right: 50,
      bottom: 300,
      child: PopupContent(
        content: Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            automaticallyImplyLeading: false,
            brightness: Brightness.light,
          ),
          resizeToAvoidBottomPadding: false,
          body: widget,
        ),
      )
    )
  );
}


import 'package:flutter/material.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

// ignore: must_be_immutable
class MySafeArea extends StatefulWidget {
  final Widget body;
  final bool useTimer;
  final bool usePadding;
  bool canPop;
  bool initializeTimer;
  bool useAppBar;
  bool? resizeToAvoidBottomInset;
  FloatingActionButtonLocation floatingActionButtonLocation;
  PreferredSizeWidget? appBar;
  EdgeInsets? padding;
  Color? scaffoldColor;
  Color? appBarColor;
  Widget? floatingButton;
  Widget? bottomBar;
  String? titleText;
  Function? popFunction;
  bool useBackButton = true;
  bool extendBodyBehindAppBar = false;
  bool useBackgroundLogo;
  bool useBackgroundImage;
  String? backgroundImage;
  Widget? drawer;
  Key? scaffoldKey;
  MySafeArea({
    super.key,
    required this.body,
    this.useTimer = true,
    this.usePadding = true,
    this.canPop = true,
    this.initializeTimer = true,
    this.resizeToAvoidBottomInset,
    this.useBackButton = true,
    this.useAppBar = true,
    this.appBar,
    this.padding,
    this.scaffoldColor,
    this.floatingButton,
    this.bottomBar,
    this.titleText,
    this.floatingActionButtonLocation =
        FloatingActionButtonLocation.centerDocked,
    this.useBackgroundLogo = true,
    this.useBackgroundImage = false,
    this.extendBodyBehindAppBar = false,
    this.popFunction,
    this.drawer,
    this.scaffoldKey,
    this.backgroundImage,
    this.appBarColor,
  });

  @override
  State<MySafeArea> createState() => _MySafeAreaState();
}

class _MySafeAreaState extends State<MySafeArea> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      drawer: widget.drawer,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      // backgroundColor: widget.scaffoldColor ?? Colors.white,
      floatingActionButton: widget.floatingButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      bottomNavigationBar: widget.bottomBar,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      appBar: widget.useAppBar
          ? MyWidgets().appbar(
              context: context,
              color: widget.appBarColor ?? widget.scaffoldColor,
              titletext: widget.titleText,
              showBack: widget.useBackButton,
              action: Padding(padding: const EdgeInsets.all(8.0)),
            )
          : widget.appBar,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              padding: const EdgeInsets.all(0),
              textScaler: TextScaler.linear(textScale),
            ),
            child: PopScope(
              canPop: widget.canPop,

              onPopInvokedWithResult: (didPop, val) {
                if (widget.popFunction != null) {
                  widget.popFunction!();
                }
              },
              child: Padding(
                padding: widget.usePadding
                    ? internalPadding(context)
                    : widget.padding ?? const EdgeInsets.all(0),
                child: widget.body,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

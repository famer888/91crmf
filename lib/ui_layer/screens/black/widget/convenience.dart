import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';

import '../../../router/routes.dart';
import '../../image_paths.dart';
import 'interval_gesture_widget.dart';

class Convenience {
  static Widget onlineWidget(BuildContext context, [dynamic platform]) {
    return IntervalGestureWidget(
      onTap: () => const MineCustomerServiceRoute().push(context),
      child: Image.asset(MyImagePaths.appMineService, width: 60.w),
    );
  }

  static Widget buildContainerWidget(
      {EdgeInsetsGeometry? padding,
      EdgeInsetsGeometry? margin,
      Color? color,
      double? height,
      double? width,
      BoxConstraints? constraints,
      AlignmentGeometry? alignment,
      Widget? child,
      /* decoration param */
      DecorationImage? image,
      BoxBorder? border,
      BorderRadiusGeometry? borderRadius,
      Gradient? gradient,
      BoxShadow? boxShadow,
      Clip clipBehavior = Clip.none}) {
    BoxDecoration? decoration;
    if (border != null || image != null || gradient != null || boxShadow != null || borderRadius != null) {
      decoration = BoxDecoration(
        boxShadow: boxShadow != null ? [boxShadow] : null,
        image: image,
        color: color,
        border: border,
        borderRadius: borderRadius,
        gradient: gradient,
      );
    }
    return Container(
      padding: padding,
      margin: margin,
      color: decoration == null ? color : null,
      height: height,
      width: width,
      constraints: constraints,
      decoration: decoration,
      alignment: alignment,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  static Widget buildBorderContainerWidget({
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    double? bWidth,
    BorderRadiusGeometry? borderRadius,
    AlignmentGeometry? alignment,
    Widget? child,
    void Function()? onTap,
  }) {
    bWidth ??= 0.75.w;
    borderRadius ??= BorderRadius.circular(2.w);
    padding ??= EdgeInsets.fromLTRB(15.w, 5.w, 15.w, 5.w);
    Widget current = buildContainerWidget(
      margin: margin,
      gradient: const LinearGradient(colors: [
        Color.fromRGBO(0, 248, 255, 1.00),
        Color.fromRGBO(0, 148, 235, 0.45),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      borderRadius: borderRadius,
      width: width,
      height: height,
      child: buildContainerWidget(
        padding: padding,
        margin: EdgeInsets.all(bWidth),
        borderRadius: borderRadius,
        color: const Color(0xFF091313),
        alignment: alignment,
        child: child,
      ),
    );

    return onTap != null ? IntervalGestureWidget(onTap: onTap, child: current) : current;
  }

  static Widget buildChildActionWidget({
    TextStyle? style,
    String? text,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Widget? child,
    /* container param */
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    double? height,
    double? width,
    BoxConstraints? constraints,
    // required Widget child,
    AlignmentGeometry? alignment,
    /* decoration param */
    DecorationImage? image,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    Gradient? gradient,
    BoxShadow? boxShadow,
    void Function()? onTap,
  }) {
    child ??= Text(
      text ?? '---',
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );

    if ((width != null || height != null || color != null) ||
        (padding != null || alignment != null) ||
        (border != null || borderRadius != null || gradient != null)) {
      child = buildContainerWidget(
        padding: padding,
        // margin: margin,
        color: color,
        height: height,
        width: width,
        constraints: constraints,
        alignment: alignment,
        image: image,
        border: border,
        borderRadius: borderRadius,
        gradient: gradient,
        boxShadow: boxShadow,
        child: child,
      );
    }

    if (onTap != null) {
      child = IntervalGestureWidget(
        onTap: onTap,
        child: child,
      );
    }

    if (margin != null) {
      child = Padding(padding: margin, child: child);
    }

    return child;
  }

  static Widget buildCirleActionWidget({
    bool isSelected = false,
    double? width,
    double? inner,
    double? space,
    EdgeInsetsGeometry? margin,
    Color? nColor,
    Color? sColor,
  }) {
    nColor ??= MyTheme.blueColor63;
    sColor ??= MyTheme.blueColor63;
    Color borderColor = isSelected == false ? nColor : sColor;

    Widget? current; // 子
    if (isSelected == true) {
      current = buildContainerWidget(
        margin: margin,
        borderRadius: BorderRadius.circular((inner ?? 9.w) * 0.5),
        color: MyTheme.blueColor63,
        height: inner ?? 9.w,
        width: inner ?? 9.w,
        alignment: Alignment.center,
      );
      current = Align(child: current); // 剧中
    }

    return buildContainerWidget(
      margin: margin,
      borderRadius: BorderRadius.circular((width ?? 15.w) * 0.5),
      border: Border.all(color: borderColor),
      width: width ?? 15.w,
      height: width ?? 15.w,
      alignment: Alignment.center,
      child: current,
    );
  }

  static Widget sysSEOActionWidget({EdgeInsetsGeometry? margin, double? height, String? des}) {
    return buildContainerWidget(
      margin: margin,
      height: height ?? 32.w,
      borderRadius: BorderRadius.circular(16.w),
      gradient: const LinearGradient(colors: [
        Color.fromRGBO(241, 249, 255, 1),
        Color.fromRGBO(255, 244, 247, 1),
      ]),
      child: Row(children: [
        SizedBox(width: 20.w),
        Image.asset('assets/image/sys_seo_icon.png', width: 16.w),
        SizedBox(width: 16.w),
        Text(des ?? '你想要的都在这里', style: MyTheme.white255_13),
      ]),
    );
  }

  // static Widget redRatingWidget(double initRating, double space, {int count = 5, void Function(double)? onUpdate}) {
  //   return RatingBar(
  //     initialRating: initRating,
  //     ignoreGestures: onUpdate == null,
  //     direction: Axis.horizontal,
  //     allowHalfRating: true,
  //     itemCount: count,
  //     itemSize: onUpdate == null ? 14.w : 20.w,
  //     itemPadding: EdgeInsets.symmetric(horizontal: space),
  //     ratingWidget: RatingWidget(
  //       full: Image.asset('assets/image/ic_star_full.png'),
  //       half: Image.asset('assets/image/ic_star_half.png'),
  //       empty: Image.asset('assets/image/ic_star_null.png'),
  //     ),
  //     onRatingUpdate: onUpdate ?? (value) {},
  //   );
  // }

  static Widget buildRowTitleWidget(
    String title, {
    double? separate,
    TextStyle? style,
    Widget? child,
  }) {
    var emptyStyle = MyTheme.white255_15_M.w500.white25508;
    return Row(children: [
      Text(title, style: style ?? emptyStyle),
      SizedBox(width: separate ?? 10.w),
      Expanded(child: child ?? const SizedBox()),
    ]);
  }

  ///
  ///  Title & (TextField | Options)
  ///
  static Widget buildRowTitleAndContentWidget({
    String? title,
    Widget? tWidget,
    double? tWidth,
    Widget? child,
    double? space,
    EdgeInsets? insets,
  }) {
    tWidget ??= Text(
      title ?? '❓',
      style: MyTheme.white255_13.s14.color247_93_96.white25508,
      textAlign: TextAlign.justify,
    );
    if (tWidth != null) {
      tWidget = SizedBox(width: tWidth, child: tWidget);
    }
    return Row(children: [
      SizedBox(width: insets?.left ?? 15.w),
      tWidget,
      SizedBox(width: space ?? 10.w),
      Expanded(child: child ?? const SizedBox()),
      SizedBox(width: insets?.right ?? 15.w),
    ]);
  }

  ///
  /// Title & TextField
  ///
  static Widget buildRowTitleAndInputWidget({
    double? height,
    BorderRadiusGeometry? borderRadius,
    BoxBorder? border,
    Color? bgColor,
    required String title,
    double? tWidth,
    bool isNumber = false,
    required TextEditingController controller,
    required String hintText,
  }) {
    Widget current = buildTextFieldContainer(
      borderRadius: borderRadius ?? BorderRadius.circular(5.w),
      border: border,
      color: bgColor ?? MyTheme.kWidgetColor,
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      hintText: hintText,
      width: double.infinity,
      height: height ?? 48.w,
    );

    return buildRowTitleAndContentWidget(
      tWidth: tWidth,
      title: title,
      child: current,
    );
  }

  ///
  /// Title & tags Options
  ///
  // static Widget buildRowTitleAndTagsWidget({
  //   double? height,
  //   BorderRadiusGeometry? borderRadius,
  //   BoxBorder? border,
  //   Color? bgColor,
  //   required String title,
  //   double? tWidth,
  //   required String hintText,
  //   String? tagTitle,
  //   required List<OptAbsModel> originTags,
  //   required List<OptAbsModel> selectTags,
  //   int maxCount = 5,
  // }) {
  //   Widget current = MultiTagsTextWidget(
  //     hintText: hintText,
  //     title: tagTitle ?? '',
  //     dataList: originTags,
  //     selected: selectTags,
  //     maxCount: maxCount,
  //   );
  //   // if (displayAllBorder) {
  //   current = Convenience.buildContainerWidget(
  //     borderRadius: borderRadius ?? BorderRadius.circular(5.w),
  //     border: border,
  //     color: bgColor ?? ColorRes.kWidgetColor,
  //     height: height ?? 48.w,
  //     alignment: Alignment.centerLeft,
  //     child: current,
  //   );
  //   // }
  //   return buildRowTitleAndContentWidget(
  //     tWidth: tWidth,
  //     title: title,
  //     child: current,
  //   );
  // }

  ///
  /// Text field widget
  ///
  static TextField buildTextFieldWidget({
    bool expands = false,
    TextEditingController? controller,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    FocusNode? focusNode,
    bool readOnly = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool autofocus = false,
    bool obscureText = false,
    TextStyle? style,
    TextAlign textAlign = TextAlign.start,
    int maxLines = 1,
    String? hintText,
    TextStyle? hintStyle,
    EdgeInsetsGeometry? contentPadding,
  }) {
    style ??= MyTheme.white14.white25508;
    hintStyle ??= MyTheme.white14.white25506;
    return TextField(
      expands: expands,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofocus: autofocus,
      obscureText: obscureText,
      onSubmitted: onSubmitted,
      style: style,
      textAlign: textAlign,
      minLines: expands ? null : 1,
      maxLines: expands ? null : maxLines,
      cursorHeight: 23,
      cursorColor: MyTheme.blueColor63,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        hintText: hintText,
        hintStyle: hintStyle,
        border: InputBorder.none,
        isDense: true,
      ),
    );
  }

  static Widget buildTextFieldContainer({
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadiusGeometry? borderRadius,
    BoxBorder? border,
    Gradient? gradient,
    Color? color,
    double? width,
    double? height,
    AlignmentGeometry? alignment,
    /* ***** ***** ***** ***** ***** */
    TextEditingController? controller,
    bool expands = false,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    FocusNode? focusNode,
    bool readOnly = false,
    TextInputType? keyboardType,
    bool autofocus = false,
    bool obscureText = false,
    TextStyle? style,
    TextAlign textAlign = TextAlign.start,
    int maxLines = 1,
    String? hintText,
    TextStyle? hintStyle,
    EdgeInsetsGeometry? contentPadding,
  }) {
    if (padding == null) {
      contentPadding ??= EdgeInsets.fromLTRB(12.w, 0, 12.w, 0);
    } else {
      contentPadding = EdgeInsets.zero;
    }
    Widget current = buildTextFieldWidget(
      expands: expands,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      readOnly: readOnly,
      keyboardType: keyboardType,
      autofocus: autofocus,
      obscureText: obscureText,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      hintText: hintText,
      hintStyle: hintStyle,
      contentPadding: contentPadding,
    );

    if ((width != null || height != null || color != null) ||
        (padding != null || margin != null || alignment != null) ||
        (border != null || borderRadius != null || gradient != null)) {
      current = buildContainerWidget(
        padding: padding,
        margin: margin,
        borderRadius: borderRadius,
        border: border,
        gradient: gradient,
        color: color,
        width: width,
        height: height,
        alignment: alignment ?? Alignment.center,
        child: current,
      );
    }

    return current;
  }
}

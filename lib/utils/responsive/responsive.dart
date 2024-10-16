import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.mediumTablet,
    this.smallTablet,
    this.largeTablet,
  });

  final Widget? mobile;
  final Widget? tablet;
  final Widget? smallTablet;
  final Widget? mediumTablet;
  final Widget? largeTablet;
  final Widget? desktop;

  static bool isSmallMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 380;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width <= 650;

  static bool isSmallTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 650 &&
      MediaQuery.sizeOf(context).width < 800 &&
      MediaQuery.sizeOf(context).height < 1200;

  static bool isMediumTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 800 &&
      MediaQuery.sizeOf(context).width < 1100 &&
      MediaQuery.sizeOf(context).height < 1200;

  static bool isLargeTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 800 &&
      MediaQuery.sizeOf(context).width < 1100 &&
      MediaQuery.sizeOf(context).height >= 1300;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 800 &&
      MediaQuery.sizeOf(context).width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      print(
          'maxWidth:: ${constraints.maxWidth}, maxHeight:: ${constraints.maxHeight}');
      if (constraints.maxWidth >= 1100) {
        return desktop ?? emptyBody(context);
      }
      if (constraints.maxWidth >= 800 &&
          constraints.maxWidth < 1100 &&
          constraints.maxHeight >= 1300) {
        return largeTablet ?? emptyBody(context);
      }
      if (constraints.maxWidth >= 800 &&
          constraints.maxWidth < 1100 &&
          constraints.maxHeight < 1200) {
        return mediumTablet ?? emptyBody(context);
      }
      if (constraints.maxWidth >= 650 &&
          constraints.maxWidth < 800 &&
          constraints.maxHeight < 1200) {
        return smallTablet ?? emptyBody(context);
      }
      if (constraints.maxWidth >= 650) return tablet ?? emptyBody(context);

      return mobile ?? emptyBody(context);
    });
  }

  Widget emptyBody(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return const Center(
        child: Text('Build Desktop'),
      );
    }
    if (Responsive.isLargeTablet(context)) {
      return const Center(
        child: Text('Build Large Tablet'),
      );
    }
    if (Responsive.isMediumTablet(context)) {
      return const Center(
        child: Text('Build Medium Tablet'),
      );
    }
    if (Responsive.isSmallTablet(context)) {
      return const Center(
        child: Text('Build Small Tablet'),
      );
    }
    if (Responsive.isTablet(context)) {
      return const Center(
        child: Text('Build Tablet'),
      );
    }
    if (Responsive.isSmallMobile(context)) {
      return const Center(
        child: Text('Build Small Mobile'),
      );
    }
    return const Center(
      child: Text('Build Mobile'),
    );
  }
}

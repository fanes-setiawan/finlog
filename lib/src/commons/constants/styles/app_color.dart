import 'package:flutter/material.dart';

/// Color types:
/// - active [active]
/// - error [error]
/// - supplementary [supp]
/// - background [bg]
/// - mute [mute]
/// - inactive [inactive]
@Deprecated("Use AppColors instead")
class AppColor {
  AppColor._();

  static const subtitle = Color(0xff757575);

  // active
  static const activePrimary = Color(0xFF39A0ED);
  static const activeSecondary = Color(0xffE9F5FF);

  // error
  static const errorPrimary = Color(0xffEA001F);
  static const errorSecondary = Color(0xffFFF8F8);

  // supplementary
  static const suppBurntOrange = Color(0xffC85200);
  static const suppCrimsonRed = Color(0xffE52535);
  static const suppCeruleanBlue = Color(0xff0081A0);

  // background
  static const bgPrimary = Color(0xffFFFFFF);
  static const bgSecondary = Color(0xffFFFFFF);
  static const bgTertiary = Color(0xff1C1D1D);
  static const bgSurfGrnd = Color(0xffD9D9D9);

  // mute
  static const mutePrimary = Color(0xffE8E8E8);
  static const muteSecondary = Color(0xffFAFAFA);

  // inactive
  static const inactivePrimary = Color(0xffBBBBBB);
  static const inactiveSecondary = Color(0xffEDEDED);

  // other
  static const bruntOrange = Color(0xffC85200);
  static const crimsonRed = Color(0xffE52535);

  // Color reference from tailwind primevue
  static const Color blue50 = Color(0xfff5f9ff);
  static const Color blue100 = Color(0xffd0e1fd);
  static const Color blue200 = Color(0xffabc9fb);
  static const Color blue300 = Color(0xff85b2f9);
  static const Color blue400 = Color(0xff609af8);
  static const Color blue500 = Color(0xff3b82f6);
  static const Color blue600 = Color(0xff326fd1);
  static const Color blue700 = Color(0xff295bac);
  static const Color blue800 = Color(0xff204887);
  static const Color blue900 = Color(0xff183462);
  static const Color green50 = Color(0xfff4fcf7);
  static const Color green100 = Color(0xffcaf1d8);
  static const Color green200 = Color(0xffa0e6ba);
  static const Color green300 = Color(0xff76db9b);
  static const Color green400 = Color(0xff4cd07d);
  static const Color green500 = Color(0xff22c55e);
  static const Color green600 = Color(0xff1da750);
  static const Color green700 = Color(0xff188a42);
  static const Color green800 = Color(0xff136c34);
  static const Color green900 = Color(0xff0e4f26);

  static const Color yellow50 = Color(0xfffefbf3);
  static const Color yellow100 = Color(0xfffaedc4);
  static const Color yellow200 = Color(0xfff6de95);
  static const Color yellow300 = Color(0xfff2d066);
  static const Color yellow400 = Color(0xffeec137);
  static const Color yellow500 = Color(0xffeab308);
  static const Color yellow600 = Color(0xffc79807);
  static const Color yellow700 = Color(0xffa47d06);
  static const Color yellow800 = Color(0xff816204);
  static const Color yellow900 = Color(0xff5e4803);

  static const Color cyan50 = Color(0xfff3fbfd);
  static const Color cyan100 = Color(0xffc3edf5);
  static const Color cyan200 = Color(0xff94e0ed);
  static const Color cyan300 = Color(0xff65d2e4);
  static const Color cyan400 = Color(0xff35c4dc);
  static const Color cyan500 = Color(0xff06b6d4);
  static const Color cyan600 = Color(0xff059bb4);
  static const Color cyan700 = Color(0xff047f94);
  static const Color cyan800 = Color(0xff036475);
  static const Color cyan900 = Color(0xff024955);

  static const Color pink50 = Color(0xfffef6fa);
  static const Color pink100 = Color(0xfffad3e7);
  static const Color pink200 = Color(0xfff7b0d3);
  static const Color pink300 = Color(0xfff38ec0);
  static const Color pink400 = Color(0xfff06bac);
  static const Color pink500 = Color(0xffec4899);
  static const Color pink600 = Color(0xffc93d82);
  static const Color pink700 = Color(0xffa5326b);
  static const Color pink800 = Color(0xff822854);
  static const Color pink900 = Color(0xff5e1d3d);

  static const Color indigo50 = Color(0xfff7f7fe);
  static const Color indigo100 = Color(0xffdadafc);
  static const Color indigo200 = Color(0xffbcbdf9);
  static const Color indigo300 = Color(0xff9ea0f6);
  static const Color indigo400 = Color(0xff8183f4);
  static const Color indigo500 = Color(0xff6366f1);
  static const Color indigo600 = Color(0xff5457cd);
  static const Color indigo700 = Color(0xff4547a9);
  static const Color indigo800 = Color(0xff363885);
  static const Color indigo900 = Color(0xff282960);

  static const Color teal50 = Color(0xfff3fbfb);
  static const Color teal100 = Color(0xffc7eeea);
  static const Color teal200 = Color(0xff9ae0d9);
  static const Color teal300 = Color(0xff6dd3c8);
  static const Color teal400 = Color(0xff41c5b7);
  static const Color teal500 = Color(0xff14b8a6);
  static const Color teal600 = Color(0xff119c8d);
  static const Color teal700 = Color(0xff0e8174);
  static const Color teal800 = Color(0xff0b655b);
  static const Color teal900 = Color(0xff084a42);

  static const Color orange50 = Color(0xfffff8f3);
  static const Color orange100 = Color(0xffffedc7);
  static const Color orange200 = Color(0xffffc39b);
  static const Color orange300 = Color(0xfffba86f);
  static const Color orange400 = Color(0xfffa8e42);
  static const Color orange500 = Color(0xfff97316);
  static const Color orange600 = Color(0xffd46213);
  static const Color orange700 = Color(0xffae510f);
  static const Color orange800 = Color(0xff893f0c);
  static const Color orange900 = Color(0xff642e09);

  static const Color bluegray50 = Color(0xfff7f8f9);
  static const Color bluegray100 = Color(0xffdadee3);
  static const Color bluegray200 = Color(0xffbcc3cd);
  static const Color bluegray300 = Color(0xff9fa9b7);
  static const Color bluegray400 = Color(0xff818ea1);
  static const Color bluegray500 = Color(0xff64748b);
  static const Color bluegray600 = Color(0xff556376);
  static const Color bluegray700 = Color(0xff465161);
  static const Color bluegray800 = Color(0xff37404c);
  static const Color bluegray900 = Color(0xff282e38);

  static const Color purple50 = Color(0xfffbf7ff);
  static const Color purple100 = Color(0xffead6fd);
  static const Color purple200 = Color(0xffdab6fc);
  static const Color purple300 = Color(0xffc996fa);
  static const Color purple400 = Color(0xffb975f9);
  static const Color purple500 = Color(0xffa855f7);
  static const Color purple600 = Color(0xff8f48d2);
  static const Color purple700 = Color(0xff763cad);
  static const Color purple800 = Color(0xff5c2f88);
  static const Color purple900 = Color(0xff432263);

  static const Color red50 = Color(0xfffef6f6);
  static const Color red100 = Color(0xfffad2d2);
  static const Color red200 = Color(0xfff8afaf);
  static const Color red300 = Color(0xfff58b8b);
  static const Color red400 = Color(0xfff26868);
  static const Color red500 = Color(0xffef4444);
  static const Color red600 = Color(0xffcb3a3a);
  static const Color red700 = Color(0xffa73030);
  static const Color red800 = Color(0xff832525);
  static const Color red900 = Color(0xff601b1b);

  static const Color primary50 = Color(0xfff6f6fe);
  static const Color primary100 = Color(0xffd5d3f9);
  static const Color primary200 = Color(0xffb3aff4);
  static const Color primary300 = Color(0xff928cef);
  static const Color primary400 = Color(0xff7069ea);
  static const Color primary500 = Color(0xff4f46e5);
  static const Color primary600 = Color(0xff433cc3);
  static const Color primary700 = Color(0xff3731a0);
  static const Color primary800 = Color(0xff2b277e);
  static const Color primary900 = Color(0xff201c5c);

  static const Color surface0 = Color(0xffffffff);
  static const Color surface50 = Color(0xfffafafa);
  static const Color surface100 = Color(0xfff4f4f5);
  static const Color surface200 = Color(0xffe4e4e7);
  static const Color surface300 = Color(0xffd4d4d8);
  static const Color surface400 = Color(0xffa1a1aa);
  static const Color surface500 = Color(0xff71717a);
  static const Color surface600 = Color(0xff52525b);
  static const Color surface700 = Color(0xff3f3f46);
  static const Color surface800 = Color(0xff27272a);
  static const Color surface900 = Color(0xff18181b);

  static const Color gray50 = Color(0xfffafafa);
  static const Color gray100 = Color(0xfff4f4f5);
  static const Color gray200 = Color(0xffe4e4e7);
  static const Color gray300 = Color(0xffd4d4d8);
  static const Color gray400 = Color(0xffa1a1aa);
  static const Color gray500 = Color(0xff71717a);
  static const Color gray600 = Color(0xff52525b);
  static const Color gray700 = Color(0xff3f3f46);
  static const Color gray800 = Color(0xff27272a);
  static const Color gray900 = Color(0xff18181b);

  static const Color surfaceGround = Color(0xfffafafa);
  static const Color surfaceSection = Color(0xffffffff);
  static const Color surfaceCard = Color(0xffffffff);
  static const Color surfaceOverlay = Color(0xffffffff);
  static const Color surfaceBorder = Color(0xffe5e7eb);
  static const Color surfaceHover = Color(0xfff4f4f5);
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:eqraa/cubit/cubit.dart';
import 'package:eqraa/models/asmaa_allah_elhosna.dart';
import 'package:eqraa/models/azkar_Tsabeeh.dart';
import 'package:eqraa/shared/cache_helper.dart';
import 'package:eqraa/shared/network/dio.dart';
import 'package:eqraa/screens/home_screen.dart';
import 'components/components.dart';
import 'components/constants.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
  await DioHelper.initHadeeth();
  Map<String, dynamic> json1 = jsonDecode(azkar);
  AzkarAndTsabeeh.fromJson(json1);
  Map<String, dynamic> json2 = jsonDecode(asmaaAllahElHosna);
  AsmaaAllahElHosna.fromJson(json2);
  await CacheHelper.init();

  surahNameFromSharedPref = CacheHelper.getData(key: "surahName");
  surahNumFromSharedPref = CacheHelper.getData(key: "surahNumber");
  pageNumberFromSharedPref = CacheHelper.getData(key: "pageNumber");

  runApp(BlocProvider(create: (context) => AppCubit(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkInternetConnection(AppCubit.get(context), isPrayerTimesRequest: false);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          locale: const Locale(
            'ar',
          ),
          builder: (context, child) {
            return Directionality(
                textDirection: TextDirection.rtl, child: child!);
          },
          theme: ThemeData(
            appBarTheme: AppBarTheme(
                backgroundColor: HexColor('22211f'),
                titleTextStyle: const TextStyle(color: Colors.white),
                iconTheme: const IconThemeData(
                  color: Colors.white,
                )),
            scaffoldBackgroundColor: HexColor('fefbec'),
            fontFamily: 'QuranFont',
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
        );
      },
    );
  }
}

Widget splash() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [Colors.teal, Colors.black]),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Image(
          image: AssetImage('assets/images/logo.png'),
          width: 360,
        ),
        defaultText(
            text: 'Eqraa',
            fontsize: 53,
            textColor: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.7)
      ],
    ),
  );
  //Image.asset();
}

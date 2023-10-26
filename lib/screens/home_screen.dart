import 'package:eqraa/models/azkar_start_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eqraa/components/components.dart';
import 'package:eqraa/cubit/cubit.dart';
import 'package:eqraa/cubit/states.dart';
import 'package:eqraa/screens/asmaa_allah_screen.dart';
import 'package:eqraa/screens/azkar_hadeeth_screen.dart';
import 'package:eqraa/screens/Index_screen.dart';
import 'package:eqraa/screens/prayer_times_screen.dart';
import '../components/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
              body: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [defaultColor, Colors.black87]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                      child: Image(
                    image: const AssetImage('assets/images/quran_logo.png'),
                    width: MediaQuery.of(context).size.width / 1.3,
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildAzkarItem(
                                index: 0,
                                navToIndex: () => navigateTo(
                                  context,
                                  AzkarAndHadeethScreen(index: 0),
                                ),
                              ),
                              buildAzkarItem(
                                index: 1,
                                navToIndex: () => navigateTo(
                                  context,
                                  AzkarAndHadeethScreen(index: 1),
                                ),
                              ),
                              buildAzkarItem(
                                index: 2,
                                navToIndex: () => navigateTo(
                                  context,
                                  AzkarAndHadeethScreen(index: 2),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildAzkarItem(
                                index: 3,
                                navToIndex: () => navigateTo(
                                  context,
                                  AzkarAndHadeethScreen(index: 3),
                                ),
                              ),
                              buildAzkarItem(
                                index: 4,
                                navToIndex: () => navigateTo(
                                  context,
                                  AzkarAndHadeethScreen(index: 4),
                                ),
                              ),
                              buildAzkarItem(
                                index: 5,
                                navToIndex: () => navigateTo(
                                  context,
                                  AzkarAndHadeethScreen(index: 5),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  homeItem(context, 'الفهرس', const IndexScreen()),
                  homeItem(context, 'مواقيتُ الصَّلاَةُ', const PrayerTimes()),
                  homeItem(
                      context, 'أسماء الله الحسنى', const AsmaaAllahScreen()),
                ],
              ),
            ),
          )),
        );
      },
    );
  }

  Widget buildAzkarItem(
          {required int index, required VoidCallback navToIndex}) =>
      GestureDetector(
        onTap: navToIndex,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image(
                image: AssetImage(azkarList[index].img),
                fit: BoxFit.cover,
                height: 50.h,
                width: 50.w,
              ),
              Container(
                  padding: const EdgeInsets.all(0)
                      .add(const EdgeInsets.symmetric(horizontal: 10)),
                  child: defaultText(
                    text: azkarList[index].text,
                    textColor: Colors.white,
                    fontsize: 17,
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
        ),
      );
}

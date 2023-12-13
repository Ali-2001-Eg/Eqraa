import 'dart:async';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eqraa/components/components.dart';
import 'package:eqraa/components/constants.dart';
import 'package:eqraa/cubit/cubit.dart';
import 'package:eqraa/cubit/states.dart';
import 'package:eqraa/screens/azan_screen.dart';

class PrayerWidget {
  String? imageIcon;
  String? elSala;
  String? time;
  bool morning = false;

  PrayerWidget(
      {required this.imageIcon,
      required this.time,
      required this.elSala,
      required this.morning});
}

class PrayerTimes extends StatelessWidget {
  const PrayerTimes({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    if (!internetConnection && !cubit.gotPrayerTimes) {
      defaultFlutterToast(msg: "يرجي الاتصال بالانترنت");
      Future.delayed(
        const Duration(milliseconds: 200),
        () => {
          Navigator.pop(context),
        },
      );
    }
    //checkInternetConnection(cubit, isPrayerTimesRequest: true);
    checkLocationPermission().then((value) {
      if (!locationPermission && !cubit.gotPrayerTimes) {
        defaultFlutterToast(msg: "يرجي تفعيل ال Location");
        Future.delayed(
          const Duration(milliseconds: 200),
          () => {
            Navigator.pop(context),
          },
        );
      } else if (locationPermission &&
          internetConnection &&
          !cubit.gotPrayerTimes) {
        cubit.getPrayerTime();
      }
    });

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: cubit.gotPrayerTimes,
          builder: (context) {
            List<PrayerWidget> prayerList = [
              PrayerWidget(
                  imageIcon: 'assets/images/salahIcon.png',
                  time: cubit.prayerTimesModel!.Fajr!.substring(0, 5),
                  elSala: 'الفَجرِ',
                  morning: true),
              PrayerWidget(
                  imageIcon: 'assets/images/salahIcon.png',
                  time: cubit.prayerTimesModel!.Dhuhr!.substring(0, 5),
                  elSala: 'الظُّهرِ',
                  morning: true),
              PrayerWidget(
                  imageIcon: 'assets/images/salahIcon.png',
                  time: '${cubit.elAsrHours - 12}'
                      ":"
                      '${cubit.prayerTimesModel!.Asr!.substring(3, 5)}',
                  elSala: 'العَصرِ',
                  morning: false),
              PrayerWidget(
                  imageIcon: 'assets/images/salahIcon.png',
                  time: '${cubit.elMaghribHours - 12}'
                      ":"
                      '${cubit.prayerTimesModel!.Maghrib!.substring(3, 5)}',
                  elSala: 'المغرِب',
                  morning: false),
              PrayerWidget(
                  imageIcon: 'assets/images/salahIcon.png',
                  elSala: 'العِشَاءِ',
                  time: '${cubit.elIshaHours - 12}'
                      ":"
                      '${cubit.prayerTimesModel!.Isha!.substring(3, 5)}',
                  morning: false),
            ];
            // Azan only works when app is on
            Timer.periodic(const Duration(seconds: 1), (timer) {
              if (((DateTime.now().hour == cubit.elAsrHours) &&
                  (DateTime.now().minute == cubit.elAsrMins))) {
                cubit.azanElAsr = true;
              } else if (((DateTime.now().hour == cubit.elDuhrHours) &&
                  (DateTime.now().minute == cubit.elDuhrMins))) {
                cubit.azanElDuhr = true;
              } else if (((DateTime.now().hour == cubit.elIshaHours) &&
                  (DateTime.now().minute == cubit.elIshaMins))) {
                cubit.azanElIsha = true;
              } else if (((DateTime.now().hour == cubit.elMaghribHours) &&
                  (DateTime.now().minute == cubit.elMaghribMins))) {
                cubit.azanElMaghrib = true;
              } else if (((DateTime.now().hour == cubit.elFajrHours) &&
                  (DateTime.now().minute == cubit.elFajrMins))) {
                cubit.azanElFajr = true;
              }
              if (cubit.azanElFajr ||
                  cubit.azanElIsha ||
                  cubit.azanElMaghrib ||
                  cubit.azanElAsr ||
                  cubit.azanElDuhr) {
                cubit.setUrlAzanSoundSrc();
                navigateTo(context, const AzanScreen());

                timer.cancel();
              }
            });

            return Scaffold(
              appBar: defaultAppBar(text: "مواقيتُ الصَّلاة"),
              body: Container(
                margin: EdgeInsets.only(top: 3.h),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  alignment: AlignmentDirectional.bottomCenter,
                  opacity: .8,
                  image: AssetImage('assets/images/MasjidElnabwy.png'),
                )),
                child: Center(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 3.h),
                            height: 60.h,
                            decoration: BoxDecoration(
                              color: Colors.teal[200]!.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(23),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  defaultText(
                                      text:
                                          prayerList[index].morning ? 'ص' : 'م',
                                      fontsize: 19),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  defaultText(
                                    text: prayerList[index].time!,
                                    fontsize: 27,
                                  ),
                                  const Spacer(),
                                  defaultText(
                                      text: prayerList[index].elSala!,
                                      fontsize: 30),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  ImageIcon(
                                    AssetImage(
                                      prayerList[index].imageIcon!,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      separatorBuilder: (context, index) => SizedBox(
                            height: 30.h,
                          ),
                      itemCount: prayerList.length),
                ),
              ),
            );
          },
          fallback: (context) => Center(
            child: CircularProgressIndicator(color: defaultColor),
          ),
        );
      },
    );
  }
}

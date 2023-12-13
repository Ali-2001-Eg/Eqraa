import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eqraa/cubit/states.dart';
import 'package:eqraa/models/azkar_Tsabeeh.dart';
import 'package:eqraa/models/hadeeth.dart';

import '../components/components.dart';
import '../components/constants.dart';
import '../cubit/cubit.dart';

// ignore: must_be_immutable
class AzkarAndHadeethScreen extends StatelessWidget {
  int index = 0;
  String title = "";
  List<String> azkar = [];

  AzkarAndHadeethScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);

    if (index == 0) {
      azkar = AzkarAndTsabeeh.azkarElSabah;
      title = "أَذْكَارُ الصَّبَاحِ";
    } else if (index == 1) {
      azkar = AzkarAndTsabeeh.azkarElMasa2;
      title = "أَذْكَارُ المساءِ";
    } else if (index == 2) {
      azkar = AzkarAndTsabeeh.azkarElNoom;
      title = "أَذْكَارُ النَوْم";
    } else if (index == 3) {
      azkar = AzkarAndTsabeeh.tsabee7;
      title = "التسابيحُ";
      cubit.azkarTimes = List.filled(azkar.length, 0);
      checkInternetConnection(AppCubit.get(context),
          isPrayerTimesRequest: false);
    } else if (index == 4) {
      azkar = AzkarAndTsabeeh.ad3ya;
      title = "أدعية";
    } else if (index == 5) {
      title = "الأحاديث النبوية";
      if (!joinedHadeethsScreenBefore && internetConnection) {
        Future.delayed(
            const Duration(milliseconds: 150),
            () => {
                  onScreenOpen(context),
                });
        joinedHadeethsScreenBefore = true;
      } else if (!internetConnection && Hadeeth.hadeeths.isEmpty) {
        defaultFlutterToast(msg: "يرجي الاتصال بالانترنت لتحميل الأحاديث");
      }
    }

    return Scaffold(
      appBar: defaultAppBar(text: title),
      body: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                this.index == 5
                    ? awesomeDialog(context, title, Hadeeth.explanation[index],
                        dialogType: DialogType.question)
                    : null;
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 3.h),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.only(bottomRight: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                        color: defaultColor,
                        offset: const Offset(3, 3),
                        blurRadius: 7)
                  ],
                ),
                child: Column(
                  children: [
                    defaultText(
                        text: this.index == 5
                            ? Hadeeth.hadeeths[index]
                            : azkar[index],
                        textColor: Colors.black,
                        fontsize: 22,
                        fontWeight: FontWeight.bold,
                        txtDirection: TextDirection.rtl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (this.index == 5)
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                      text: this.index == 5
                                          ? Hadeeth.hadeeths[index]
                                          : azkar[index]))
                                  .then((value) {
                                Fluttertoast.showToast(
                                    msg: "تم النسخ", fontSize: 16.sp);
                              });
                            },
                            icon: const Icon(Icons.copy),
                            color: Colors.black.withOpacity(0.5),
                          ),
                        if (this.index == 3)
                          BlocBuilder<AppCubit, AppStates>(
                            builder: (context, state) {
                              return Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      cubit.clearTimes(index);
                                    },
                                    child: Container(
                                        height: 55.h,
                                        width: 50.w,
                                        decoration: BoxDecoration(
                                            color: defaultColor,
                                            shape: BoxShape.circle),
                                        child: const Icon(
                                          Icons.recycling,
                                          color: Colors.white,
                                          size: 30,
                                        )),
                                  ),
                                  SizedBox(
                                    width: 40.w,
                                  ),
                                  defaultText(
                                    text: "${cubit.azkarTimes[index]}",
                                    fontsize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    width: 40.w,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      cubit.incrementAzkarTimes(index);
                                    },
                                    child: Container(
                                        height: 55.h,
                                        width: 50.w,
                                        decoration: BoxDecoration(
                                            color: defaultColor,
                                            shape: BoxShape.circle),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 30,
                                        )),
                                  ),
                                ],
                              );
                            },
                          ),
                        SizedBox(
                          width: 12.w,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(
                height: 10.h,
              ),
          itemCount: index == 5 ? Hadeeth.hadeeths.length : azkar.length),
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/quran.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eqraa/components/components.dart';
import 'package:eqraa/components/constants.dart';
import 'package:eqraa/cubit/cubit.dart';
import 'package:eqraa/cubit/states.dart';
import 'package:eqraa/shared/cache_helper.dart';

class SurahScreen extends StatelessWidget {
  int surahNumber;

  SurahScreen({super.key, required this.surahNumber});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    List<int> numsOfPages = getSurahPages(surahNumber);
    String surahName = getSurahNameArabic(surahNumber);
    if (surahName == 'اللهب') {
      surahName = 'المسد';
    }

    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        final PageController pageController = PageController(
            initialPage: surahNameFromSharedPref != null &&
                    (surahName == surahNameFromSharedPref)
                ? pageNumberFromSharedPref! - numsOfPages[0]
                : 0);

        return SafeArea(
          child: Scaffold(
              appBar: defaultAppBar(text: surahName, actions: [
                IconButton(
                    onPressed: () {
                      if (CacheHelper.getData(key: "pageNumber") !=
                          cubit.currentPageNumber) {
                        CacheHelper.saveData(
                            key: "surahName", value: surahName);
                        CacheHelper.saveData(
                            key: "surahNumber", value: surahNumber);
                        CacheHelper.saveData(
                            key: "pageNumber", value: cubit.currentPageNumber);
                        surahNameFromSharedPref = surahName;
                        surahNumFromSharedPref = surahNumber;
                        pageNumberFromSharedPref = cubit.currentPageNumber;
                        defaultFlutterToast(
                            msg: "تم حفظ الصفحة",
                            backgroundColor: defaultColor);
                      } else {
                        CacheHelper.removeData(key: "surahName");
                        CacheHelper.removeData(key: "surahNumber");
                        CacheHelper.removeData(key: "pageNumber");
                        surahNameFromSharedPref = null;
                        surahNumFromSharedPref = 0;
                        pageNumberFromSharedPref = null;
                        defaultFlutterToast(msg: "تم الغاء حفظ الصفحة");
                      }
                    },
                    icon: const Icon(
                      Icons.bookmark,
                      color: Colors.white,
                      size: 30,
                    )),
                playIconButton(
                    cubit: cubit, surahNumber: surahNumber, context: context),
              ]),
              body: Directionality(
                textDirection: TextDirection.ltr,
                child: PageView.builder(
                  itemCount: numsOfPages.length,
                  reverse: true,
                  controller: pageController,
                  onPageChanged: (page) {
                    if (page == numsOfPages.length - 1) {
                      if (kDebugMode) {
                        print('surah is ended');
                      }
                      numsOfPages[page]++;
                    }
                  },
                  itemBuilder: (context, index) {
                    cubit.setCurrentPageNumber(numsOfPages[index]);

                    return Stack(
                        alignment: AlignmentDirectional.topStart,
                        children: [
                          Image.asset(
                              "assets/quranImages/${numsOfPages[index]}.png",
                              fit: BoxFit.fill,
                              width: double.infinity,
                              height: double.infinity),
                          if (index == pageController.initialPage &&
                              surahName == surahNameFromSharedPref)
                            Image.asset("assets/images/savedPageNumIcon.png",
                                height: 40.sp),
                        ]);
                  },
                ),
              )),
        );
      },
    );
  }
}

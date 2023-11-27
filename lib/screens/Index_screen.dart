import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:quran/quran.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eqraa/components/components.dart';
import 'package:eqraa/cubit/states.dart';
import 'package:eqraa/screens/surah_screen.dart';

import '../components/constants.dart';
import '../cubit/cubit.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    if (surahNameFromSharedPref != null) {
      Future.delayed(
          const Duration(milliseconds: 150),
          () => {
                AwesomeDialog(
                  barrierColor: Colors.black.withOpacity(0.5),
                  context: context,
                  dialogType: DialogType.noHeader,
                  animType: AnimType.scale,
                  title: 'هل تود الانتقال الي العلامة؟',
                  btnOkOnPress: () {
                    navigateTo(
                        context,
                        SurahScreen(
                          surahNumber: surahNumFromSharedPref!,
                        ));
                  },
                  btnOkText: 'نعم',
                  customHeader: Icon(
                    Icons.bookmark,
                    color: defaultColor,
                    size: 50,
                  ),
                  btnOkColor: defaultColor,
                  btnCancelOnPress: () {},
                  btnCancelText: 'لا',
                  btnCancelColor: Colors.red,
                )..show()
              });
    }
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(
            text: "القراّن الكريم",
            leading: IconButton(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (cubit.isPlaying) {
                  cubit.togglePlay();
                }
                Navigator.pop(context);
              },
            ),
          ),
          body: myPanel(
              screen: PopScope(
                onPopInvoked: (t) {
                  if (cubit.isPlaying) {
                    cubit.togglePlay();
                  }
                },
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  removeTop: true,
                  child: ListView.separated(
                      //padding: EdgeInsets.only(bottom: 30),
                      separatorBuilder: (context, index) => Column(
                            children: [
                              myDivider(),
                            ],
                          ),
                      itemCount: 114,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) => InkWell(
                            onTap: () async {
                              cubit.quranSoundActive = true;
                              // to not stop the audio when we navigate to the same surah
                              if (cubit.surahName !=
                                  getSurahNameArabic(index + 1)) {
                                FileInfo? cacheIsEmpty =
                                    await DefaultCacheManager()
                                        .getFileFromCache(
                                            "$quranSoundUrl${index + 1}.mp3");
                                if (cacheIsEmpty == null) {
                                  cubit.isCached = false;
                                  if (internetConnection) {
                                    cubit.setUrlQuranSoundSrcOnline(
                                        urlSrc:
                                            "$quranSoundUrl${index + 1}.mp3");
                                  }
                                } else {
                                  cubit.isCached = true;
                                  DefaultCacheManager()
                                      .getFileFromCache(
                                          "$quranSoundUrl${index + 1}.mp3")
                                      .then((value) {
                                    cubit.setUrlQuranSoundSrcOffline(
                                        urlSrc: value!.file.path);
                                  });
                                }
                                cubit.setSurahInfo(
                                    index + 1, getSurahNameArabic(index + 1));

                                if (cubit.isPlaying) {
                                  cubit.togglePlay();
                                }
                              }
                              if (context.mounted) {
                                navigateTo(context,
                                    SurahScreen(surahNumber: index + 1));
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 3.w),
                              child: Row(
                                textDirection: TextDirection.rtl,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: HexColor('22211f'),
                                    ),
                                    width: 25.w,
                                    height: 150.h,
                                    alignment: AlignmentDirectional.center,
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 13.w,
                                  ),
                                  defaultText(
                                    textAlign: TextAlign.right,
                                    text:
                                        getSurahNameArabic(index + 1) == 'اللهب'
                                            ? 'المسد'
                                            : getSurahNameArabic(index + 1),
                                    fontsize: 40,
                                  ),
                                  const Spacer(),
                                  Column(
                                    children: [
                                      defaultText(text: "آياتها", fontsize: 25),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      defaultText(
                                          text: '${getVerseCount(index + 1)}',
                                          fontsize: 18),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 18.w,
                                  ),
                                  Column(
                                    children: [
                                      defaultText(
                                          text:
                                              getPlaceOfRevelation(index + 1) ==
                                                      "Makkah"
                                                  ? "مكية"
                                                  : "مدنية",
                                          fontsize: 25),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      getPlaceOfRevelation(index + 1) ==
                                              "Makkah"
                                          ? Image(
                                              image: const AssetImage(
                                                  'assets/images/kaba.png'),
                                              width: 50.w,
                                            )
                                          : Image(
                                              image: const AssetImage(
                                                  'assets/images/MasjidElnabwy.png'),
                                              width: 50.w,
                                            ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                ],
                              ),
                            ),
                          ))),
                ),
              ),
              context: context,
              cubit: cubit),
        );
      },
    );
  }
}

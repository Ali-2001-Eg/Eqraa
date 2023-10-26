import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eqraa/components/components.dart';
import 'package:eqraa/cubit/states.dart';

import '../cubit/cubit.dart';

class AzanScreen extends StatelessWidget {
  const AzanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    String azan = "";
    if (cubit.azanElFajr) {
      azan = "الفَجرِ";
    } else if (cubit.azanElDuhr) {
      azan = "الظُّهرِ";
    } else if (cubit.azanElAsr) {
      azan = "العَصرِ";
    } else if (cubit.azanElMaghrib) {
      azan = "المغرِب";
    } else if (cubit.azanElIsha) {
      azan = "العِشَاءِ";
    }

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/Masjid.jpg'),
                      fit: BoxFit.cover),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 150),
                    child: Center(
                        child: defaultText(
                            text: "حان الآن موعد أذان $azan",
                            fontWeight: FontWeight.bold,
                            fontsize: 30,
                            textColor: Colors.white)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 65, 0, 0),
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                        onPressed: () {
                          cubit.azanSound.stop();
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ))),
              ),
            ],
          ),
        );
      },
    );
  }
}

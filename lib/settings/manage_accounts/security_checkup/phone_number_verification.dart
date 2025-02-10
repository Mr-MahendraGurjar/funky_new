import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:funky_project/Utils/asset_utils.dart';
// import 'package:funky_project/Utils/colorUtils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';

// import 'package:pinput/pin_put/pin_put.dart';

import '../../../Utils/asset_utils.dart';
import '../../../Utils/colorUtils.dart';
import '../../../Utils/custom_textfeild.dart';
import '../../../custom_widget/common_buttons.dart';
import '../../../dashboard/dashboard_screen.dart';
import 'security_checkup_controller.dart';

class MobileVerification extends StatefulWidget {
  const MobileVerification({super.key});

  @override
  State<MobileVerification> createState() => _MobileVerificationState();
}

class _MobileVerificationState extends State<MobileVerification> {
  final _security_checkup_screen_controller =
      Security_checkup_screen_controller();

  PageController? _pageController_customer;

  final TextEditingController _pinOTPController = TextEditingController();
  final FocusNode _pinOTPFocus = FocusNode();

  final BoxDecoration pinOTPDecoration = BoxDecoration(
    boxShadow: const [
      BoxShadow(
        color: Colors.black,
        blurRadius: 10,
        offset: Offset(0, 0),
        spreadRadius: -8,
      ),
    ],
    color: Colors.white,
    borderRadius: BorderRadius.circular(21),
  );
  final BoxDecoration pinOTPDecoration2 = BoxDecoration(
      boxShadow: const [
        BoxShadow(
          color: Colors.black,
          blurRadius: 10,
          offset: Offset(0, 0),
          spreadRadius: -8,
        ),
      ],
      color: Colors.white,
      borderRadius: BorderRadius.circular(21),
      border: Border.all(
        color: Colors.transparent,
      ));
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 30);

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    if (mounted) {
      setState(() {
        final seconds = myDuration.inSeconds - reduceSecondsBy;
        if (seconds < 0) {
          countdownTimer!.cancel();
          print('timesup');
        } else {
          myDuration = Duration(seconds: seconds);
        }
      });
    }
  }

  @override
  void initState() {
    _pageController_customer = PageController(initialPage: 0, keepPage: false);
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = myDuration.inSeconds.remainder(60);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Mobile phone number',
            style:
                TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
          ),
          centerTitle: true,
          leadingWidth: 100,
          leading: Padding(
            padding: const EdgeInsets.only(
              right: 20.0,
              top: 0.0,
              bottom: 5.0,
            ),
            child: ClipRRect(
                child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            )),
          ),
        ),
        body: GetBuilder<Security_checkup_screen_controller>(
          init: _security_checkup_screen_controller,
          builder: (_) {
            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.white,
                  height: 5,
                  child: Container(
                    margin: EdgeInsets.only(
                        right: (_security_checkup_screen_controller
                                    .pageIndex_mobile ==
                                '01'
                            ? MediaQuery.of(context).size.width / 1.5
                            : (_security_checkup_screen_controller
                                        .pageIndex_mobile ==
                                    '02'
                                ? MediaQuery.of(context).size.width / 3
                                : 0))),
                    color: HexColor(CommonColor.pinkFont),
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController_customer,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 51,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(left: 54),
                                child: Text(
                                  'Update your Mobile phone number',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: HexColor(CommonColor.pinkFont),
                                      fontFamily: 'PR'),
                                ),
                              ),
                              const SizedBox(
                                height: 51,
                              ),
                              CommonTextFormField(
                                controller: _security_checkup_screen_controller
                                    .mobile_controller,
                                title: 'Enter Mobile phone number',
                                labelText: 'Enter phone number',
                                image_path: AssetUtils.msg_icon,
                              ),
                              const SizedBox(
                                height: 51,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await _security_checkup_screen_controller
                                      .UpdateEmailPhone(
                                          context: context,
                                          email_phone:
                                              _security_checkup_screen_controller
                                                  .mobile_controller.text,
                                          type: 'phone');
                                  if (_security_checkup_screen_controller
                                          .updateEmailPhoneModel!.error ==
                                      false) {
                                    setState(() {
                                      _security_checkup_screen_controller
                                          .pageIndexUpdatephone('02');
                                      _pageController_customer!.jumpToPage(1);
                                    });
                                    print(_security_checkup_screen_controller
                                        .pageIndex_mobile);
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Colors.white),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 13, horizontal: 26),
                                    child: Text(
                                      'Next',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontFamily: 'PR'),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 96,
                            ),
                            Container(
                              child: const Text(
                                'Enter Otp',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'PB',
                                    color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              height: 41,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 30, right: 30),
                              child: Pinput(
                                length: 4,
                                // textStyle: TextStyle(fontFamily: 'PR', fontSize: 32, color: Colors.black),
                                // eachFieldHeight: 60,
                                // eachFieldWidth: 60,
                                // eachFieldMargin: EdgeInsets.all(7),
                                focusNode: _pinOTPFocus,
                                controller: _pinOTPController,
                                // submittedFieldDecoration: pinOTPDecoration,
                                // selectedFieldDecoration: pinOTPDecoration,
                                // followingFieldDecoration: pinOTPDecoration2,
                                pinAnimationType: PinAnimationType.rotation,
                              ),
                            ),
                            const SizedBox(
                              height: 35,
                            ),
                            Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$seconds',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'PB',
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                  AssetUtils.timer_icon,
                                  width: 22,
                                  height: 22,
                                  fit: BoxFit.fill,
                                ),
                              ],
                            )),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(right: 20, left: 20),
                              child: common_button(
                                onTap: () async {
                                  await _security_checkup_screen_controller
                                      .VerifyEmailPhone(
                                          context: context,
                                          email_phone:
                                              _security_checkup_screen_controller
                                                  .mobile_controller.text,
                                          type: 'phone',
                                          otp: _pinOTPController.text);
                                  if (_security_checkup_screen_controller
                                          .verifyEmailPhoneModel!.error ==
                                      false) {
                                    selectTowerBottomSheet(context);
                                  }
                                  // _kids_loginScreenController.ParentEmailVerification(context);
                                },
                                backgroud_color: HexColor(CommonColor.pinkFont),
                                lable_text: 'Verify',
                                lable_text_color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  selectTowerBottomSheet(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: StatefulBuilder(
            builder: (context, state) {
              return Container(
                height: screenheight * 0.43,
                width: screenwidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    // stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      HexColor("#C12265"),
                      HexColor("#000000"),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23.9),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(23),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Icon(
                            Icons.check,
                            size: 40,
                          ),
                        ),
                      ),
                      Container(
                        child: const Text(
                          'Your email has been updated',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'PR',
                              color: Colors.white),
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 40),
                          child: common_button(
                            onTap: () {
                              Get.to(Dashboard(page: 0));
                              // selectTowerBottomSheet(context);
                              // _kids_loginScreenController.ParentEmailVerification(context);
                            },
                            backgroud_color: Colors.white,
                            lable_text: 'Ge to Dashboard',
                            lable_text_color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

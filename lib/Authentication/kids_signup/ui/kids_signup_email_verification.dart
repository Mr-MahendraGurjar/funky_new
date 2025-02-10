import 'package:flutter/material.dart';
import 'package:funky_new/Authentication/kids_signup/controller/kids_signup_controller.dart';
// import 'package:funky_project/Authentication/kids_login/controller/kids_login_controller.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../Utils/asset_utils.dart';
import '../../../Utils/custom_textfeild.dart';
import '../../../custom_widget/common_buttons.dart';

class kids_signup_Email_verification extends StatefulWidget {
  const kids_signup_Email_verification({Key? key}) : super(key: key);

  @override
  State<kids_signup_Email_verification> createState() => _kids_signup_Email_verificationState();
}

class _kids_signup_Email_verificationState extends State<kids_signup_Email_verification> {
  final _kids_signupScreenController = Get.put(Kids_signup_controller());

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          // decoration: BoxDecoration(
          //
          //   image: DecorationImage(
          //     image: AssetImage(AssetUtils.backgroundImage), // <-- BACKGROUND IMAGE
          //     fit: BoxFit.cover,
          //   ),
          // ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000").withOpacity(0.67),
                HexColor("#000000").withOpacity(0.67),
                HexColor("#C12265").withOpacity(0.67),
                HexColor("#FFFFFF").withOpacity(0.67),
              ],
            ),
            image: new DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
              image: new AssetImage(
                AssetUtils.backgroundImage2,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            // extendBodyBehindAppBar: true,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Parent Verification',
                style: TextStyle(fontSize: 16, fontFamily: 'PB', color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Container(
                width: screenwidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // SizedBox(height: 60,),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 86,
                      ),
                      child: Image.asset(
                        AssetUtils.logo,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 30,
                      ),
                      child: Text(
                        'Enter Parents email',
                        style: TextStyle(fontSize: 16, fontFamily: 'PB', color: Colors.white),
                      ),
                    ),

                    CommonTextFormField(
                      controller: _kids_signupScreenController.parentEmail_controller,
                      title: 'Email',
                      labelText: 'Enter Email',
                      image_path: AssetUtils.chat_icon,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    common_button(
                      onTap: () {
                        _kids_signupScreenController.ParentEmailVerification(context);
                      },
                      backgroud_color: Colors.black,
                      lable_text: 'Next',
                      lable_text_color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

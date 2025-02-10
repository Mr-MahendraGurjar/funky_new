import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../Utils/App_utils.dart';
import '../../Utils/asset_utils.dart';
import '../../custom_widget/common_buttons.dart';
import '../../custom_widget/page_loader.dart';
import '../../sharePreference.dart';
import '../dashboard_screen.dart';

class Story_image_preview extends StatefulWidget {
  // final bool isImage;
  final List<XFile>? ImageFile;
  final File? single_image;
  final bool? single;

  const Story_image_preview({
    super.key,
    this.ImageFile,
    this.single_image,
    this.single,
  });

  @override
  State<Story_image_preview> createState() => _Story_image_previewState();
}

class _Story_image_previewState extends State<Story_image_preview> {
  bool valuefirst = false;
  TextEditingController title_controller = TextEditingController();
  bool isClicked = false; // boolean that states if the button is pressed or not
  VideoPlayerController? video_controller;

  @override
  void initState() {
    super.initState();
    // print('image urlllllllllllll ${widget.ImageFile!}');
    // video_controller = VideoPlayerController.file(widget.ImageFile!);
    if (widget.single != true) {
      init();
    } else {
      thumb();
    }
    // video_controller!.setLooping(true);
    // video_controller!.initialize().then((_) {
    //   setState(() {});
    // });
    // video_controller!.pause();
  }

  List<String> format = [];

  init() {
    for (var i = 0; i < widget.ImageFile!.length; i++) {
      var fileFormat = widget.ImageFile![i].path
          .substring(widget.ImageFile![i].path.lastIndexOf('.'));

      format.add(fileFormat);
      print(format);
    }
  }

  File? thumbnail;

  thumb() async {
    print("inside thumb data");
    var fileFormat = widget.single_image!.path
        .substring(widget.single_image!.path.lastIndexOf('.'));
    print(fileFormat);
    if (fileFormat == '.mp4' || fileFormat == '.MP4' || fileFormat == '.MOV') {
      final uint8list = await VideoThumbnail.thumbnailFile(
        video: widget.single_image!.path,
        // thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 64,
        // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 75,
      );
      print(uint8list);
      setState(() {
        thumbnail = File(uint8list!);
      });
    }
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
    video_controller!.dispose();
  }

  share_icon() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Share your story",
            style:
                TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'PM')),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: common_button(
              onTap: () {
                uploadImage();
                // Get.toNamed(BindingUtils.signupOption);
              },
              backgroud_color: Colors.black,
              lable_text: 'Share',
              lable_text_color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              'Post Story',
              style: TextStyle(
                  fontSize: 16, color: Colors.white, fontFamily: 'PB'),
            ),
            centerTitle: true,
            // leadingWidth: 100,
            // leading: IconButton(
            //     padding: EdgeInsets.zero,
            //     onPressed: () {
            //       print('oject');
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => Dashboard(page: 3)));
            //       // Navigator.pop(context);
            //     },
            //     icon: Icon(
            //       Icons.arrow_back_outlined,
            //       color: Colors.white,
            //     )),
            actions: [
              InkWell(
                onTap: () {
                  share_icon();
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset(
                    AssetUtils.share_icon3,
                    color: Colors.white,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // width: 300,
                    child: TextFormField(
                      maxLength: 20,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 20, top: 14, bottom: 14),
                        alignLabelWithHint: false,
                        isDense: true,
                        labelText: 'Title',
                        counterStyle: TextStyle(
                          height: double.minPositive,
                        ),
                        filled: true,
                        border: InputBorder.none,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffE84F90)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffE84F90),
                          ),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'PR',
                          color: Color(0xffE84F90),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'PR',
                        color: Colors.black,
                      ),
                      controller: title_controller,
                      // keyboardType: keyboardType ?? TextInputType.multiline,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // (widget.isImage
                  //     ?
                  // Container(
                  //         child: Image.file(
                  //           widget.ImageFile!,
                  //         ),
                  //       ),
                  (widget.single!
                      ? (thumbnail != null
                          ? Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                      color: Colors.white,
                                      height: 200,
                                      width: 200,
                                      child: Image.file(
                                        thumbnail!,
                                        fit: BoxFit.contain,
                                      )),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Colors.pink,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Image.file(widget.single_image!))
                      : GridView.builder(
                          shrinkWrap: true,
                          itemCount: widget.ImageFile!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      // border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: (format[index] == '.jpg'
                                        ? Image.file(
                                            File(widget.ImageFile![index].path),
                                            fit: BoxFit.cover,
                                          )
                                        : Center(
                                            child: Stack(
                                            children: [
                                              Image.asset(
                                                AssetUtils.logo_trans,
                                                height: 50,
                                                width: 50,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                                child: const Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.pink,
                                                ),
                                              ),
                                            ],
                                          ))),
                                  ),
                                ],
                              ),
                            );
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, childAspectRatio: 4 / 5),
                        )),
                  // : GestureDetector(
                  //     onTap: () {
                  //       print('hello');
                  //       isClicked = isClicked ? false : true;
                  //       print(isClicked);
                  //       if (video_controller!.value.isPlaying) {
                  //         video_controller!.pause();
                  //       } else {
                  //         video_controller!.play();
                  //       }
                  //     },
                  //     child: Container(
                  //       // color: Colors.white,
                  //       margin: EdgeInsets.symmetric(
                  //           horizontal: 20, vertical: 0),
                  //       width: MediaQuery.of(context).size.width,
                  //       height: MediaQuery.of(context).size.height / 1.2,
                  //       child: Align(
                  //         alignment: Alignment.topCenter,
                  //         child: AspectRatio(
                  //             aspectRatio:
                  //                 video_controller!.value.aspectRatio,
                  //             child: VideoPlayer(video_controller!)),
                  //       ),
                  //     ),
                  //   )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Map<String, String>? data;
  String? hireID;

  Future<dynamic> uploadImage() async {
    try {
      showLoader(context);
      String idUser = await PreferenceManager().getPref(URLConstants.id);
      var url = (URLConstants.base_url + URLConstants.StoryPostApi);
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // data=
      // {
      //   "story_photo[]" : hireID!,
      //
      // };
      //
      // for(int i=0;i< widget.ImageFile!.length ;i++){
      //   data!.addAll(
      //   {
      //     "story_photo[]" : widget.ImageFile![i].path,
      //   }
      //   );
      // }

      // print("IIIiiiiIIIIII ${widget.ImageFile!.path}");
      if (widget.single == true) {
        print("sinfle imageee fileee");
        print(widget.single_image!.path);
        var files2 = await http.MultipartFile.fromPath(
            'story_photo[]', widget.single_image!.path,
            contentType: MediaType('image', 'png'));

        request.files.add(files2);
      } else {
        for (var i = 0; i < widget.ImageFile!.length; i++) {
          var fileFormat = widget.ImageFile![i].path
              .substring(widget.ImageFile![i].path.lastIndexOf('.'));
          print(fileFormat);
          print("widget.ImageFile![i].path ${widget.ImageFile![i].path}");
          // if(file_format == '.png' || file_format ==  '.jpg'){
          print("inside image path");
          var files = await http.MultipartFile.fromPath(
              'story_photo[]', widget.ImageFile![i].path);
          request.files.add(files);
        }
      }
      // request.files.add(files);
      // request.fields['uploadVideo'] = '';
      print('user id $idUser');
      request.fields['userId'] = idUser;
      request.fields['title'] = title_controller.text;
      request.fields['isVideo'] = 'false';
      request.fields['token'] = '';
      // request.fields['isVideo'] = '';

      //userId,tagLine,description,address,postImage,uploadVideo,isVideo
      // request.files.add(await http.MultipartFile.fromPath(
      //     "image", widget.ImageFile!.path));

      var response = await request.send();

      var responsed = await http.Response.fromStream(response);
      print('response: ${responsed.body}');
      final responseData = json.decode(responsed.body);
      debugPrint("response.statusCode");
      debugPrint(response.statusCode.toString());
      debugPrint(response.statusCode.toString());

      if (response.statusCode == 200) {
        debugPrint("SUCCESS");
        debugPrint(response.reasonPhrase);
        // print(widget.ImageFile!.path);
        if (kDebugMode) {
          print(responseData);
        }
        hideLoader(context);
        await Get.to(Dashboard(
          page: 3,
        ));
      } else {
        print("ERROR");
      }
    } catch (e) {
      print("error $e");
      hideLoader(context);
      await Get.to(Dashboard(
        page: 3,
      ));
    }
  }
}

import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

import '../Utils/colorUtils.dart';
import '../Utils/toaster_widget.dart';
import '../profile_screen/story_view/view_selected_image.dart';
import 'controller/post_screen_controller.dart';
import 'story_/stories_editor.dart';
import 'story_/story_image_preview.dart';

class Post_story_Screen extends StatefulWidget {
  const Post_story_Screen({super.key});

  @override
  Post_story_ScreenState createState() => Post_story_ScreenState();
}

class Post_story_ScreenState extends State<Post_story_Screen> {
  PageController? _pageController;

  final _post_screen_controller = Get.put(DashboardScreenController());
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _requestPermissions();
    //_fetchAssets();
    _pageController = PageController(initialPage: 0, keepPage: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  // void _showDialog() {
  //   // flutter defined function
  //   ElevatedButton(
  //     onPressed: () async {
  //       final permitted = await PhotoManager.requestPermission();
  //       if (!permitted) return;
  //      ;
  //       // Navigator.of(context).push(
  //       //   MaterialPageRoute(builder: (_) => Gallery()),
  //       // );
  //     },
  //     child: Text('Open Gallery'),
  //   );
  // }
  List<Course> corcess = List.empty(growable: true);

  List<AssetEntity> assets = [];

  // var data_type = PhotoManager.getImageAsset();
  var data_type = PhotoManager.getAssetPathList(type: RequestType.image);
  void _requestPermissions() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    if (ps.isAuth) {
      // Granted.
      _fetchAssets();
    } else {
      // Rejected.

      PhotoManager.openSetting();
    }
  }

  _fetchAssets() async {
    data_list = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.all);
    // List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true);
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    // final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    // final albums = await data_type;
    final recentAlbum = data_list.first;
    // Now that we got the album, fetch all the assets it contains
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1000000, // end at a very big index (to get all the assets)
    );
    // Update the state and notify UI
    setState(() => assets = recentAssets);
  }

  List<AssetPathEntity> data_list = [];
  AssetPathEntity? selected_data_type;

  BoxFit fitting = BoxFit.scaleDown;
  var ImgB64Decoder;
  VideoPlayerController? _controller;

  Future<VideoPlayerController> video() async {
    print("object");
    final File file = File(_post_screen_controller.file_selected_video.value);
    _controller = VideoPlayerController.file(file);
    await _controller!.initialize();
    await _controller!.setLooping(true);
    print("_controller");
    print("controller");
    print(_controller);
    return _controller!;
  }

  @override
  dispose() {
    _controller!.dispose();
    super.dispose();
  }

  final List<File> _images = <File>[];

  HashSet selectItems = HashSet();

  void doMultiSelection(String path) {
    setState(() {
      if (selectItems.contains(path)) {
        selectItems.remove(path);
      } else {
        selectItems.add(path);
      }
    });
  }

  final List<String> _imageList = [];
  List<XFile> file_list = [];

  final List<int> _selectedIndexList = [];
  final List<Future<File?>> _selectedList = [];

  bool _selectionMode = true;

  void _changeSelection({bool? enable, int? index}) {
    _selectionMode = enable!;
    _selectedIndexList.add(index!);
    _selectedList.add(assets[index].file);

    if (index == -1) {
      _selectedIndexList.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //       // stops: [0.1, 0.5, 0.7, 0.9],
        //       colors: [
        //         HexColor("#C12265"),
        //         HexColor("#000000"),
        //         HexColor("#000000"),
        //         // HexColor("#FFFFFF").withOpacity(0.67),
        //       ],
        //     ),
        //   ),
        // ),
        Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.black,
            // flexibleSpace: Container(
            //   decoration: const BoxDecoration(
            //    color: Colors.black
            //   ),
            // ),
            leadingWidth: 400,
            elevation: 0.0,
            // leading: Center(
            //   // margin: EdgeInsets.only(left: 20,top: 30),
            //   child: GestureDetector(
            //     onTap: () {
            //       Navigator.pop(context);
            //       // Get.to(Dashboard());
            //     },
            //     child: Text(
            //       'Cancel',
            //       style: TextStyle(
            //           fontSize: 14,
            //           color: Colors.black,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            centerTitle: true,
            // title: FormField<String>(
            //   builder: (FormFieldState<String> state) {
            //     return DropdownButtonHideUnderline(
            //       child: DropdownButton2(
            //         isExpanded: true,
            //         hint: Row(
            //           children: [
            //             SizedBox(
            //               width: 4,
            //             ),
            //             Expanded(
            //               child: Text(
            //                 'Recent',
            //                 style: TextStyle(
            //                     fontSize: 16,
            //                     color: Colors.black,
            //                     fontWeight: FontWeight.bold),
            //                 overflow: TextOverflow.ellipsis,
            //               ),
            //             ),
            //           ],
            //         ),
            //         items: data_list
            //             .map((item) => DropdownMenuItem<AssetPathEntity>(
            //                   value: item,
            //                   child: Text(
            //                     item.name,
            //                     style: TextStyle(
            //                         fontSize: 14,
            //                         color: Colors.black,
            //                         fontWeight: FontWeight.bold),
            //                     overflow: TextOverflow.ellipsis,
            //                   ),
            //                 ))
            //             .toList(),
            //         value: selected_data_type,
            //         onChanged: (value) {
            //           setState(() {
            //             print(value);
            //             selected_data_type!.name = value.toString();
            //             // (selected_data_type == "Images"
            //             //     ? data_type = PhoManager.getImageAsset()
            //             //     : data_type = PhotoManager.getVideoAsset());
            //             _fetchAssets();
            //           });
            //         },
            //         iconSize: 25,
            //         // icon: SvgPicture.asset(AssetUtils.drop_svg),
            //         iconEnabledColor: Color(0xff007DEF),
            //         iconDisabledColor: Color(0xff007DEF),
            //         buttonHeight: 50,
            //         buttonWidth: 160,
            //         buttonPadding: const EdgeInsets.only(left: 0, right: 80),
            //         buttonDecoration:
            //             BoxDecoration(color: Colors.transparent),
            //         buttonElevation: 0,
            //         itemHeight: 40,
            //         itemPadding: const EdgeInsets.only(left: 14, right: 14),
            //         dropdownMaxHeight: 200,
            //         dropdownPadding: null,
            //         dropdownDecoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           color: Colors.white,
            //         ),
            //         dropdownElevation: 8,
            //         scrollbarRadius: const Radius.circular(40),
            //         scrollbarThickness: 6,
            //         scrollbarAlwaysShow: true,
            //         offset: const Offset(10, 0),
            //       ),
            //     );
            //   },
            // ),
            title: const Text(
              'Add Story',
              style: TextStyle(fontSize: 16, fontFamily: 'PM'),
            ),
            actions: [
              Center(
                child: GestureDetector(
                  onTap: () async {
                    // _post_screen_controller.pageIndexUpdate('02');
                    // _pageController!.jumpToPage(1);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ViewImageSelected(
                    //               imageData: _images,
                    //             )));
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ImageEditor(
                    //       image: Uint8List.fromList(_post_screen_controller
                    //           .file_selected_image.codeUnits),
                    //     ),
                    //   ),
                    // ).then((editedImage) async {
                    //   if (editedImage != null) {
                    //     setState(() {
                    //       _post_screen_controller.file_selected_image =
                    //           editedImage;
                    //       // imgFile = editedImage;
                    //       print(
                    //           " _post_screen_controller.file_selected_image ${_post_screen_controller.file_selected_image}");
                    //       String base64String = base64Encode(editedImage);
                    //       final decodedBytes = base64Decode(base64String);
                    //       File file = File.fromRawPath(editedImage);
                    //       file.writeAsBytesSync(decodedBytes);
                    //       print(file.path.split('/').last);
                    //     });
                    //     await Get.to(PostImagePreviewScreen(
                    //       ImageFile: editedImage!,
                    //     ));
                    //   }
                    // }).catchError((er) {
                    //   print(er);
                    // });
                    // showLoader(context);
                    for (var i = 0; i < _selectedList.length; i++) {
                      await _selectedList[i].then((value) {
                        file_list.add(XFile(value!.path));
                      });
                      // print(file_list);
                    }
                    // hideLoader(context);
                    print("file_list.length ${file_list.length}");
                    if (file_list.isNotEmpty) {
                      if (file_list.length == 1) {
                        File editedFile =
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => StoriesEditor(
                                      // fontFamilyList: font_family,
                                      giphyKey:
                                          'https://giphy.com/gifs/congratulations-congrats-xT0xezQGU5xCDJuCPe',
                                      imageData: File(file_list[0].path),
                                      onDone: (String) {},
                                      // filePath:
                                      //     imgFile!.path,
                                    )));
                        print('editedFile: ${editedFile.path}');
                        Get.to(Story_image_preview(
                          single_image: File(editedFile.path),
                          single: true,
                          // isImage: true,
                        ));
                      } else {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewImageSelected(
                                      imageData: file_list,
                                    )));
                      }
                    } else {
                      CommonWidget()
                          .showToaster(msg: 'Please select the image');
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                        child: Text(
                          'Next',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PM',
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Container(
            margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
            child: GetBuilder<DashboardScreenController>(
              init: _post_screen_controller,
              builder: (_) {
                return PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Column(
                      children: [
                        SizedBox(height: (screenSize.height * 0.118)),
                        // Obx(
                        //   () => Container(
                        //       height: screenSize.height / 3,
                        //       width: screenSize.width,
                        //       child: (_post_screen_controller
                        //                   .selected_item.value
                        //                   .toString() ==
                        //               'Image'
                        //           ? Image.memory(
                        //               Uint8List.fromList(_post_screen_controller
                        //                   .file_selected_image.codeUnits),
                        //               fit: fitting,
                        //             )
                        //           : (_post_screen_controller.selected_item.value
                        //                       .toString() ==
                        //                   'Video'
                        //               ? Container(
                        //                   height: 50,
                        //                   child: Text(_post_screen_controller
                        //                       .file_selected_video.value
                        //                       .toString()))
                        //               : Text('no image found')))),
                        // ),
                        // Container(
                        //   alignment: Alignment.bottomRight,
                        //   child: IconButton(
                        //     visualDensity: VisualDensity(horizontal: -4,vertical: 0),
                        //     onPressed: () {
                        //       setState(() {
                        //         (fitting == BoxFit.scaleDown
                        //             ? fitting = BoxFit.fitWidth
                        //             : (fitting == BoxFit.fitWidth
                        //             ? fitting = BoxFit.scaleDown
                        //             : fitting = BoxFit.scaleDown));
                        //         // fitting = BoxFit.fitWidth;
                        //       });
                        //     },
                        //     icon: Icon(Icons.check_box_outline_blank,color: Colors.white,),
                        //   ),
                        // ),
                        Expanded(
                          child: Container(
                            // color: Colors.black,
                            child: GridView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(5),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                // A grid view with 3 items per row
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                crossAxisCount: 3,
                              ),
                              itemCount: assets.length,
                              itemBuilder: (_, index) {
                                return FutureBuilder<Uint8List?>(
                                  future: (assets[index].type == AssetType.image
                                      ? assets[index].thumbnailData
                                      : assets[index].thumbnailData),
                                  builder: (widget, snapshot) {
                                    final bytes = snapshot.data;
                                    // If we have no data, display a spinner
                                    // if (bytes == null) {
                                    //   return const SizedBox(
                                    //     height: 20,
                                    //     width: 20,
                                    //     child: Padding(
                                    //       padding: EdgeInsets.all(25.0),
                                    //       child: CircularProgressIndicator(
                                    //         color: Colors.red,
                                    //       ),
                                    //     ),
                                    //   );
                                    // } else {
                                    //   return
                                    //     InkWell(
                                    //     onTap: () async {
                                    //       if (assets[index].type ==
                                    //           AssetType.image) {
                                    //         print("asset.file");
                                    //         // print(bytes);
                                    //         print(snapshot.data);
                                    //         Uint8List? imageInUnit8List = snapshot
                                    //             .data; // store unit8List image here ;
                                    //         final tempDir =
                                    //             await getTemporaryDirectory();
                                    //         File file = await File(
                                    //                 '${tempDir.path}/image.png')
                                    //             .create();
                                    //         file.writeAsBytesSync(
                                    //             imageInUnit8List!);
                                    //         print(file.path);
                                    //         _images.add(file);
                                    //         print(_images.length);
                                    //         // poster.selected_item.value = 'Image';
                                    //         // poster.file_selected_image.value = String.fromCharCodes(bytes);
                                    //         // print(
                                    //         //     "Uint8List.fromList(_post_screen_controller ${Uint8List.fromList(poster.file_selected_image.codeUnits)}");
                                    //         // poster.image = bytes;
                                    //         // setState(() {
                                    //         //   if (_selectItem == false) {
                                    //         //     _selectItem = true;
                                    //         //     print("Item Selected");
                                    //         //   } else {
                                    //         //     _selectItem = false;
                                    //         //     print("Item UnSelected");
                                    //         //   }
                                    //         // });
                                    //       } else {
                                    //         print("video.file");
                                    //         print(bytes);
                                    //         print(assets[index].file);
                                    //         // poster.selected_item.value = 'Video';
                                    //
                                    //         // poster.file_selected_video.value = String.fromCharCodes(bytes);
                                    //         print("PostScreenState().video()");
                                    //         // print(poster.file_selected_video.value.toString());
                                    //         // PostScreenState().video();
                                    //       }
                                    //       // Navigator.push(
                                    //       //   context,
                                    //       //   MaterialPageRoute(
                                    //       //     builder: (_) {
                                    //       //       if (asset.type == AssetType.image) {
                                    //       //         poster.file_selected.value = asset.file.toString();
                                    //       //         // return ImageScreen(imageFile: asset.file);
                                    //       //       } else {
                                    //       //         return VideoScreen(videoFile: asset.file);
                                    //       //       }
                                    //       //     },
                                    //       //   ),
                                    //       // );
                                    //     },
                                    //     child: Stack(
                                    //       children: [
                                    //         Positioned.fill(
                                    //           child: Container(
                                    //               color: Colors.white,
                                    //               child: Image.memory(
                                    //                   bytes,
                                    //                   colorBlendMode:
                                    //                       BlendMode.color,
                                    //                   fit: BoxFit.cover)),
                                    //         ),
                                    //         if (assets[index].type ==
                                    //             AssetType.video)
                                    //           Center(
                                    //             child: Container(
                                    //               color: Colors.blue,
                                    //               child: Icon(
                                    //                 Icons.play_arrow,
                                    //                 color: Colors.white,
                                    //               ),
                                    //             ),
                                    //           ),
                                    //       ],
                                    //     ),
                                    //   );
                                    // }
                                    if (bytes == null) {
                                      return Container(
                                          color: Colors.transparent,
                                          height: 80,
                                          width: 200,
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  // color: Colors.pink,
                                                  backgroundColor: HexColor(
                                                      CommonColor.pinkFont),
                                                  valueColor:
                                                      const AlwaysStoppedAnimation<
                                                          Color>(
                                                    Colors
                                                        .white70, //<-- SEE HERE
                                                  ),
                                                ),
                                                // Text('Loading...',style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'PR'),)
                                              ],
                                            ),
                                          )
                                          // Material(
                                          //   color: Colors.transparent,
                                          //   child: LoadingIndicator(
                                          //     backgroundColor: Colors.transparent,
                                          //     indicatorType: Indicator.ballScale,
                                          //     colors: _kDefaultRainbowColors,
                                          //     strokeWidth: 4.0,
                                          //     pathBackgroundColor: Colors.yellow,
                                          //     // showPathBackground ? Colors.black45 : null,
                                          //   ),
                                          // ),
                                          );
                                    } else {
                                      if (_selectionMode) {
                                        return GridTile(
                                            header: GridTileBar(
                                              leading: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (_selectedIndexList
                                                        .contains(index)) {
                                                      _selectedIndexList
                                                          .remove(index);
                                                      _selectedList.remove(
                                                          assets[index].file);
                                                    } else {
                                                      _selectedIndexList
                                                          .add(index);
                                                      _selectedList.add(
                                                          assets[index].file);
                                                    }
                                                  });
                                                  print(
                                                      "_selectedIndexList.length : ${_selectedIndexList.length}");
                                                },
                                                child: Icon(
                                                  _selectedIndexList
                                                          .contains(index)
                                                      ? Icons.check_circle
                                                      : Icons
                                                          .radio_button_unchecked_outlined,
                                                  color: _selectedIndexList
                                                          .contains(index)
                                                      ? Colors.pink
                                                      : Colors.white,
                                                ),
                                              ),
                                            ),
                                            child: GestureDetector(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Colors.transparent,
                                                        width: 0.0)),
                                                child: Stack(
                                                  children: [
                                                    Positioned.fill(
                                                      child: Image.memory(
                                                        bytes,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    if (assets[index].type ==
                                                        AssetType.video)
                                                      Center(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .black54,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100)),
                                                          child: const Icon(
                                                            Icons.play_arrow,
                                                            color: Colors.pink,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () async {
                                                if (_selectedIndexList
                                                    .isEmpty) {
                                                  _selectedIndexList.add(index);
                                                  _selectedList
                                                      .add(assets[index].file);

                                                  for (var i = 0;
                                                      i < _selectedList.length;
                                                      i++) {
                                                    await _selectedList[i]
                                                        .then((value) {
                                                      file_list.add(
                                                          XFile(value!.path));
                                                    });
                                                    // print(file_list);
                                                  }
                                                  File editedFile = await Navigator
                                                          .of(context)
                                                      .push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              StoriesEditor(
                                                                // fontFamilyList: font_family,
                                                                giphyKey:
                                                                    'https://giphy.com/gifs/congratulations-congrats-xT0xezQGU5xCDJuCPe',
                                                                imageData: File(
                                                                    file_list[0]
                                                                        .path),
                                                                onDone:
                                                                    (String) {},
                                                                // filePath:
                                                                //     imgFile!.path,
                                                              )));
                                                  print(
                                                      'editedFile: ${editedFile.path}');
                                                  Get.to(Story_image_preview(
                                                    single_image:
                                                        File(editedFile.path),
                                                    single: true,
                                                    // isImage: true,
                                                  ));
                                                }

                                                print(
                                                    "_selectedIndexList.length : ${_selectedIndexList.length}");
                                              },
                                            ));
                                      } else {
                                        return GridTile(
                                          child: InkResponse(
                                            child: Stack(
                                              children: [
                                                Positioned.fill(
                                                  child: Image.memory(
                                                    bytes,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                if (assets[index].type ==
                                                    AssetType.video)
                                                  Center(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.black54,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        child: Icon(
                                                          Icons.play_arrow,
                                                          color: Colors.pink,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            onLongPress: () async {
                                              setState(() {
                                                _changeSelection(
                                                    enable: true, index: index);
                                              });
                                            },
                                          ),
                                        );
                                      }
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Column(
                    //   children: [
                    //     Obx(
                    //           () => Container(
                    //           height: screenSize.height / 3,
                    //           width: screenSize.width,
                    //           child: (_post_screen_controller
                    //               .file_selected_image.value
                    //               .toString() !=
                    //               '_')
                    //               ? Image.memory(
                    //             Uint8List.fromList(_post_screen_controller
                    //                 .file_selected_image.codeUnits),
                    //             fit: fitting,
                    //           )
                    //               : Text('no image found')),
                    //     ),
                    //     // SizedBox(
                    //     //   height: screenSize.height * 0.059,
                    //     // ),
                    //     Container(
                    //       margin: EdgeInsets.only(right: 20, left: 20, top: 30),
                    //       child: custom_login_feild(
                    //         backgroundColor: ColorUtils.white,
                    //         labelText: 'Enter Your title',
                    //       ),
                    //     ),
                    //     Container(
                    //       margin: EdgeInsets.only(right: 20, left: 20, top: 15),
                    //       height: 100,
                    //       child: custom_login_feild(
                    //         maxLines: 4,
                    //         backgroundColor: ColorUtils.white,
                    //         labelText: 'Say something about this photo',
                    //       ),
                    //     ), Container(
                    //       margin: EdgeInsets.only(right: 20, left: 20, top: 15),
                    //       child: custom_login_feild(
                    //         // maxLines: 4,
                    //         backgroundColor: ColorUtils.white,
                    //         labelText: 'Add Thumbnail for video',
                    //       ),
                    //     ),
                    //   ],
                    // )
                  ],
                );
              },
            ),
          ),
          // bottomNavigationBar: Container(
          //   // color: Colors.black,
          //   height: 50,
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topRight,
          //       end: Alignment.bottomLeft,
          //       // stops: [0.1, 0.5, 0.7, 0.9],
          //       colors: [
          //         HexColor("#C12265"),
          //         HexColor("#000000"),
          //         HexColor("#000000"),
          //         HexColor("#C12265"),
          //         // HexColor("#FFFFFF").withOpacity(0.67),
          //       ],
          //     ),
          //   ),
          //   // margin: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Expanded(
          //         child: Container(
          //           alignment: Alignment.center,
          //           child: Text("Library",
          //               style: TextStyle(
          //                   fontSize: 14,
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.bold)),
          //         ),
          //       ),
          //       Expanded(
          //         child: GestureDetector(
          //           onTap: () {
          //             data_type = PhotoManager.getImageAsset();
          //             _fetchAssets();
          //           },
          //           child: Container(
          //             alignment: Alignment.center,
          //             child: Text("Photo",
          //                 style: TextStyle(
          //                     fontSize: 14,
          //                     color: Colors.white,
          //                     fontWeight: FontWeight.bold)),
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: GestureDetector(
          //           onTap: () {
          //             data_type = PhotoManager.getVideoAsset();
          //             _fetchAssets();
          //           },
          //           child: Container(
          //             alignment: Alignment.center,
          //             child: Text("Video",
          //                 style: TextStyle(
          //                     fontSize: 14,
          //                     color: Colors.white,
          //                     fontWeight: FontWeight.bold)),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ],
    );
  }
}

class Course {
  AssetEntity name;
  bool selected;

  Course(this.name, this.selected);
}
//
// class AssetThumbnail extends StatelessWidget {
//   AssetThumbnail({
//     Key? key,
//     required this.asset,
//   }) : super(key: key);
//
//   post_screen_controller poster = Get.find<post_screen_controller>();
//   final AssetEntity asset;
//   List? final_images;
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Uint8List?>(
//       future:
//           (asset.type == AssetType.image ? asset.originBytes : asset.thumbData),
//       builder: (widget, snapshot) {
//         final bytes = snapshot.data;
//         // If we have no data, display a spinner
//         if (bytes == null) {
//           return const SizedBox(
//             height: 20,
//             width: 20,
//             child: Padding(
//               padding: EdgeInsets.all(25.0),
//               child: CircularProgressIndicator(
//                 color: Colors.red,
//               ),
//             ),
//           );
//         } else {
//           return InkWell(
//             onTap: () async {
//               if (asset.type == AssetType.image) {
//                 print("asset.file");
//                 // print(bytes);
//                 print(snapshot.data);
//
//                 Uint8List? imageInUnit8List =
//                     snapshot.data; // store unit8List image here ;
//                 final tempDir = await getTemporaryDirectory();
//                 File file = await File('${tempDir.path}/image.png').create();


//                 file.writeAsBytesSync(imageInUnit8List!);
//                 print(file.path);
//                 // poster.selected_item.value = 'Image';
//                 // poster.file_selected_image.value = String.fromCharCodes(bytes);
//                 // print(
//                 //     "Uint8List.fromList(_post_screen_controller ${Uint8List.fromList(poster.file_selected_image.codeUnits)}");
//                 poster.image = bytes;
//               } else {
//                 print("video.file");
//                 print(bytes);
//                 print(asset.file);
//                 poster.selected_item.value = 'Video';
//
//                 poster.file_selected_video.value = String.fromCharCodes(bytes);
//                 print("PostScreenState().video()");
//                 print(poster.file_selected_video.value.toString());
//                 // PostScreenState().video();
//               }
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //     builder: (_) {
//               //       if (asset.type == AssetType.image) {
//               //         poster.file_selected.value = asset.file.toString();
//               //         // return ImageScreen(imageFile: asset.file);
//               //       } else {
//               //         return VideoScreen(videoFile: asset.file);
//               //       }
//               //     },
//               //   ),
//               // );
//             },
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: Container(
//                       color: Colors.white,
//                       child: Image.memory(bytes, fit: BoxFit.cover)),
//                 ),
//                 if (asset.type == AssetType.video)
//                   Center(
//                     child: Container(
//                       color: Colors.blue,
//                       child: Icon(
//                         Icons.play_arrow,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           );
//         }
//       },
//     );
//   }
// }
//
// class ImageScreen extends StatelessWidget {
//   const ImageScreen({
//     Key? key,
//     required this.imageFile,
//   }) : super(key: key);
//
//   final Future<File?> imageFile;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black,
//       alignment: Alignment.center,
//       child: FutureBuilder<File?>(
//         future: imageFile,
//         builder: (_, snapshot) {
//           final file = snapshot.data;
//           if (file == null) return Container();
//           return Image.file(file);
//         },
//       ),
//     );
//   }
// }
//
// class VideoScreen extends StatefulWidget {
//   const VideoScreen({
//     Key? key,
//     required this.videoFile,
//   }) : super(key: key);
//
//   final Future<File?> videoFile;
//
//   @override
//   _VideoScreenState createState() => _VideoScreenState();
// }
//
// class _VideoScreenState extends State<VideoScreen> {
//   VideoPlayerController? _controller;
//   bool initialized = false;
//
//   @override
//   void initState() {
//     _initVideo();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controller!.dispose();
//     super.dispose();
//   }
//
//   _initVideo() async {
//     final video = await widget.videoFile;
//     _controller = VideoPlayerController.file(video!)
//       // Play the video again when it ends
//       ..setLooping(true)
//       // initialize the controller and notify UI when done
//       ..initialize().then((_) => setState(() => initialized = true));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: initialized
//           // If the video is initialized, display it
//           ? Scaffold(
//               body: Center(
//                 child: AspectRatio(
//                   aspectRatio: _controller!.value.aspectRatio,
//                   // Use the VideoPlayer widget to display the video.
//                   child: VideoPlayer(_controller!),
//                 ),
//               ),
//               floatingActionButton: FloatingActionButton(
//                 onPressed: () {
//                   // Wrap the play or pause in a call to `setState`. This ensures the
//                   // correct icon is shown.
//                   setState(() {
//                     // If the video is playing, pause it.
//                     if (_controller!.value.isPlaying) {
//                       _controller!.pause();
//                     } else {
//                       // If the video is paused, play it.
//                       _controller!.play();
//                     }
//                   });
//                 },
//                 // Display the correct icon depending on the state of the player.
//                 child: Icon(
//                   _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                 ),
//               ),
//             )
//           // If the video is not yet initialized, display a spinner
//           : const SizedBox(
//               height: 20,
//               width: 20,
//               child: CircularProgressIndicator(),
//             ),
//     );
//   }
// }
//
// class image_grid {
//   final AssetPathEntity assets;
//   bool selected = false;
//
//   image_grid(this.assets, this.selected);
// }

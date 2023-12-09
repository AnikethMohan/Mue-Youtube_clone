import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mue/const/styles.dart';

import 'package:mue/view/search_result.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SearchController? controller;
  final yt = YoutubeExplode();
  var suggestion = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Container(
      //     margin: EdgeInsets.symmetric(horizontal: 5),
      //     width: double.infinity,
      //     height: 50,
      //     decoration: BoxDecoration(
      //         border: Border.all(color: Color(0xffEE8838)),
      //         borderRadius: BorderRadius.circular(15),
      //         color: Color(0xff29221F)),
      //     child: Row(
      //       children: [
      //         SearchAnchor(
      //           builder: (BuildContext context, SearchController controller) {
      //             return IconButton(
      //               icon: const Icon(
      //                 Icons.search_rounded,
      //                 color: Color(0xffEE8838),
      //               ),
      //               onPressed: () {
      //                 controller.openView();
      //               },
      //             );
      //           },
      //           suggestionsBuilder:
      //               (BuildContext context, SearchController controller) async {
      //             suggestion = await yt.search
      //                 .getQuerySuggestions(controller.text) as List;

      //             return List<ListTile>.generate(suggestion.length,
      //                 (int index) {
      //               return ListTile(
      //                 title: Text('${suggestion[index]}'),
      //                 onTap: () async {
      //                   final result =
      //                       await yt.search.search(suggestion[index]);

      //                   Navigator.of(context).push(MaterialPageRoute(
      //                     builder: (context) {
      //                       return SearchResults(
      //                         searchResult: result,
      //                         yt: yt,
      //                       );
      //                     },
      //                   ));
      //                 },
      //               );
      //             });
      //           },
      //           isFullScreen: true,
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: kpink),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white),
              child: Row(
                children: [
                  SearchAnchor(
                    builder:
                        (BuildContext context, SearchController controller) {
                      return GestureDetector(
                        onTap: () {
                          controller.openView();
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.only(left: 10.w),
                          width: MediaQuery.of(context).size.width - 12,
                          height: 50.h,
                          child: Row(
                            children: [
                              Icon(
                                Icons.search_rounded,
                                color: kpink,
                                size: 25.sp,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    suggestionsBuilder: (BuildContext context,
                        SearchController controller) async {
                      suggestion =
                          await yt.search.getQuerySuggestions(controller.text);

                      return List<ListTile>.generate(suggestion.length,
                          (int index) {
                        return ListTile(
                          title: Text('${suggestion[index]}'),
                          onTap: () async {
                            final result =
                                await yt.search.search(suggestion[index]);
                            print(result);

                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return SearchResults(
                                  searchResult: result,
                                  yt: yt,
                                  searchquery: controller.text,
                                );
                              },
                            ));
                          },
                        );
                      });
                    },
                    isFullScreen: true,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w, bottom: 2.h),
            child: TextMue(
                text: 'Mue: Search, Play, Enjoy! 🎶',
                fontSize: 12.sp,
                weight: FontWeight.bold,
                color: Color(0xff333333)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 10.w),
            child: TextMue(
                text:
                    'No frills, just thrills! Dive into a world of music and videos with our lightning-fast search bar. No recommendations, just your style, your way. Let the playtime begin! 🚀🎉',
                fontSize: 10.sp,
                weight: FontWeight.w400,
                color: Color(0xff333333),
                align: TextAlign.center),
          )
        ],
      ),
    );
  }
}

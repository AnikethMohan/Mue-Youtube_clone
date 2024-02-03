import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mue/const/styles.dart';
import 'package:mue/view/search_result.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchBarHome extends StatefulWidget {
  const SearchBarHome({super.key});

  @override
  State<SearchBarHome> createState() => _SearchBarHomeState();
}

class _SearchBarHomeState extends State<SearchBarHome> {
  @override
  Widget build(BuildContext context) {
    final yt = YoutubeExplode();
    var suggestion = [];
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
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
      suggestionsBuilder:
          (BuildContext context, SearchController controller) async {
        suggestion =
            await yt.search.getQuerySuggestions(controller.text) as List;

        return List<ListTile>.generate(suggestion.length, (int index) {
          return ListTile(
            title: Text('${suggestion[index]}'),
            onTap: () async {
              final result = await yt.search.search(suggestion[index]);

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return SearchResults(
                    searchResult: result,
                    yt: yt,
                    searchquery: suggestion[index].toString(),
                  );
                },
              ));
            },
          );
        });
      },
      isFullScreen: true,
    );
  }
}

class SearchBarResult extends StatefulWidget {
  const SearchBarResult({super.key, required this.searchquery});
  final searchquery;

  @override
  State<SearchBarResult> createState() => _SearchBarResultState();
}

class _SearchBarResultState extends State<SearchBarResult> {
  SearchController? controller;
  final yt = YoutubeExplode();
  var suggestion = [];
  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return InkWell(
          onTap: () {
            controller.openView();
          },
          child: Container(
            width: 270.w,
            height: 40.h,
            padding: EdgeInsets.only(left: 10.w),
            decoration: BoxDecoration(
                color: Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(12.r)),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: Color(0xffC3C2C5),
                ),
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                  width: 200.w,
                  child: TextMue(
                      text: widget.searchquery.toString(),
                      fontSize: 16.sp,
                      weight: FontWeight.w400,
                      color: kblack,
                      overflow: TextOverflow.ellipsis),
                )
              ],
            ),
          ),
        );
      },
      suggestionsBuilder:
          (BuildContext context, SearchController controller) async {
        final focusnode = FocusNode();
        suggestion = await yt.search.getQuerySuggestions(controller.text);

        controller.addListener(() {
          KeyboardListener(
              focusNode: focusnode,
              onKeyEvent: (event) async {
                if (event.logicalKey == LogicalKeyboardKey.enter) {
                  print('enter pressed');
                  // Do som
                  final result = await yt.search.search(controller.text);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return SearchResults(
                        searchResult: result,
                        yt: yt,
                        searchquery: controller.text.toString(),
                      );
                    },
                  ));
                }
              },
              child: TextField(controller: TextEditingController()));
        });

        return List<ListTile>.generate(suggestion.length, (int index) {
          return ListTile(
            title: Text('${suggestion[index]}'),
            onTap: () async {
              final result = await yt.search.search(suggestion[index]);

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return SearchResults(
                    searchResult: result,
                    yt: yt,
                    searchquery: suggestion[index].toString(),
                  );
                },
              ));
            },
          );
        });
      },
      isFullScreen: true,
    );
  }
}

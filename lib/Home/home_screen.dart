import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xff181A1F),
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xffEE8838)),
              borderRadius: BorderRadius.circular(15),
              color: Color(0xff29221F)),
          child: Row(
            children: [
              SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return IconButton(
                    icon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xffEE8838),
                    ),
                    onPressed: () {
                      controller.openView();
                    },
                  );
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) async {
                  suggestion = await yt.search
                      .getQuerySuggestions(controller.text) as List;

                  return List<ListTile>.generate(suggestion.length,
                      (int index) {
                    return ListTile(
                      title: Text('${suggestion[index]}'),
                      onTap: () async {
                        final result =
                            await yt.search.search(suggestion[index]);

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return SearchResults(
                              searchResult: result,
                              yt: yt,
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
    );
  }
}

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class ImageProviders extends GetxController {
  RxString channelUrl = ''.obs;
  YoutubeExplode yt = YoutubeExplode();
  Channel? data;
  List<String> urlList = [];
  Future channelurl(
      dynamic index, VideoSearchList? searchResult, int itemcount) async {
    try {
      //  final channelId = searchResult![index].channelId;

      // data = channaldata;
      print('length of channgel is$index');
      for (int i = 0; i < index; i++) {
        final Channel channaldata =
            await yt.channels.get(searchResult![i].channelId);
        print('${channaldata.logoUrl}');

        urlList.add(channaldata.logoUrl.toString());
      }
      //  channelUrl.value = channaldata.logoUrl;
    } catch (e) {
      print('something wrong with image providers');
    }
  }

  formatNumber(dynamic myNumber) {
    // Convert number into a string if it was not a string previously
    String stringNumber = myNumber.toString();

    // Convert number into double to be formatted.
    // Default to zero if unable to do so
    double doubleNumber = double.tryParse(stringNumber) ?? 0;

    // Set number format to use
    NumberFormat numberFormat = NumberFormat.compact();

    return numberFormat.format(doubleNumber);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    channelUrl.value = '';

    super.onInit();
  }
}

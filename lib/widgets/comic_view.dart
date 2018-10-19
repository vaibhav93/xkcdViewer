import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibrate/vibrate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xkcd/data/comic.dart';
import 'package:xkcd/utils/preferences.dart';

class ComicView extends StatelessWidget {
  final SharedPreferences _prefs = Preferences.prefs;

  // props to https://github.com/T-Rex96/Easy_xkcd/blob/23ade11a2bcb520e5d3868f8368050413db08ed3/app/src/main/java/de/tap/easy_xkcd/utils/Comic.java
  final no2xVersion = [1193, 1446, 1667, 1735, 1739, 1744, 1778];
  final Comic comic;

  ComicView(this.comic);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, right: 20.0, bottom: 26.0, left: 20.0),
      child: GestureDetector(
        onLongPress: () {
          _vibrate();
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return AlertDialog(
                contentPadding: EdgeInsets.all(0.0),
                content: Container(
                  color: Theme.of(context).primaryColor,
                  padding: EdgeInsets.all(20.0),
                  child: Text(comic.alt, style: TextStyle(color: Colors.white)),
                ),
              );
            },
          );
        },
        child: Hero(
          tag: 'hero-${comic.num}',
          child: PhotoViewInline(
            maxScale: PhotoViewComputedScale.covered * 1.5,
            minScale: PhotoViewComputedScale.contained * 0.5,
            backgroundColor: Colors.white,
            gaplessPlayback: true,
            imageProvider: CachedNetworkImageProvider(_getImageUrl()),
          ),
        ),
      ),
    );
  }

  String _getImageUrl() {
    final num = comic.num;
    final dataSaver = _prefs.getBool('data_saver') ?? false;
    if (dataSaver || no2xVersion.contains(num)) {
      return comic.img;
    }
    if (num >= 1084) {
      var img = comic.img;
      return img.substring(0, img.lastIndexOf('.')) + "_2x.png";
    }
    return comic.img;
  }

  void _vibrate() async {
    if (await Vibrate.canVibrate) {
      Vibrate.feedback(FeedbackType.light);
    }
  }
}

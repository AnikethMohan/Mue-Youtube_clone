import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mue/view/Home/home_screen.dart';

void main() async {
  runApp(const MyApp());
  // final credentials =
  //     SpotifyApiCredentials(Credentials.clientId, Credentials.clientSecret);
  // final spotify = SpotifyApi(credentials);
  // final grant = SpotifyApi.authorizationCodeGrant(credentials);
  // final redirectUri = 'http://localhost:8888/callback';

  // String? responseUri;
  // final scopes = [
  //   AuthorizationScope.user.readEmail,
  //   AuthorizationScope.library.read
  // ];
  // final authUri = grant.getAuthorizationUrl(
  //   Uri.parse(redirectUri),
  //   scopes: scopes, // scopes are optional
  // );

  // print('can launch');
  // await launchUrl(authUri);

  // final link = linkStream.listen((event) async {
  //   if (event!.startsWith(redirectUri)) {
  //     print('response is ${event.toString()}');
  //     responseUri = event;
  //   }
  // });
  // print('link is ${link.toString()}');

  // var credential = new oauth2.Credentials(Credentials.clientId,
  //     tokenEndpoint: Uri.parse('https://accounts.spotify.com/api/token'));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            appBarTheme:
                AppBarTheme(backgroundColor: Color(0xff181A1F), elevation: 0),
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: HomeScreen()),
    );
  }
}

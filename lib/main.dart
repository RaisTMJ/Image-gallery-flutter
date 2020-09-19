import 'package:flutter/material.dart';


class ImageModel {
  int mediaId;
  DateTime createdDate;
  String url;

  ImageModel(
      this.mediaId,
      this.createdDate,
      this.url,
      );
}



List<ImageModel> dataMock =  [
  ImageModel(1, DateTime.fromMicrosecondsSinceEpoch(1599454785000000), 'https://images.unsplash.com/photo-1547721064-da6cfb341d50'),
  ImageModel(8, DateTime.fromMicrosecondsSinceEpoch(1599454785000000), 'https://images.unsplash.com/photo-1547721064-da6cfb341d50'),
  ImageModel(2, DateTime.fromMicrosecondsSinceEpoch(1599454775000000), 'https://resizing.flixster.com/5T0VbO8NTGbTrkjRIjESCIxSmos=/206x305/v1.dDs1Mjg3OTU7ajsxODU2MzsxMjAwOzQwNDs2MDg'),
  ImageModel(3, DateTime.fromMicrosecondsSinceEpoch(1599214775000000), 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQIPkwkzRQijiWUpU5seu5YrEof3kHgYukyvA&usqp=CAU'),
  ImageModel(4, DateTime.fromMicrosecondsSinceEpoch(1599211275000000), 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTmOfRX5hksEj1AQdiOy3BNUX--bZ6lEdMsQA&usqp=CAU'),
  ImageModel(5, DateTime.fromMicrosecondsSinceEpoch(1592211275000000), "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTmOfRX5hksEj1AQdiOy3BNUX--bZ6lEdMsQA&usqp=CAU"),
  ImageModel(7, DateTime.fromMicrosecondsSinceEpoch(1599224475000000), "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQHlyzB51q4qNtHioCt3m24Itf8hjKsl04OuA&usqp=CAU"),
];
List<ImageModel> _imageDataMockMultipleTime = [
  ...dataMock,
  ...dataMock,
  ...dataMock,
  ...dataMock,
  ...dataMock,
  ...dataMock,
  ...dataMock,
];




void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MediaDocumentScreen(),
    );
  }
}

class MediaDocumentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MediaDocumentScreenContent(),
    );
  }
}

class MediaDocumentScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Images Gallery'),
      ),
      body:MediasScreen(),
    );
  }
}

class MediasScreen extends StatelessWidget {
  List<String> monthsMap =  ['','January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  @override
  Widget build(BuildContext context) {
    final _mediaModel = _imageDataMockMultipleTime;
    _mediaModel.sort((a,b) => b.createdDate.compareTo(a.createdDate));
    List<List<ImageModel>> _sortedMedias = groupMediaByMonth(_mediaModel);
    return SingleChildScrollView(
        child: Column(
      children: [
        for (List<ImageModel> mediaMonth in _sortedMedias)
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 5, left: 10),
                child: Text( monthsMap[mediaMonth[0].createdDate.month]
                  ,
                  style: Theme.of(context).textTheme.headline5,
                ),
                width: double.infinity,
              ),
              _containerImagesListGridView(mediaMonth, context),
            ],
          )
      ],
    ));

    // throw UnimplementedError();
  }

  Container _containerImagesListGridView(
      List<ImageModel> mediaMonth, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 10),
      child: GridView.count(
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        shrinkWrap: true,
        primary: true,
        crossAxisCount: 4,
        children: _list(mediaMonth, context),
      ),
    );
  }

  List<Widget> _list(List<ImageModel> mediaMonth, BuildContext context) {
    return List.generate(mediaMonth.length, (index) {
      return Container(
          color: Theme.of(context).primaryColorLight.withOpacity(.2),
          child: Image.network(
            mediaMonth[index].url,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              );
            },
            fit: BoxFit.cover,
          ));
    });
  }
}


List<List<ImageModel>> groupMediaByMonth(List<ImageModel> medias) {
  List<List<ImageModel>> item = [];
  int _month;
  int _seq = 0;
  for (ImageModel element in medias) {
    if (_month == null) {
      _month = element.createdDate.month;
      item.add([element]);
      continue;
    }
    if (_month == element.createdDate.month) {
      item[_seq].add(element);
    } else {
      _month = element.createdDate.month;
      item.add([element]);
      _seq++;
    }
  }
  return item;
}


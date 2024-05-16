import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gamereview_app/detail_page.dart';
import 'package:gamereview_app/post_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: getImageData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Map<String, dynamic>> dataList = snapshot.data!;

              return Container(
                color: Colors.cyan[400],
                child: GridView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    String imageUrl = dataList[index]['imageURL'];
                    return GestureDetector(
                      child: Card(
                          elevation: 10,
                          color: Colors.black, // カードの色を明るくする
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(imageUrl),
                          )),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            cardData: dataList[index],
                          ),
                        ),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                ),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan[50],
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PostPage(),
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> getImageData() async {
  List<Map<String, dynamic>> cardDataList = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Firebaseからデータを取得する処理
  QuerySnapshot querySnapshot = await firestore.collection('dataList').get();
  for (var doc in querySnapshot.docs) {
    String name = doc['name'];
    String imageUrl = doc['imageURL'];
    String release = doc['release'];
    String platform = doc['platform'];
    String maker = doc['maker'];
    String genre = doc['genre'];
    cardDataList.add({
      'name': name,
      'imageURL': imageUrl,
      'platform': platform,
      'release': release,
      'maker': maker,
      'genre': genre,
    });
  }

  return cardDataList;
}

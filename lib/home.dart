import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamereview_app/detail_page.dart';
import 'package:gamereview_app/post_page.dart';

// Firestoreからデータを取得するFutureProvider
final imageDataProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await getImageData();
});

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  void _refreshData(WidgetRef ref) {
    ref.refresh(imageDataProvider); // データを再取得
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageData = ref.watch(imageDataProvider);

    return Scaffold(
      body: imageData.when(
        data: (dataList) {
          return Container(
            color: Colors.cyan[400],
            child: GridView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                String imageUrl = dataList[index]['imageURL'];
                return GestureDetector(
                  child: Card(
                    elevation: 10,
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(imageUrl),
                    ),
                  ),
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
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
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
          ).then((_) {
            // PostPageから戻ったときにデータを再取得
            _refreshData(ref);
          });
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
    String genre = doc['genre'];
    cardDataList.add({
      'name': name,
      'imageURL': imageUrl,
      'platform': platform,
      'release': release,
      'genre': genre,
    });
  }

  return cardDataList;
}

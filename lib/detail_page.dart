import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> cardData; // 型をMap<String, dynamic>に明確化
  const DetailPage({super.key, required this.cardData}); // コンストラクタでcardDataを必須に

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            cardData['name'], // コンストラクタで渡されたcardDataを使用
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.cyan[400],
        ),
        body: Container(
          color: Colors.cyan[400],
          child: Column(
            children: [
              Card(
                elevation: 10,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    cardData['imageURL'],
                    errorBuilder: (context, error, stackTrace) {
                      // Image.networkで画像読み込みが失敗した場合に備え、errorBuilderを追加
                      return const Icon(Icons.broken_image,
                          color: Colors.white, size: 300);
                    },
                  ),
                ),
              ),
              TabBar(
                indicatorColor: Colors.cyan[400],
                tabs: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    child: Tab(
                      child: Text(
                        '詳細',
                        style: TextStyle(fontSize: 20, color: Colors.cyan[400]),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Tab(
                      child: Text(
                        'コメント',
                        style: TextStyle(fontSize: 20, color: Colors.cyan[400]),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: TabBarView(
                    children: [
                      // 詳細情報
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('プラットフォーム:', cardData['platform']),
                            _buildDetailRow('発売日:', cardData['release']),
                            _buildDetailRow('メーカー:', cardData['maker']),
                            _buildDetailRow('ジャンル:', cardData['genre']),
                          ],
                        ),
                      ),
                      // コメントセクション
                      Center(
                        child: Text(
                          '今後実装予定',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.cyan[400],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 詳細情報の行を構築するウィジェット
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 20, color: Colors.cyan[400]),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 20, color: Colors.cyan[400]),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

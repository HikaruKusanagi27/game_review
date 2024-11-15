import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> cardData;
  const DetailPage({
    super.key,
    required this.cardData,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              cardData['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.cyan[400],
          ),
          body: Container(
            color: Colors.cyan[400],
            child: Column(children: [
              Card(
                  elevation: 10,
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(cardData['imageURL']),
                  )),
              TabBar(
                indicatorColor: Colors.cyan[400],
                tabs: [
                  Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                        ),
                      ),
                      width: double.infinity,
                      child: Tab(
                          icon: Text('詳細',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.cyan[400],
                              )))),
                  Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                        ),
                      ),
                      width: double.infinity,
                      child: Tab(
                          icon: Text(
                        'コメント',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.cyan[400],
                        ),
                      ))),
                ],
              ),
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: TabBarView(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "プラットフォーム:",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.cyan[400],
                                ),
                              ),
                              Text(
                                cardData['platform'],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.cyan[400],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "発売日:",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.cyan[400],
                                ),
                              ),
                              Text(
                                cardData['release'],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.cyan[400],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "メーカー:",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.cyan[400],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  cardData['maker'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.cyan[400],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ジャンル",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.cyan[400],
                                ),
                              ),
                              Text(
                                cardData['genre'],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.cyan[400],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
            ]),
          ),
        ));
  }
}

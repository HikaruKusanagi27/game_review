import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

const List<String> platformList = <String>['Switch', 'PS5', 'Steam'];

const List<String> makerList = <String>['ソニー', 'ニンテンドー', 'セガ'];

const List<String> genreList = <String>['アクション', 'RPG', 'シュミレーション'];

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  String _displayedText = '';

  @override
  void initState() {
    super.initState();
    _dateController.addListener(() {
      setState(() {
        _displayedText = _dateController.text;
      });
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _clearDate() {
    setState(() {
      _dateController.clear(); // TextFieldの内容をクリア
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
      ),
      body: Container(
        color: Colors.cyan[400],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: Card(
                      color: Colors.black,
                      child: Text('test'),
                    ),
                  ),
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'タイトル',
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '発売日',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: _clearDate, // クリアボタン
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('発売日:'),
                    SizedBox(width: 10),
                    if (_selectedDate != null)
                      Text(
                        "${_selectedDate!.year}/${_selectedDate!.month}/${_selectedDate!.day}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
                TableCalendar(
                  firstDay: DateTime.utc(2010, 1, 1),
                  lastDay: DateTime.utc(2030, 1, 1),
                  focusedDay: DateTime.now(),
                  selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                      _dateController.text =
                          "${selectedDay.year}-${selectedDay.month}-${selectedDay.day}";
                    });
                  },
                  onFormatChanged: (format) {
                    // do something
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('プラットフォーム:'),
                    PlatformListDropdownButton(),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('メーカー:'),
                    MakerListDropdownButton(),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ジャンル:'),
                    GenreListDropdownButton(),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan[50],
                    ),
                    child: Text(
                      '投稿',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlatformListDropdownButton extends StatefulWidget {
  const PlatformListDropdownButton({super.key});

  @override
  State<PlatformListDropdownButton> createState() =>
      _PlatformListDropdownButtonState();
}

class _PlatformListDropdownButtonState
    extends State<PlatformListDropdownButton> {
  String dropdownValue = platformList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Colors.black),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: platformList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: SizedBox(
            width: 100,
            child: Row(
              children: [
                const Spacer(),
                Text(value),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class MakerListDropdownButton extends StatefulWidget {
  const MakerListDropdownButton({super.key});

  @override
  State<MakerListDropdownButton> createState() =>
      _MakerListDropdownButtonState();
}

class _MakerListDropdownButtonState extends State<MakerListDropdownButton> {
  String dropdownValue = makerList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Colors.black),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: makerList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: SizedBox(
            width: 100,
            child: Row(
              children: [
                const Spacer(),
                Text(value),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class GenreListDropdownButton extends StatefulWidget {
  const GenreListDropdownButton({super.key});

  @override
  State<GenreListDropdownButton> createState() =>
      _GenreListDropdownButtonState();
}

class _GenreListDropdownButtonState extends State<GenreListDropdownButton> {
  String dropdownValue = genreList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Colors.black),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: genreList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: SizedBox(
            width: 115,
            child: Row(
              children: [
                const Spacer(),
                Text(value),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

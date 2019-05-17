import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import './puzzle.dart';
class LevelItem extends StatelessWidget {
final ImgData data;
LevelItem({this.data});
@override
Widget build(context) {
return ClipRRect(
borderRadius: BorderRadius.circular(5),
child: GestureDetector(
child: Hero(
tag: data.url,
child: Image.asset(data.url),
),
onTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => PuzzleScreen(data: data),
),
);
},
),
);
}
}
class HomeScreen extends StatefulWidget {
@override
_HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
final List<ImgData> _levels = [];
@override
void initState() {
super.initState();
load();
}
void load() async {
try {
var dataJaon = await rootBundle.loadString('assets/data.json');
var data = jsonDecode(dataJaon);
for (var level in data['levels']) {
_levels.add(ImgData(
url: level['url'],
size: Size(level['width'] * 1.0, level['height'] * 1.0),
label: level['label'],
));
}
setState(() {});
} catch (e) {
}
}
@override
Widget build(context) {
return Scaffold(
appBar: AppBar(
title: Text('Image Puzzle'),
),
body: StaggeredGridView.count(
padding: EdgeInsets.all(5),
crossAxisSpacing: 5,
mainAxisSpacing: 5,
crossAxisCount: 3,
staggeredTiles: _levels.map((_) => StaggeredTile.fit(1)).toList(),
children: _levels
.map((data) => LevelItem(
data: data,
))
.toList(),
),
);
}
}
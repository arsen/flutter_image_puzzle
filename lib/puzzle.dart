import 'package:flutter/material.dart';

class ImgData {
String url;
Size size;
String label;
ImgData({
this.url,
this.size,
this.label,
});
}
class PuzzleTile extends StatelessWidget {
final Offset pos;
final Size size;
final Size parentSize;
final String img;
PuzzleTile({
@required this.pos,
@required this.size,
@required this.parentSize,
@required this.img,
});
@override
Widget build(context) {
return Container(
width: size.width,
height: size.height,
child: Stack(
children: [
Positioned(
top: pos.dy,
left: pos.dx,
child: Container(
width: parentSize.width,
height: parentSize.height,
child: Image.asset(img),
),
),
],
),
);
}
}
class PuzzleScreen extends StatefulWidget {
final ImgData data;
PuzzleScreen({this.data});
@override
_PuzzleScreenState createState() => _PuzzleScreenState();
}
class _PuzzleScreenState extends State<PuzzleScreen> {
int get cols {
return widget.data.size.width > widget.data.size.height ? 3 : 2;
}
int get rows {
return widget.data.size.height > widget.data.size.width ? 3 : 2;
}
double get spacing => 1;
List<int> _tiles = [];
bool _transitionDone = false;

@override
void initState() {
super.initState();
_tiles = List.generate(
cols * rows,
(index) => index,
);
generatePuzzle();
}
void generatePuzzle() async {
await Future.delayed(Duration(milliseconds: 800));
if (!mounted) return;
setState(() {
_transitionDone = true;
_tiles.shuffle();
});
}
Size get tileSize {
var w = containerSize.width / cols - spacing;
var h = containerSize.height / rows - spacing;
return Size(w, h);
}
Size get containerSize {
var w = MediaQuery.of(context).size.width;
var h = w / (widget.data.size.width / widget.data.size.height);
return Size(w, h);
}
Offset getTilePos(int i, Size s) {
int row = (i / cols).floor();
int col = i - row * cols;

double y = row * (s.height + spacing) + spacing;
double x = col * (s.width + spacing) + spacing;
return Offset(-1 * x, -1 * y);
}

bool _isDone() {
for (int i = 1; i < _tiles.length; i++) {
if (_tiles[i] < _tiles[i - 1]) {
return false;
}
}
return true;
}
Widget _buildTile(int index, Size tileSize, Size parentSize) {
var t = PuzzleTile(
size: tileSize,
pos: getTilePos(index, tileSize),
img: widget.data.url,
parentSize: parentSize,
);
return DragTarget<int>(
onAccept: (int newIndex) {
var o = _tiles.indexOf(index);
var n = _tiles.indexOf(newIndex);
setState(() {
_tiles[o] = newIndex;
_tiles[n] = index;
});
if (_isDone()) {
showDialog(
context: context,
builder: (context) {
return AlertDialog(
title: Text("You did it!"),
actions: [
FlatButton(
child: Text("Close"),
onPressed: () {
Navigator.of(context).pop();
},
),
],
);
},
);
}
},
builder: (context, accepted, rejected) {
return Draggable<int>(
data: index,
childWhenDragging: SizedBox(
width: tileSize.width,
height: tileSize.height,
),
child: t,
feedback: t,
);
},
);
}
Widget _buildContent() {
var parentSize = containerSize;
return _transitionDone
? Wrap(
spacing: spacing,
runSpacing: spacing,
children: _tiles
.map((index) => _buildTile(index, tileSize, parentSize))
.toList(),
)
: Image.asset(
widget.data.url,
width: parentSize.width,
height: parentSize.height,
);
}
@override
Widget build(context) {
return Scaffold(
appBar: AppBar(title: Text(widget.data.label)),
body: Hero(
tag: widget.data.url,
child: Center(
child: AnimatedSwitcher(
duration: Duration(milliseconds: 200),
child: _buildContent(),
),
),
),
);
}
}

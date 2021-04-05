
// Color hexToColor(String code) {
//   return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
// }

String reduceLength(String n) {
  int l = 30;
  String note = (n.length > l) ? n.substring(0, l) + '...' : n;
  return note;
}

int getTime() {
  int time = DateTime.now().microsecondsSinceEpoch;
  return time;
}

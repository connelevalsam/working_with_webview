import 'package:flutter/material.dart';

class Authors extends StatefulWidget {
  final List res;

  const Authors({Key key, this.res}) : super(key: key);

  @override
  _AuthorsState createState() => _AuthorsState();
}

class _AuthorsState extends State<Authors> {
  var result;
  List j = [];
  @override
  void initState() {
    super.initState();
    result = widget.res;
    print("=x=x From authors - $result");
    int i = 1;
    int z = result.length;
    int split = 3;
    for (int i = 0; i < z; i += split) {
      var end = (i + split < z) ? i + split : z;
      j.add(result.sublist(i, end));
    }

    // print(result);
    print("Value of j");
    print(j);
    print("Single Value of K");
    print(j[0][1]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Authors')),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: j.length,
        itemBuilder: (BuildContext context, int index) {
          // String res = result[0];
          return Container(
            child: Row(
              children: [
                Expanded(
                  child: Image(
                    image: NetworkImage(j[index][2]),
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                          j[index][0],
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.green
                        ),
                      ),
                      Text(j[index][1]),
                    ],
                  ),
                ),
              ],
            ),
          );

            // Text('Item - ${j[index]}');

        }
      ),
    );
  }
}

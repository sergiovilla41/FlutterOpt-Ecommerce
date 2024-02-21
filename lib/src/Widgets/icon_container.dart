import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  final String url;
  const IconContainer({Key? key, required this.url})
      // ignore: unnecessary_null_comparison
      : assert(url != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220.0,
      height: 200.0,
      child: CircleAvatar(
        radius: 100.0,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage(this.url),
      ),
    );
  }
}

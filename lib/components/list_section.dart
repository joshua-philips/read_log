import 'package:flutter/material.dart';

class ListSection extends StatelessWidget {
  final String sectionTitle;
  final List<Widget> children;

  const ListSection(
      {Key? key, required this.sectionTitle, required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionTitle,
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

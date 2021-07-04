import 'package:books_log/models/openlibrary_book.dart';
import 'package:flutter/material.dart';

List<Widget> horizontalDetailList(List<dynamic> detailList) {
  List<Widget> widgetList = [];
  for (int count = 0; count < detailList.length; count++) {
    widgetList.add(
      Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 5),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade600,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          detailList[count].toString(),
        ),
      ),
    );
  }
  return widgetList;
}

List<Widget> horizontalDetailListSorted(List<dynamic> detailList) {
  detailList.sort();
  List<Widget> widgetList = [];
  for (int count = 0; count < detailList.length; count++) {
    widgetList.add(
      Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 5),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade600,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          detailList[count].toString(),
        ),
      ),
    );
  }
  return widgetList;
}

List<Widget> listOfLinks(List<Links> list, BuildContext context) {
  List<Widget> widgetList = [];
  for (int count = 0; count < list.length; count++) {
    widgetList.add(
      InkWell(
        child: Container(
          padding: EdgeInsets.only(left: 8, right: 8, top: 5),
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            list[count].title.toString(),
          ),
        ),
        onTap: () {
          // TODO: Open webpage from link
        },
      ),
    );
  }
  return widgetList;
}

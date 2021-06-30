import 'package:books_log/models/openlibrary_book.dart';
import 'package:books_log/models/openlibrary_search.dart';
import 'package:books_log/models/openlibrary_works.dart';
import 'package:flutter/material.dart';

class AddBookDetails extends StatelessWidget {
  final Docs openLibrarySearchDoc;
  final OpenLibraryBook bookResult;
  final OpenLibraryWorks worksResult;
  AddBookDetails({
    Key? key,
    required this.openLibrarySearchDoc,
    required this.bookResult,
    required this.worksResult,
  }) : super(key: key);

  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 2,
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 12),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        openLibrarySearchDoc.title,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'WRITTEN BY',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      Text(
                        openLibrarySearchDoc.authorName.isNotEmpty
                            ? openLibrarySearchDoc.authorName.first
                            : 'Unknown',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        openLibrarySearchDoc.firstPublishYear.toString(),
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      Text(
                        openLibrarySearchDoc.publisher.first.toUpperCase(),
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  height: 150,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: Colors.white70,
                    ),
                    color: Colors.black54,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => buildImageDialog(
                          context,
                          bookResult.cover.large,
                          openLibrarySearchDoc.title,
                        ),
                      );
                    },
                    child: Image.network(
                      bookResult.cover.large,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          openLibrarySearchDoc.title,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : Center(
                                  child: Text(
                                    openLibrarySearchDoc.title,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DESCRIPTION',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                SizedBox(height: 10),
                worksResult.description != ''
                    ? Text(
                        worksResult.description.toString(),
                      )
                    : TextFormField(
                        maxLines: 4,
                        controller: descriptionController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                        ),
                      ),
              ],
            ),
            Divider(),
            openLibrarySearchDoc.subject.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SUBJECTS',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 30,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          children: horizontalDetailList(
                              openLibrarySearchDoc.subject),
                        ),
                      ),
                    ],
                  )
                : Container(),
            Divider(),
            openLibrarySearchDoc.place.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PLACES',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 30,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          children:
                              horizontalDetailList(openLibrarySearchDoc.place),
                        ),
                      ),
                    ],
                  )
                : Container(),
            Divider(),
            openLibrarySearchDoc.time.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TIME',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 30,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          children:
                              horizontalDetailList(openLibrarySearchDoc.time),
                        ),
                      ),
                    ],
                  )
                : Container(),
            Divider(),
            openLibrarySearchDoc.person.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CHARACTERS',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 30,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          children:
                              horizontalDetailList(openLibrarySearchDoc.person),
                        ),
                      ),
                    ],
                  )
                : Container(),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PUBLISHERS',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 30,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    children:
                        horizontalDetailList(openLibrarySearchDoc.publisher),
                  ),
                ),
              ],
            ),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YEARS PUBLISHED',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 30,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    children: horizontalDetailListSorted(
                        openLibrarySearchDoc.publishYear),
                  ),
                ),
              ],
            ),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EXTERNAL LINKS',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 30,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    children: listOfLinks(bookResult.links),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            MaterialButton(
              color: Colors.green,
              child: Text('Add to your books'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Dialog buildImageDialog(BuildContext context, String image, String title) {
    return Dialog(
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Image.network(
          image,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
          ),
          loadingBuilder: (context, child, loadingProgress) =>
              loadingProgress == null
                  ? child
                  : Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
        ),
      ),
    );
  }

  List<Widget> listOfLinks(List<Links> list) {
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
}

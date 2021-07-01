import 'package:flutter/material.dart';

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

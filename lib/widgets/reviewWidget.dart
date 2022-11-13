import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/piece.dart';
import 'ratingWidget.dart';
import 'reviewPostWidget.dart';


class ReviewWidget extends StatefulWidget {
  const ReviewWidget({
    Key? key,
    required Piece this.piece,
  }) : super(key: key);

  final Piece piece;

  @override
  State<StatefulWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          ReviewPostWidget(
            postReview: (String comment, int rating) {
              this.postReview(this.widget.piece.name, comment, rating);
            },
          ),
          SizedBox(height: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: this.widget.piece.reviews.map((review) => 
              Container(
                margin: EdgeInsets.only(bottom: 5.0),
                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 8.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(200, 200, 200, 255),
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RatingWidget(rating: review.rating),
                    SizedBox(height: 5.0),
                    Text(
                      review.comment,
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ]
                )
              )
            ).toList()
          )
        ]
      )
    );
  }

  Future<http.Response> postReview(String name, String comment, int rating) async {
    var map = new Map<String, dynamic>();
    map['pieceName'] = name;
    map['comment'] = comment;
    map['rating'] = rating.toString();

    return http.post(
      Uri.parse('https://api-edge-johantorfs.cloud.okteto.net/review'),
      body: map,
    );
  }
}

import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseRow extends StatelessWidget {
  final Video video;
  CourseRow(this.video);
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[
              new Image.network(video.imageUrl),
              new Container(
                height: 12.0,
              ),
              new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new CircleAvatar(
                      backgroundImage: new NetworkImage(video.imageUrl)),
                  new Container(
                    width: 16.0,
                  ),
                  new Flexible(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          video.name,
                          style: new TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        new Container(
                          height: 4.0,
                        ),
                        new Text("Number of views: " +
                            video.numberOfViews.toString())
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        new Divider()
      ],
    );
  }
}

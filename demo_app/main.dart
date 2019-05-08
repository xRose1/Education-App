import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './models/course.dart';
import './views/course_row.dart';

void main() => runApp(new RealWorldStatefulBody());

class RealWorldApp extends StatelessWidget {
  var _shouldRefresh = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "A Real World App",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Real World App Bar"),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.refresh),
              color: Colors.white,
              onPressed: () {
                print("Refresh");
              },
            )
          ],
        ),
        // body: new Text("HELLLLLLLOOOOOO THERE")
        body: _shouldRefresh ? new RealWorldStatefulBody() : new RealWorldStatefulBody(),
      ),
    );
  }
}

class RealWorldStatefulBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RealWorldState();
  }
}

class RealWorldState extends State<StatefulWidget> {
  var _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  final videos = new List<Video>();

  _fetchData() async {
    videos.clear();
    final uriString = 'https://api.letsbuildthatapp.com/youtube/home_feed';

    final response = await http.get(uriString);
    if (response.statusCode == 200) {
      // print(response.body);
      final coursesJson = json.decode(response.body);
      // print(coursesJson);
      coursesJson["videos"].forEach((videoDict) {
        final course = new Video(videoDict["id"], videoDict["name"], videoDict["imageUrl"],
            videoDict["numberOfViews"]);
        videos.add(course);
      });
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "A Real World App",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Real World App Bar"),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.refresh),
              color: Colors.white,
              onPressed: () {
                setState((){
                  _isLoading = true;                  
                  _fetchData();
                });
              },
            )
          ],
        ),
        // body: new Text("HELLLLLLLOOOOOO THERE")
        body: new Center(
        child: _isLoading
            ? new CircularProgressIndicator()
            : new ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, i) {
                  final video = videos[i];
                  // return new Text("STUFF");
                  return new FlatButton(
                    padding: new EdgeInsets.all(0.0),
                    child: new CourseRow(video),
                    onPressed: () {
                      print("Pressed $i");
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  new CourseDetailsPage(video)));
                    },
                  );
                },
              ))
      ),
    );
  }
}

class CourseDetailsPage extends StatefulWidget {
  final Video video;
  CourseDetailsPage(this.video);
  @override
  State<StatefulWidget> createState() {
    return new CourseDetailsState(video);
  }
}

class Lesson {
  final String name;
  final String imageUrl;
  final String duration;
  final int number;
  Lesson(this.name, this.imageUrl, this.duration, this.number);
}

class CourseDetailsState extends State<CourseDetailsPage> {
  final Video video;
  CourseDetailsState(this.video);
  final lessons = new List<Lesson>();

  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLessons();
  }

  _fetchLessons() async {
    final urlString =
        'https://api.letsbuildthatapp.com/youtube/course_detail?id=' + video.id.toString();
    print("Fetching: " + urlString);
    final response = await http.get(urlString);
    final lessonsJson = json.decode(response.body);
    lessonsJson.forEach((lessonJson) {
      final lesson = new Lesson(lessonJson["name"], lessonJson["imageUrl"],
          lessonJson["duration"], lessonJson["number"]);
      lessons.add(lesson);
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(video.name),
      ),
      body: new Center(
          child: _isLoading
              ? new CircularProgressIndicator()
              : new ListView.builder(
                  itemCount: lessons.length,
                  itemBuilder: (context, i) {
                    final lesson = lessons[i];
                    return new Column(
                      children: <Widget>[
                        new Container(
                          padding: new EdgeInsets.all(12.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Image.network(
                                lesson.imageUrl,
                                width: 150.0,
                              ),
                              new Container(width: 12.0,),
                              new Flexible(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(lesson.name, 
                                  style: new TextStyle(fontSize: 16.0),),
                                  new Container(height: 4.0,),
                                  new Text(lesson.duration,
                                  style: new TextStyle(fontStyle: FontStyle.italic),),
                                  new Container(height: 4.0,),
                                  new Text("Episode #" + lesson.number.toString(),
                                  style: new TextStyle(fontWeight: FontWeight.bold),)
                                ],
                              ),
                              )
                              
                            ],
                          ),
                        ),
                        new Divider()
                      ],
                    );
                  },
                )),
    );
  }
}

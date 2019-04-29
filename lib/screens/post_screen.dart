import 'package:discover/widgets/collapsing_appbar.dart';
import 'package:discover/widgets/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class PostScreen extends StatefulWidget {
  PostScreen({Key key}) : super(key: key);

  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Chip _buildChip(String tag) {
    return Chip(
      label: Text(tag, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.grey[600],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CollapsingAppbar(
        title: "",
        image: Image.network(
          "http://images.unsplash.com/photo-1555985202-12975b0235dc",
          fit: BoxFit.cover,
        ),
        children: <Widget>[
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Posted 14 days ago",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Icon(Icons.favorite,
                              size: 40, color: Colors.red[600]),
                          const SizedBox(height: 6.0),
                          Text(
                            "2 likes".toUpperCase(),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Icon(Icons.mode_comment,
                              size: 40, color: Colors.grey[800]),
                          const SizedBox(height: 6.0),
                          Text("0 comments".toUpperCase(),
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Icon(Icons.location_on,
                              size: 40, color: Colors.grey[800]),
                          const SizedBox(height: 6.0),
                          Text("183km",
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      UserImage(userId: "dfgh-dfgh-dfgh-dfgh", size: 50),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          "Username",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Text("Description",
                      style: Theme.of(context).textTheme.caption),
                  const SizedBox(height: 8.0),
                  Text("Une super description du post !"),
                  const SizedBox(height: 20.0),
                  Text("Tags", style: Theme.of(context).textTheme.caption),
                  const SizedBox(height: 4.0),
                  Wrap(
                    spacing: 8.0,
                    children: <Widget>[
                      _buildChip("Monument"),
                      _buildChip("Paysage"),
                      _buildChip("Randonnée"),
                      _buildChip("Plage"),
                      _buildChip("Visite"),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "COMMENTAIRES",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_sheet_flutter/models/feedback_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FeedBackModel> allfeedbacks = <FeedBackModel>[];
  List<FeedBackModel> feedbacks = <FeedBackModel>[];
  bool isLoading = false;
  @override
  void initState() {
    getFeedback();
    super.initState();
  }

  void getFeedback() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(
        'https://script.googleusercontent.com/macros/echo?user_content_key=vVDCaEow382icHAASDSpyW4HXe0TUtZlRHQ0FiXLQyY7tmBnDEnC2z1UBsR69MTOPU0rzlgEv5Q2RgPRoGJWNPIof8yyXhS4m5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnD1J3sbh4G0wo6NTEU1NG7X-ovFwmkhobzXX_OwoF488Y3VDI2ATFbzRQahm70OdG-7MviFrXuBZ0pjdCPvAVKZPW4AB04xCXw&lib=MOA-UrDT9SzBAbZaLJFB5oHImAf41yL87');
    var response = await http.get(url);
    // print(response.body);
    var jsonFeedback = convert.jsonDecode(response.body);
    // print(jsonFeedback);

    // // serializin the json response according to our class
    // feedbacks = jsonFeedback.map((json) => FeedBackModel.fromJson(json));
    // print(feedbacks);

    jsonFeedback.forEach((element) {
      FeedBackModel feedBackModel = FeedBackModel();
      feedBackModel.name = element['name'];
      feedBackModel.profilePic = element['image_url'];
      feedBackModel.source = element['source'];
      feedBackModel.feedback = element['feedback'];
      allfeedbacks.add(feedBackModel);
    });
    allfeedbacks.removeLast();

    for (var i = 0; i < allfeedbacks.length; i++) {
      if (allfeedbacks[i].profilePic != '') {
        feedbacks.add(allfeedbacks[i]);
      }
    }
    print(feedbacks.length);
    setState(() {
      isLoading = false;
    });
    // print(feedbacks[0].name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students Feedback'),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: feedbacks.length,
              itemBuilder: (context, index) {
                return FeedbackTile(
                  imageUrl: feedbacks[index].profilePic,
                  feedback: feedbacks[index].feedback,
                  source: feedbacks[index].source,
                  name: feedbacks[index].name,
                );
              },
            ),
    );
  }
}

class FeedbackTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String feedback;
  final String source;

  FeedbackTile({
    Key key,
    this.imageUrl,
    this.name,
    this.source,
    this.feedback,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: Image.network(
                    '$imageUrl',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text('from $source'),
                ],
              )
            ],
          ),
          SizedBox(height: 16.0),
          Text(feedback)
        ],
      ),
    );
  }
}

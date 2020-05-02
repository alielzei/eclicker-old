import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intro_slider/intro_slider.dart';
class EmailServicePage extends StatefulWidget {
  @override
  _EmailServicePage createState() => _EmailServicePage();
}

class _EmailServicePage extends State<EmailServicePage> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "Email Service",
        description: "You can  create a poll without using your phone thanks to our Email Service !",
        styleDescription:
            TextStyle(color: Colors.white, fontSize: 20.0),
        pathImage: "assets/email.png",
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
    slides.add(
      new Slide(
        title: "Email Service",
        description: """You just put the poll information in a txt file using the following format \n\ntitle: Title
        options: option1,option2,option3""",
                styleDescription:
            TextStyle(color: Colors.white, fontSize: 20.0),
        pathImage: "assets/txt.png",
        backgroundColor: Colors.deepPurple[200],
      ),
    );
    slides.add(
      new Slide(
        title: "Email Service",
        description:
            "Finaly send it as attachement to \n\nsfueokfb@mailparser.io\n\n and set the email subject to the room token where you wish to create the sesion",
             styleDescription:
            TextStyle(color: Colors.white, fontSize: 20.0),
        pathImage: "assets/quiz.png",
        backgroundColor: Color(0xff9932CC),        
      ),
    );
  }

  void onDonePress() {
    Navigator.pop(context);
  }

  void onSkipPress() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      onSkipPress: this.onSkipPress,
    );
  }
}
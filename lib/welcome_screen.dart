import 'package:finalflutter/signin.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 100),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      width: 200,
                      height: 450,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.black),
                      child: Image(
                        image: AssetImage('assets/images/A11.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: Container(
                          width: 180,
                          height: 240,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                          ),
                          child: Image(
                            image: AssetImage('assets/images/A5.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ClipOval(
                        child: Container(
                          width: 190,
                          height: 190,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Image(
                            image: AssetImage('assets/images/A6.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              RichText(
                text: TextSpan(
                    text: 'The ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 28),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Fashion App',
                          style: TextStyle(
                              color: Color(0xFF704F38),
                              fontWeight: FontWeight.bold,
                              fontSize: 28)),
                      TextSpan(
                          text: ' That',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ))
                    ]),
              ),
              Text(
                'Makes You Look Your Best',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing',
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Suspendisse tincidunt, ex ac vulputate tempor, tortor nulla venenatis lectus.',
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Signin()));
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFF704F38)),
                  child: Center(
                    child: Text(
                      'Let\'s Get Started',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                  Text(
                    ' Sign In',
                    style: TextStyle(
                      color: Color(0xFF704F38),
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

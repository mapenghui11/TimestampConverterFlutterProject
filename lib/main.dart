import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'conventPageView.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark // 设置状态栏为透明
        ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const TimeStampConvert(),
    );
  }
}


class TimeStampConvert extends StatefulWidget {
  const TimeStampConvert({super.key});

  @override
  State<TimeStampConvert> createState() => _TimeStampConvertState();
}

class _TimeStampConvertState extends State<TimeStampConvert> {

  late Timer _timer;
  late String _currentTimeStamp;

  @override
  void initState() {
    super.initState();
    _currentTimeStamp = '';
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); 
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTimeStamp =
            (DateTime.now().millisecondsSinceEpoch).toString();
      });
    });
  }

  Color themeColor = const Color.fromARGB(255, 219, 218, 255);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 234, 238, 255),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              const Text(
                'TimeStampConvert',
                style: TextStyle(
                  fontFamily: 'AnekBangla',
                  fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 2,
              ),
              const Text(
                'by 0xMaph',
                style: TextStyle(
                    fontFamily: 'AnekBangla',
                    color: Color.fromARGB(255, 189, 192, 255),
                    fontSize: 12,
                    fontWeight: FontWeight.w300),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 50,
                width: 350,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: themeColor,
                ),
                child: Text(
                  'Current  timestamp  is  $_currentTimeStamp',
                  style: const TextStyle(
                    fontFamily: 'AnekBangla',
                    fontSize: 19, fontWeight: FontWeight.w300),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const ConventPageView(),
              const SizedBox(
                height: 30,
              ),
              const TimestampExplanation()
            ],
          ),
        ));
  }
}

class TimestampExplanation extends StatelessWidget {
  const TimestampExplanation({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      width: 330,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'second timestamp  &  millisecond timestamp',
            style: TextStyle(
              fontFamily: 'AnekBangla',
              fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'The ratio between seconds and milliseconds is 1:1000. Removing the last three digits yields the second timestamp, while adding three zeros results in the millisecond timestamp',
            style: TextStyle(
              fontFamily: 'AnekBangla',
              fontSize: 18, fontWeight: FontWeight.w300),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConventPageView extends StatefulWidget {
  const ConventPageView({super.key});

  @override
  State<ConventPageView> createState() => _ConventPageViewState();
}

class _ConventPageViewState extends State<ConventPageView> {
  Color themeColor = const Color.fromARGB(255, 219, 218, 255);
  Color highLight = const Color.fromARGB(200, 114, 111, 255);

  String selectedOption = 'CST, UTC+8';
  String selectTimeZone = 'Asia/Shanghai';

  bool hasTimeStampError = false;
  String timeStamp = '';
  String datetime = '';

  bool hasDatetimeError = true;
  String datetimeToConvert = '2021-01-01 00:00:00';
  String getTimestampMS = '';

  Future<void> _showMyDialog(BuildContext context) async {
    List<Map<String, String>> timezones = [
      {'label': 'Australia/Sydney', 'value': 'SBT, UTC+11'},
      {'label': 'Australia/Brisbane', 'value': 'AEST, UTC+10'},
      {'label': 'Asia/Tokyo', 'value': 'JST, UTC+9'},
      {'label': 'Asia/Shanghai', 'value': 'CST, UTC+8'},
      {'label': 'Asia/Bangkok', 'value': 'ICT, UTC+7'},
      {'label': 'Asia/Dhaka', 'value': 'BST, UTC+6'},
      {'label': 'Asia/Karachi', 'value': 'PKT, UTC+5'},
      {'label': 'Asia/Dubai', 'value': 'AST, UTC+4'},
      {'label': 'Europe/Moscow', 'value': 'MSK, UTC+3'},
      {'label': 'Europe/Athens', 'value': 'EET, UTC+2'},
      {'label': 'Europe/Paris', 'value': 'BST, UTC+1'},
      {'label': 'Europe/London', 'value': 'GMT, UTC+0'},
      {'label': 'Atlantic/Cape_Verde', 'value': 'CVT, UTC-1'},
      {'label': 'Atlantic/South_Georgia', 'value': 'GST, UTC-2'},
      {'label': 'America/Buenos_Aires', 'value': 'ART, UTC-3'},
      {'label': 'America/Caracas', 'value': 'AST, UTC-4'},
      {'label': 'America/New_York', 'value': 'EST, UTC-5'},
      {'label': 'America/Chicago', 'value': 'CST, UTC-6'},
      {'label': 'America/Denver', 'value': 'MST, UTC-7'},
      {'label': 'America/Los_Angeles', 'value': 'PST, UTC-8'},
      {'label': 'America/Anchorage', 'value': 'AKDT, UTC-9'},
      {'label': 'Pacific/Honolulu', 'value': 'HADT, UTC-10'},
      {'label': 'Pacific/Samoa', 'value': 'NT, UTC-11'},
      {'label': 'Pacific/Kwajalein', 'value': 'IDLW, UTC-12'},
    ];

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            scrollable: true,
            backgroundColor: themeColor,
            contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            content: SizedBox(
              height: 310,
              width: 300,
              child: SingleChildScrollView(
                child: ListBody(
                  children: timezones.map((timezone) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(timezone['value']);
                      },
                      child: ListTile(
                        title: Text(timezone['label']!),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ));
      },
    );

    if (result != null) {
      setState(() {
        selectedOption = result;
        selectTimeZone = timezones.firstWhere(
            (timezone) => timezone['value'] == selectedOption)['label']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 344,
        width: 400,
        child: PageView(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: themeColor,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Timestamp  to  time',
                            style: TextStyle(
                                fontFamily: 'AnekBangla', fontSize: 20),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Swipe right to switch conversion mode.',
                            style: TextStyle(
                                fontFamily: 'AnekBangla',
                                fontSize: 15,
                                fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                _showMyDialog(context);
                              },
                              style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500)),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all(highLight),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)))),
                              child: const Text(
                                'Select time zone',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InPutTimeStamp(
                                onTimeStampChanged: (value) {
                                  setState(() {
                                    hasTimeStampError = value;
                                  });
                                },
                                timeStampText: (text) {
                                  setState(() {
                                    timeStamp = text;
                                  });
                                },
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Container(
                                width: 88,
                                height: 50,
                                margin: const EdgeInsets.only(bottom: 24),
                                child: ElevatedButton(
                                  onPressed: hasTimeStampError
                                      ? () async {
                                          var url = Uri.http(
                                              '118.194.249.201:8000',
                                              'timestamp_to_time/$timeStamp/$selectTimeZone/');

                                          var response = await http.get(url);
                                          var responseBodyMap =
                                              json.decode(response.body);
                                          setState(() {
                                            datetime =
                                                responseBodyMap['datetime']
                                                    .toString();
                                          });
                                        }
                                      : null,
                                  style: ButtonStyle(
                                      padding: const MaterialStatePropertyAll(
                                          EdgeInsets.all(10)),
                                      textStyle: MaterialStateProperty.all(
                                          const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500)),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all(highLight),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)))),
                                  child: const Text('convert'),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          PrintTime(
                              timeZone: selectedOption, datetime: datetime),
                        ],
                      ),
                    ))),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: themeColor,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Time  to  timestamp',
                          style:
                              TextStyle(fontFamily: 'AnekBangla', fontSize: 20),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'Swipe left to switch conversion mode.',
                          style: TextStyle(
                              fontFamily: 'AnekBangla',
                              fontSize: 15,
                              fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              _showMyDialog(context);
                            },
                            style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                    const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500)),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all(highLight),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)))),
                            child: const Text('Select time zone'),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        InPutDatetime(
                          timezone: selectedOption,
                          onDatetimeChanged: (value) {
                            setState(() {
                              hasDatetimeError = value;
                            });
                          },
                          datetimeText: (text) {
                            setState(() {
                              datetimeToConvert = text;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 50,
                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 196,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: const [
                                          BoxShadow(
                                              offset: Offset(6, 6),
                                              blurRadius: 5,
                                              color: Colors.black12)
                                        ]),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 10,
                                    bottom: 0,
                                    child: Center(
                                      child: Text(
                                        getTimestampMS,
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                205, 114, 111, 255),
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                    top: 0,
                                    right: 10,
                                    bottom: 0,
                                    child: Center(
                                      child: Text(
                                        'ms',
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 88,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: hasDatetimeError
                                      ? () async {
                                          var url = Uri.http(
                                              '118.194.249.201:8000',
                                              'time_to_timestamp/$datetimeToConvert/$selectTimeZone/');

                                          var response = await http.get(url);
                                          if (response.statusCode == 200) {
                                            var responseBodyMap =
                                                json.decode(response.body);
                                            setState(() {
                                              getTimestampMS = responseBodyMap[
                                                      'timestamp_ms']
                                                  .toString();
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                  'time format error',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black54),
                                                ),
                                                elevation: 0,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor: themeColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        125, 0, 125, 388),
                                                duration:
                                                    const Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        }
                                      : null,
                                  style: ButtonStyle(
                                      padding: const MaterialStatePropertyAll(
                                          EdgeInsets.all(10)),
                                      textStyle: MaterialStateProperty.all(
                                          const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500)),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all(highLight),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)))),
                                  child: const Text('convert'),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ));
  }
}

class InPutTimeStamp extends StatefulWidget {
  final ValueChanged<bool>? onTimeStampChanged;
  final ValueChanged<String>? timeStampText;
  const InPutTimeStamp(
      {super.key,
      required this.onTimeStampChanged,
      required this.timeStampText});

  @override
  State<InPutTimeStamp> createState() => _InPutTimeStampState();
}

class _InPutTimeStampState extends State<InPutTimeStamp> {
  bool _hasTimeStampFormatError = false;
  Color highLight = const Color.fromARGB(200, 114, 111, 255);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 200,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(6, 6), blurRadius: 5, color: Colors.black12)
              ]),
        ),
        SizedBox(
            width: 200,
            height: 74,
            child: TextField(
              maxLength: 13,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.w300),
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Enter Timestamp',
                labelStyle:
                    const TextStyle(color: Colors.black45, fontSize: 16),
                contentPadding: const EdgeInsets.fromLTRB(12.0, 12.0, 0, 12.0),
                filled: true,
                fillColor: Colors.white,
                errorText: _getErrorText(),
                errorStyle: TextStyle(color: highLight),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              onChanged: (text) {
                setState(
                  () {
                    _hasTimeStampFormatError = !isTimestamp(text);
                    widget.onTimeStampChanged?.call(!_hasTimeStampFormatError);
                    widget.timeStampText?.call(text);
                  },
                );
              },
            )),
      ],
    );
  }

  bool isTimestamp(String text) {
    return RegExp(r'^\d{10}$|^\d{13}$').hasMatch(text);
  }

  String _getErrorText() {
    if (_hasTimeStampFormatError) {
      return 'Timestamp format error.';
    } else {
      return '';
    }
  }
}

class PrintTime extends StatefulWidget {
  final String timeZone;
  final String datetime;

  const PrintTime({super.key, required this.timeZone, required this.datetime});

  @override
  State<PrintTime> createState() => _PrintTimeState();
}

class _PrintTimeState extends State<PrintTime> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 300,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(6, 6), blurRadius: 5, color: Colors.black12)
              ]),
        ),
        Positioned(
          top: 0,
          left: 12,
          bottom: 0,
          child: Center(
            child: Text(
              widget.datetime,
              style: const TextStyle(
                  color: Color.fromARGB(205, 114, 111, 255), fontSize: 16),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 12,
          bottom: 0,
          child: Center(
            child: Text(
              widget.timeZone,
              style: const TextStyle(color: Colors.black45, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class InPutDatetime extends StatefulWidget {
  final String timezone;
  final ValueChanged<bool>? onDatetimeChanged;
  final ValueChanged<String>? datetimeText;
  const InPutDatetime(
      {super.key,
      required this.onDatetimeChanged,
      required this.datetimeText,
      required this.timezone});

  @override
  State<InPutDatetime> createState() => _InPutDatetimeState();
}

class _InPutDatetimeState extends State<InPutDatetime> {
  bool _hasDatetimeFormatError = false;
  Color highLight = const Color.fromARGB(200, 114, 111, 255);
  final TextEditingController _controller =
      TextEditingController(text: '2021-01-01 00:00:00');
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 300,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(6, 6), blurRadius: 5, color: Colors.black12)
              ]),
        ),
        SizedBox(
            width: 300,
            height: 74,
            child: TextField(
              maxLength: 19,
              controller: _controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w300),
              decoration: InputDecoration(
                counterText: '',
                suffixText: '${widget.timezone}  ',
                suffixStyle:
                    const TextStyle(color: Colors.black45, fontSize: 16),
                contentPadding: const EdgeInsets.fromLTRB(10.0, 15.0, 0, 15.0),
                filled: true,
                fillColor: Colors.white,
                errorText: _getErrorText(),
                errorStyle: TextStyle(color: highLight),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              onChanged: (text) {
                setState(
                  () {
                    _hasDatetimeFormatError = !isDatetime(text);
                    widget.onDatetimeChanged?.call(!_hasDatetimeFormatError);
                    widget.datetimeText?.call(text);
                  },
                );
              },
            )),
      ],
    );
  }

  bool isDatetime(String text) {
    return RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$').hasMatch(text);
  }

  String _getErrorText() {
    if (_hasDatetimeFormatError) {
      return 'Time format error.';
    } else {
      return '';
    }
  }
}

class PrintTimeStamp extends StatefulWidget {
  final String timestampSecond;
  final String timestampMilliSeconds;
  const PrintTimeStamp(
      {super.key,
      required this.timestampSecond,
      required this.timestampMilliSeconds});

  @override
  State<PrintTimeStamp> createState() => _PrintTimeStampState();
}

class _PrintTimeStampState extends State<PrintTimeStamp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 300,
      color: Colors.black12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(6, 6),
                          blurRadius: 5,
                          color: Colors.black12)
                    ]),
              ),
              Positioned(
                top: 0,
                left: 16,
                bottom: 0,
                child: Center(
                  child: Text(
                    widget.timestampMilliSeconds,
                    style: const TextStyle(
                        color: Color.fromARGB(205, 114, 111, 255),
                        fontSize: 16),
                  ),
                ),
              ),
              const Positioned(
                top: 0,
                right: 16,
                bottom: 0,
                child: Center(
                  child: Text(
                    'ms',
                    style: TextStyle(color: Colors.black45, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

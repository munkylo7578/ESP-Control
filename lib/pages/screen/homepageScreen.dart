import 'dart:io';

import 'package:ecommerce/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  double _verticalBalance = 0.25;
  double _horizontalBalance = 0.25;
  double testISpeedValue = 0.3;
  bool _proSwitch = false;
  Map<String, int> _settingSliderValue = {
    "pStability": 0,
    "dStability": 0,
    "pSpeed": 0,
    "iSpeed": 0
  };
  Map<String, int> _activeButton = {
    "right": 0,
    "left": 0,
    "speaker": 0,
    "notification": 0,
    "setting": 0,
    "up": 0,
    "down": 0
  };
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.copy)),
          IconButton(onPressed: () {}, icon: Icon(Icons.wifi)),
          IconButton(
              onPressed: () {},
              icon: Icon(
                  Platform.isAndroid ? Icons.more_vert : Icons.more_horiz)),
        ],
        title: const Text("Wifi Balancing Robot"),
        backgroundColor: Color.fromARGB(255, 169, 83, 184),
      ),
      body: Row(
        children: [
          Container(
            width: width * 0.33,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTapCancel: () {
                        setState(() {
                          _activeButton["up"] = 0;
                        });
                      },
                      onTapUp: (tabDetail) {
                        setState(() {
                          _activeButton["up"] = 0;
                        });
                      },
                      onTapDown: (tabDetail) {
                        setState(() {
                          _activeButton["up"] = 1;
                        });
                      },
                      child: Container(
                        color: _activeButton["up"] == 1
                            ? Colors.purple
                            : Colors.grey.withOpacity(0.5),
                        margin: EdgeInsets.only(bottom: 4),
                        child: Center(
                            child: Icon(
                          Icons.arrow_circle_up_outlined,
                          size: 40,
                        )),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTapCancel: () {
                        setState(() {
                          _activeButton["down"] = 0;
                        });
                      },
                      onTapUp: (tabDetail) {
                        setState(() {
                          _activeButton["down"] = 0;
                        });
                      },
                      onTapDown: (tabDetail) {
                        setState(() {
                          _activeButton["down"] = 1;
                        });
                      },
                      child: Container(
                        color: _activeButton["down"] == 1
                            ? Colors.purple
                            : Colors.grey.withOpacity(0.5),
                        child: Center(
                            child: Icon(
                          Icons.arrow_circle_down_outlined,
                          size: 40,
                        )),
                      ),
                    ))
              ],
            ),
          ),
          /*   Container(
            width: ,
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(color: Colors.red),
          ),
          Container(
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(color: Colors.red),
          ) */

          Container(
            width: width * 0.33,
            margin: EdgeInsets.only(
                right: width * 0.005, top: 30, left: width * 0.005),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTapCancel: () {
                          setState(() {
                            _activeButton["speaker"] = 0;
                          });
                        },
                        onTapUp: (tabDetail) {
                          setState(() {
                            _activeButton["speaker"] = 0;
                          });
                        },
                        onTapDown: (tabDetail) {
                          setState(() {
                            _activeButton["speaker"] = 1;
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.all(8),
                            color: _activeButton["speaker"] == 1
                                ? Colors.purple
                                : Colors.grey.withOpacity(0.5),
                            child: Icon(Icons.volume_up_rounded))),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: StatefulBuilder(
                                    builder: (context, setState) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Text("P-Stability"),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    '${_settingSliderValue["pStability"].toString()} %'),
                                                RotatedBox(
                                                  quarterTurns: 3,
                                                  child: Slider(
                                                      min: -100,
                                                      max: 100,
                                                      divisions: 100,
                                                      value:
                                                          _settingSliderValue[
                                                                  "pStability"]!
                                                              .toDouble(),
                                                      onChanged:
                                                          (double value) {
                                                        setState(() {
                                                          _settingSliderValue[
                                                                  "pStability"] =
                                                              value.toInt();
                                                        });
                                                      }),
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text("D-Stability"),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    '${_settingSliderValue["dStability"].toString()} %'),
                                                RotatedBox(
                                                  quarterTurns: 3,
                                                  child: Slider(
                                                      min: -100,
                                                      max: 100,
                                                      divisions: 100,
                                                      value:
                                                          _settingSliderValue[
                                                                  "dStability"]!
                                                              .toDouble(),
                                                      onChanged:
                                                          (double value) {
                                                        setState(() {
                                                          _settingSliderValue[
                                                                  "dStability"] =
                                                              value.toInt();
                                                        });
                                                      }),
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text("P-Speed"),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    '${_settingSliderValue["pSpeed"].toString()} %'),
                                                RotatedBox(
                                                  quarterTurns: 3,
                                                  child: Slider(
                                                      min: -100,
                                                      max: 100,
                                                      divisions: 100,
                                                      value:
                                                          _settingSliderValue[
                                                                  "pSpeed"]!
                                                              .toDouble(),
                                                      onChanged:
                                                          (double value) {
                                                        setState(() {
                                                          _settingSliderValue[
                                                                  "pSpeed"] =
                                                              value.toInt();
                                                        });
                                                      }),
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text("I-Speed"),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    '${_settingSliderValue["iSpeed"].toString()} %'),
                                                RotatedBox(
                                                  quarterTurns: 3,
                                                  child: Slider(
                                                      min: -100,
                                                      max: 100,
                                                      divisions: 100,
                                                      value:
                                                          _settingSliderValue[
                                                                  "iSpeed"]!
                                                              .toDouble(),
                                                      onChanged:
                                                          (double value) {
                                                        setState(() {
                                                          _settingSliderValue[
                                                                  "iSpeed"] =
                                                              value.toInt();
                                                        });
                                                      }),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        padding: EdgeInsets.all(8),
                        color: Colors.grey.withOpacity(0.5),
                        child: Icon(Icons.settings),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _activeButton["notification"] =
                              _activeButton["notification"] == 0 ? 1 : 0;
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.all(8),
                          color: _activeButton["notification"] == 0
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.purple,
                          child: Icon(_activeButton["notification"] == 0
                              ? Icons.notifications
                              : Icons.notifications_active)),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          RotatedBox(
                            quarterTurns: 3,
                            child: Slider(
                                value: _verticalBalance,
                                max: 0.5,
                                min: 0,
                                divisions: 50,
                                onChanged: (double value) {
                                  setState(() {
                                    _verticalBalance = value;
                                  });
                                }),
                          ),
                          Align(
                              child: Text(_verticalBalance.toString(),
                                  style: TextStyle(fontSize: 11)),
                              alignment: Alignment(0, 0.5)),
                        ],
                      ),
                    ),
                    /* SizedBox(
                      height: height * 0.5,
                      child: Align(
                          child: Text(_verticalBalance.toString(),
                              style: TextStyle(fontSize: 11)),
                          alignment: Alignment(0, 0.5)),
                    ), */
                    Container(
                      margin: EdgeInsets.only(left: 4, right: 1),
                      child: Row(
                        children: [
                          // Text("Pro"),
                          Container(
                            margin: EdgeInsets.only(left: 3, right: 6),
                            child: Switch(
                                value: _proSwitch,
                                onChanged: (bool value) {
                                  setState(() {
                                    _proSwitch = value;
                                  });
                                }),
                          ),
                          InkWell(
                            onTap: () => {},
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.grey.withOpacity(0.5)),
                              padding: EdgeInsets.all(8),
                              child: Text("Servo"),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              child: Expanded(
                                child: Align(
                                    child: Text(_horizontalBalance.toString(),
                                        style: TextStyle(fontSize: 11)),
                                    alignment: Alignment(0, 0.5)),
                              ),
                            ),
                            RotatedBox(
                              quarterTurns: 3,
                              child: Slider(
                                  value: _horizontalBalance,
                                  min: 0,
                                  max: 0.5,
                                  divisions: 50,
                                  onChanged: (double value) {
                                    setState(() {
                                      _horizontalBalance = value;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: width * 0.33,
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: InkWell(
                  onTapCancel: () {
                    setState(() {
                      _activeButton["left"] = 0;
                    });
                  },
                  onTapUp: (tabDetail) {
                    setState(() {
                      _activeButton["left"] = 0;
                    });
                  },
                  onTapDown: (tabDetail) {
                    setState(() {
                      _activeButton["left"] = 1;
                    });
                  },
                  child: Container(
                    color: _activeButton["left"] == 1
                        ? Colors.purple
                        : Colors.grey.withOpacity(0.5),
                    margin: EdgeInsets.only(right: 4),
                    child: Center(
                        child: Icon(
                      Icons.arrow_circle_left_outlined,
                      size: 40,
                    )),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTapCancel: () {
                    setState(() {
                      _activeButton["right"] = 0;
                    });
                  },
                  onTapUp: (tabDetail) {
                    setState(() {
                      _activeButton["right"] = 0;
                    });
                  },
                  onTapDown: (tabDetail) {
                    setState(() {
                      _activeButton["right"] = 1;
                    });
                  },
                  child: Container(
                    color: _activeButton["right"] == 1
                        ? Colors.purple
                        : Colors.grey.withOpacity(0.5),
                    child: Center(
                        child: Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 40,
                    )),
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  showDefault() {
    Fluttertoast.showToast(
      msg: 'This is a Top Long Toast',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

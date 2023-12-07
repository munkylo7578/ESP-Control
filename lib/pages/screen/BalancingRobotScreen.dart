import 'dart:io';
import "dart:async";

import 'package:ecommerce/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:open_settings/open_settings.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class BalancingRobotScreen extends StatefulWidget {
  const BalancingRobotScreen({super.key});

  @override
  State<BalancingRobotScreen> createState() => _BalancingRobotScreenState();
}

class _BalancingRobotScreenState extends State<BalancingRobotScreen> {
  late IOWebSocketChannel channel;

  double _verticalBalance = 0.25;
  late bool ledStatus;
  bool connected = false;
  late TextEditingController controllerUrl;
  double _horizontalBalance = 0.25;
  double testISpeedValue = 0.3;

  bool _proSwitch = false;
  Map<String, double> _settingSliderValue = {
    "fader3": 0.5,
    "fader4": 0.5,
    "fader5": 0.5,
    "fader6": 0.5
  };
  Map<String, int> _activeButton = {
    'left': 0,
    'right': 0,
    "push3": 0,
    "push1": 0,
    "push4": 0,
    "setting": 0,
    "up": 0,
    "down": 0,
  };
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controllerUrl = TextEditingController();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.dispose();
    controllerUrl.dispose();
  }

  Future<void> channelConnect(context, String cmd, double value,
      [Function? callback]) async {
    try {
      var convertedCmd = '';
      if (cmd == 'up' || cmd == 'down') {
        convertedCmd = "fader1";
      } else if (cmd == 'left' || cmd == 'right') {
        convertedCmd = 'fader2';
      } else {
        convertedCmd = cmd;
      }

      var uri = Uri.http("192.168.4.1", "", {convertedCmd: value.toString()});
      if (callback != null) {
        callback(() => {_settingSliderValue[cmd] = value});
      } else {
        setState(() {
          _activeButton[cmd] = (value == 0.5 || (value == 0.0)) ? 0 : 1;
        });
      }
      var res = await http.get(uri).timeout(const Duration(seconds: 2));

      /* await http.get(uri); */

      /* channel = IOWebSocketChannel.connect("ws://192.168.4.1");
      connected = true;
      channel.stream.listen(
        (message) {
          print(message);
        },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          ToastUtil().showCustom(context, error, Variants.error);
          print(error.toString());
        },
      ); */
    } catch (e) {
      ToastUtil().showCustom(context, "Kết nối lỗi !", Variants.error);
      print(e);
    }
  }

  handleSendCommand(cmd, context) {}

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Color defaultBtnColor = Colors.grey.withOpacity(0.5);

    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            InkWell(
              onTap: () {
                OpenSettings.openWIFISetting();
              },
              child: Icon(Icons.wifi),
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                // Handle menu item selection here
                var box = await Hive.openBox('userInfo');
                box.delete('token');
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'option1',
                    child: Text('Option 1'),
                  ),
                ];
              },
              icon: Icon(Icons.more_vert), // "More vert" icon
            ),
          ],
          title: const Text("Xe thăng bằng"),
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
                          channelConnect(context, "up", 0.5);
                        },
                        onTapUp: (tabDetail) {
                          channelConnect(context, "up", 0.5);
                        },
                        onTapDown: (tabDetail) {
                          channelConnect(context, "up", 0.5 + _verticalBalance);
                        },
                        child: Container(
                          color: _activeButton["up"] == 0
                              ? defaultBtnColor
                              : Theme.of(context).primaryColor,
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
                          channelConnect(context, "down", 0.5);
                        },
                        onTapUp: (tabDetail) {
                          channelConnect(context, "down", 0.5);
                        },
                        onTapDown: (tabDetail) {
                          channelConnect(
                              context, "down", 0.5 - _verticalBalance);
                        },
                        child: Container(
                          color: _activeButton["down"] == 0
                              ? defaultBtnColor
                              : Theme.of(context).primaryColor,
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
                            channelConnect(context, "push3", 0);
                          },
                          onTapUp: (tabDetail) {
                            channelConnect(context, "push3", 0);
                          },
                          onTapDown: (tabDetail) {
                            channelConnect(context, "push3", 1);
                          },
                          child: Container(
                              padding: EdgeInsets.all(8),
                              color: _activeButton["push3"] == 0
                                  ? defaultBtnColor
                                  : Theme.of(context).primaryColor,
                              child: Icon(Icons.volume_up_rounded))),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: StatefulBuilder(
                                      builder: (context, setState) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 30),
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
                                                      '${_settingSliderValue["fader3"].toString()} %'),
                                                  RotatedBox(
                                                    quarterTurns: 3,
                                                    child: Slider(
                                                        min: 0,
                                                        max: 1,
                                                        divisions: 200,
                                                        value:
                                                            _settingSliderValue[
                                                                "fader3"]!,
                                                        onChanged:
                                                            (double value) {
                                                          channelConnect(
                                                              context,
                                                              "fader3",
                                                              value,
                                                              setState);
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
                                                      '${_settingSliderValue["fader4"].toString()} %'),
                                                  RotatedBox(
                                                    quarterTurns: 3,
                                                    child: Slider(
                                                        min: 0,
                                                        max: 1,
                                                        divisions: 200,
                                                        value:
                                                            _settingSliderValue[
                                                                "fader4"]!,
                                                        onChanged:
                                                            (double value) {
                                                          channelConnect(
                                                              context,
                                                              "fader4",
                                                              value);
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
                                                      '${_settingSliderValue["fader5"].toString()} %'),
                                                  RotatedBox(
                                                    quarterTurns: 3,
                                                    child: Slider(
                                                        min: 0,
                                                        max: 1,
                                                        divisions: 200,
                                                        value:
                                                            _settingSliderValue[
                                                                "fader5"]!,
                                                        onChanged:
                                                            (double value) {
                                                          channelConnect(
                                                              context,
                                                              "fader5",
                                                              value);
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
                                                      '${_settingSliderValue["fader6"].toString()} %'),
                                                  RotatedBox(
                                                    quarterTurns: 3,
                                                    child: Slider(
                                                        min: 0,
                                                        max: 1,
                                                        divisions: 200,
                                                        value:
                                                            _settingSliderValue[
                                                                "fader6"]!,
                                                        onChanged:
                                                            (double value) {
                                                          channelConnect(
                                                              context,
                                                              "fader6",
                                                              value);
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
                          color: defaultBtnColor,
                          child: Icon(Icons.settings),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          channelConnect(context, "push4",
                              _activeButton['push4'] == 0 ? 1.toDouble() : 0);
                        },
                        child: Container(
                            padding: EdgeInsets.all(8),
                            color: _activeButton["push4"] == 0
                                ? defaultBtnColor
                                : Theme.of(context).primaryColor,
                            child: Icon(_activeButton["push4"] == 0
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
                              onTapCancel: () {
                                channelConnect(context, "push1", 0);
                              },
                              onTapUp: (tabDetail) {
                                channelConnect(context, "push1", 0);
                              },
                              onTapDown: (tabDetail) {
                                channelConnect(context, "push1", 1);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: _activeButton['push1']! == 0
                                        ? defaultBtnColor
                                        : Theme.of(context).primaryColor),
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
                      channelConnect(context, "left", 0.5);
                    },
                    onTapUp: (tabDetail) {
                      channelConnect(context, "left", 0.5);
                    },
                    onTapDown: (tabDetail) {
                      channelConnect(context, "left", 0.5 + _horizontalBalance);
                    },
                    child: Container(
                      color: _activeButton["left"] == 0
                          ? defaultBtnColor
                          : Theme.of(context).primaryColor,
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
                      channelConnect(context, "right", 0.5);
                    },
                    onTapUp: (tabDetail) {
                      channelConnect(context, "right", 0.5);
                    },
                    onTapDown: (tabDetail) {
                      channelConnect(
                          context, "right", 0.5 - _horizontalBalance);
                    },
                    child: Container(
                      color: _activeButton["right"] == 1
                          ? Theme.of(context).primaryColor
                          : defaultBtnColor,
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  double _currentSliderValue = 0.22;
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
        title: const Text("Wifi Balancing Robot"),
        backgroundColor: Color.fromRGBO(51, 200, 138, 1),
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
                      onTap: () {},
                      child: Container(
                        color: Colors.grey.withOpacity(0.5),
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
                      onTap: () {},
                      child: Container(
                        color: Colors.grey.withOpacity(0.5),
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
            margin: EdgeInsets.symmetric(horizontal: width * 0.005),
            child: Row(
              children: [
                Container(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("test"),
                                Text("test"),
                                Text('Test')
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            RotatedBox(
                              quarterTurns: 3,
                              child: Slider(
                                  label: _currentSliderValue.toString(),
                                  value: _currentSliderValue,
                                  max: 1,
                                  divisions: 100,
                                  onChanged: (double value) {
                                    setState(() {
                                      _currentSliderValue = value;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            height: height,
          ),
          Container(
            width: width * 0.33,
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {},
                  child: Container(
                    color: Colors.grey.withOpacity(0.5),
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
                  onTap: () {},
                  child: Container(
                    color: Colors.grey.withOpacity(0.5),
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
}

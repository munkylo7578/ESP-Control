import 'package:ecommerce/pages/screen/BalancingRobotScreen.dart';
import 'package:ecommerce/pages/screen/DrawingScreen.dart';
import 'package:ecommerce/pages/screen/LoginScreen.dart';
import 'package:ecommerce/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter/services.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh mục'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: GridView.count(
        padding: EdgeInsets.all(14),
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        crossAxisCount: 2,
        children: List.generate(categories.length, (index) {
          return Center(
            child: CategoryCard(category: categories[index]),
          );
        }),
      ),
    );
  }
}

class Category {
  final String name;
  final IconData icon;
  final Function onTap;

  Category({required this.name, required this.icon, required this.onTap});
}

final categories = [
  Category(
    name: 'XE THẰNG BẰNG',
    icon: Icons.balance,
    onTap: (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BalancingRobotScreen()),
      );
    },
  ),
  Category(
    name: 'CNC',
    icon: Icons.draw,
    onTap: (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DrawingScreen()),
      );
    },
  ),
  Category(
    name: 'ĐĂNG XUẤT',
    icon: Icons.logout,
    onTap: (BuildContext context) async {
      var box = await Hive.openBox('userInfo');
      box.delete('token');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => loginScreen()),
      );
    },
  ),
  // Add other categories here...
];

class CategoryCard extends StatefulWidget {
  final Category category;
  final bool showToast;

  CategoryCard({required this.category, this.showToast = false});

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _isPressed = false;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTapDown: (details) {
          setState(() {
            _isPressed = true;
          });
        },
        onTapUp: (details) {
          setState(() {
            _isPressed = false;
          });
          widget.category.onTap(context);
        },
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },
        child: Transform.scale(
          scale: _isPressed ? 0.95 : 1.0,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                colors: [Colors.pink[300]!, Colors.deepPurple[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple[200]!.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  widget.category.icon,
                  size: 60.0,
                  color: Colors.white,
                ),
                SizedBox(height: 20.0),
                Flexible(
                  child: Text(
                    widget.category.name,
                    textAlign: TextAlign.center, // Center align the text
                    overflow:
                        TextOverflow.ellipsis, // Add ellipsis for long text
                    maxLines: 2, // Maximum of two lines
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

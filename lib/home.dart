import 'package:dynamicapp/animate_do.dart';
import 'package:dynamicapp/app_map_screen.dart';
import 'package:dynamicapp/my_library.dart';
import 'package:dynamicapp/services/dynamic_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // appController.setIndexScreen(0);
      Fluttertoast.showToast(msg: 'انقر مرة أخرى للمغادرة');
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  int selectedIndex = -1;
  List<int> selectedList = [];
  bool click = false;

  toggle() {
    click = !click;
    setState(() {});
  }

  setSelectedIndex(int index) {
    this.selectedIndex = selectedIndex == index ? -1 : index;
    print(selectedIndex);
    setState(() {});
  }

  addSelectedList(int index) {
    selectedList.contains(index)
        ? selectedList.remove(index)
        : selectedList.add(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Get.to(() => MapSample());
            },
            label: Text('Map')),
        appBar: AppBar(
          title: Text('share product'),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              DynamicLink().createDynamicLink('1');
            },
            child: Icon(
              Icons.share,
              color: Colors.red,
              size: 30,
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 200,
              child: ListView.separated(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(
                  width: 10,
                ),
                itemBuilder: (context, index) {
                  return FadeInLeft(
                    delay: Duration(milliseconds: 50 * index),
                    child: GestureDetector(
                      onTap: () {
                        setSelectedIndex(index);
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 45,
                            width: 50,
                            color: selectedIndex == index
                                ? Colors.blueGrey
                                : Colors.red,
                            alignment: Alignment.center,
                            child: Text(index.toString()),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 200,
              child: ListView.separated(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(
                  width: 10,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      addSelectedList(index);
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 45,
                          width: 50,
                          color: selectedList.contains(index)
                              ? Colors.blueGrey
                              : Colors.red,
                          alignment: Alignment.center,
                          child: Text(index.toString()),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            // Spacer(),
            // GestureDetector(
            //   onTap: () {
            //     toggle();
            //   },
            //   child: AnimatedContainer(
            //     duration: Duration(milliseconds: 400),
            //     width: click ? 100 : 200,
            //     height: click ? 50 : 100,
            //     decoration:
            //         BoxDecoration(color: click ? Colors.red : Colors.blue),
            //     alignment: Alignment.center,
            //     child: AnimatedSwitcher(
            //         duration: Duration(milliseconds: 400),
            //         child: click
            //             ? Text(
            //                 'أجب',
            //                 key: UniqueKey(),
            //               )
            //             : Text(
            //                 'تمت الاجابة',
            //                 key: UniqueKey(),
            //               )),
            //   ),
            // ),
            // SizedBox(
            //   height: 20,
            // )
          ],
        ),
      ),
    );
  }
}

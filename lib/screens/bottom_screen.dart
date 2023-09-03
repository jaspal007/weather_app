import 'package:flutter/material.dart';

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({super.key});

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  TextEditingController cityController = TextEditingController();
  bool isNull = true;

  @override
  void initState() {
    super.initState();
    cityController.addListener(() {
      setState(() {
        if (cityController.text.isEmpty) {
          isNull = true;
        } else {
          isNull = false;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    cityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    double keyboard = MediaQuery.of(context).viewInsets.bottom;
    double height = MediaQuery.of(context).size.height;
    return (orientation == Orientation.portrait)
        ? Container(
            margin: const EdgeInsets.only(
              top: 40,
              left: 10,
              right: 10,
            ),
            height: height * 0.8,
            child: SizedBox(
              // color: Colors.red,
              child: Column(
                children: [
                  TextField(
                    controller: cityController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      suffixIcon: (isNull)
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  cityController.clear();
                                  isNull = true;
                                });
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                            ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  SizedBox(
                    height: height * 0.7 - keyboard,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text("hello $index"),
                            ),
                            const Divider(
                              indent: 50,
                              thickness: 2,
                              endIndent: 50,
                            )
                          ],
                        );
                      },
                      itemCount: 50,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            margin: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            height: height,
            child: SizedBox(
              // color: Colors.red,
              child: Column(
                children: [
                  TextField(
                    controller: cityController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      suffixIcon: (isNull)
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  cityController.clear();
                                  isNull = true;
                                });
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                            ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  SizedBox(
                    height: height * 0.7 - keyboard,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text("hello $index"),
                            ),
                            const Divider(
                              indent: 50,
                              thickness: 2,
                              endIndent: 50,
                            )
                          ],
                        );
                      },
                      itemCount: 50,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

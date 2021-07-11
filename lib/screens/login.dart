import 'package:flutter/material.dart';
import 'package:free2play/utils.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "../assets/images/login_bg.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                      ),
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 25, right: 25),
                          child: const Image(
                            image:
                                AssetImage("../assets/images/large_logo.png"),
                            height: 100,
                          )),
                      Container(
                        height: 80,
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                        child: customTextField(nameController, "Username"),
                      ),
                      Container(
                        height: 80,
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                        child: customTextField(passwordController, "Password"),
                      ),
                      Container(
                          height: 80,
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 25, right: 25),
                          child: ElevatedButton(
                            child: const Text('Login'),
                            onPressed: () {
                              print(nameController.text);
                              print(passwordController.text);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: ProjectColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              textStyle: const TextStyle(
                                  color: ProjectColors.foreground,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          )),
                    ],
                  )),
            )),
      ],
    );
  }
}

TextField customTextField(TextEditingController? cntroller, String? txt) {
  return TextField(
    controller: cntroller,
    style: const TextStyle(color: ProjectColors.foreground, fontSize: 20),
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.only(top: 40, bottom: 40, left: 20),
      border: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromRGBO(255, 255, 255, 0.45), width: 2)),
      enabledBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromRGBO(255, 255, 255, 0.45), width: 2)),
      focusedBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromRGBO(72, 52, 212, 1), width: 2)),
      labelStyle: const TextStyle(color: ProjectColors.foreground),
      hintStyle: const TextStyle(color: ProjectColors.foreground),
      labelText: txt,
    ),
  );
}

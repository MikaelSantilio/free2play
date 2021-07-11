import 'package:flutter/material.dart';
import 'package:free2play/utils.dart';
import 'package:free2play/screens/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  Widget _btnLoginContent = const Text("Login");

  @override
  void initState() {
    () async => {
      if (await API.getToken() != "") {
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),)
      }
    };
    super.initState();
    print("initi state");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/images/login_bg.png",
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
                              top: 15, bottom: 15, left: 25, right: 25),
                          child: const Image(
                            image: AssetImage("assets/images/large_logo.png"),
                            height: 130,
                          )),
                      Container(
                        height: 80,
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 25, right: 25),
                        child: customTextField(nameController, "Username"),
                      ),
                      Container(
                        height: 80,
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 25, right: 25),
                        child: customTextField(passwordController, "Password",
                            obscureText: true),
                      ),
                      Container(
                          height: 80,
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 25, right: 25),
                          child: ElevatedButton(
                            child: _btnLoginContent,
                            onPressed: () {
                              _handleSubmitted(
                                  nameController.text, passwordController.text);
                              // print(nameController.text);
                              // print(passwordController.text);
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

  TextField customTextField(TextEditingController? cntroller, String? txt,
      {bool obscureText = false}) {
    return TextField(
      controller: cntroller,
      obscureText: obscureText && _obscureText,
      autocorrect: false,
      cursorColor: ProjectColors.primary,
      style: const TextStyle(color: ProjectColors.foreground, fontSize: 18),
      decoration: InputDecoration(
        suffixIcon: obscureText
            ? IconButton(
                onPressed: () => {
                  setState(() {
                    _obscureText = !_obscureText;
                  })
                },
                icon: Icon(
                  obscureText && _obscureText
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: ProjectColors.getWhiteRGBO(opacity: 0.65),
                ),
              )
            : null,
        contentPadding: const EdgeInsets.only(top: 40, bottom: 40, left: 20),
        border: OutlineInputBorder(
            borderSide:
                BorderSide(color: ProjectColors.getWhiteRGBO(), width: 2)),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ProjectColors.getWhiteRGBO(), width: 2)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ProjectColors.primary, width: 2)),
        labelStyle: TextStyle(color: ProjectColors.getWhiteRGBO(opacity: 0.75)),
        hintStyle: TextStyle(color: ProjectColors.getWhiteRGBO(opacity: 0.75)),
        labelText: txt,
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context, String title, String body) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(body),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  void _handleSubmitted(String username, String password) async {
    // final FormState form = _formKey.currentState;
    setState(() {
      _btnLoginContent = const CircularProgressIndicator(
        color: ProjectColors.foreground,
      );
    });
    final apiResponse = await API.loginRequest(username, password);
    if (!apiResponse["status"]) {
      setState(() {
        _btnLoginContent = const Text("Login");
      });
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            _buildPopupDialog(context, "Erro", apiResponse["detail"]),
      );
      return;
    }
    setState(() {
        _btnLoginContent = const Text("Login");
      });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

// TextField customTextField(TextEditingController? cntroller, String? txt, {bool obscureText = false}) {
//   return TextField(
//     controller: cntroller,
//     obscureText: obscureText && _obscureText,
//     autocorrect: false,
//     cursorColor: ProjectColors.primary,
//     style: const TextStyle(color: ProjectColors.foreground, fontSize: 20),
//     decoration: InputDecoration(
//       suffixIcon: obscureText ? IconButton(
//       onPressed: () => {

//       },
//       icon: obscureText && _obscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off)
//     ) : null,
//       contentPadding: const EdgeInsets.only(top: 40, bottom: 40, left: 20),
//       border: OutlineInputBorder(
//           borderSide:
//               BorderSide(color: ProjectColors.getWhiteRGBO(), width: 2)),
//       enabledBorder: OutlineInputBorder(
//           borderSide:
//               BorderSide(color: ProjectColors.getWhiteRGBO(), width: 2)),
//       focusedBorder: const OutlineInputBorder(
//           borderSide:
//               BorderSide(color: ProjectColors.primary, width: 2)),
//       labelStyle: TextStyle(color: ProjectColors.getWhiteRGBO(opacity: 0.75)),
//       hintStyle: TextStyle(color: ProjectColors.getWhiteRGBO(opacity: 0.75)),
//       labelText: txt,
//     ),
//   );
// }
}

import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:password_validator/password_validator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:greenaction/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum singpageenum { logIn, register, forgotpassword, signInPage }

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  singpageenum _singpageenum = singpageenum.signInPage;
  String usermail;
  bool _ispressed = false;
  @override
  Widget build(BuildContext context) {
    print('registerpage');
    return Scaffold(
      body: Center(
        child: _singpageenum == singpageenum.logIn
            ? emailLogIn()
            : _singpageenum == singpageenum.forgotpassword
                ? resetPassword()
                : _singpageenum == singpageenum.signInPage
                    ? signInPage()
                    : register(),
      ),
    );
  }

  Scaffold signInPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Green Actions'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.orangeAccent)),
              onPressed: _ispressed
                  ? null
                  : () {
                      setState(() {
                        _singpageenum = singpageenum.register;
                      });
                    },
              child: Text(
                'SIGN IN WITH E-MAIL',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
              onPressed: _ispressed ? null : _signinwithgoogle,
              child: Text(
                'SIGN IN WITH GOOGLE',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.blueAccent)),
              onPressed: _ispressed ? null : printfonk,
              child: Text(
                'SIGN IN WITH FACEBOOK',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            IconButton(
                icon: Icon(Icons.camera),
                onPressed: () async {
                  final _preferences = await SharedPreferences.getInstance();

                  await _preferences.clear();
                }),
          ],
        ),
      ),
    );
  }

//add alert dialogs for specific errors
  Scaffold emailLogIn() {
    final _logInFormkey = GlobalKey<FormState>();
    TextEditingController _passwordcontroller = TextEditingController();
    TextEditingController _emailcontroller = TextEditingController();
    bool isPressed = false;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                _singpageenum = singpageenum.signInPage;
              });
            },
          )
        ],
        title: Text('Green Actions'),
      ),
      body: Form(
          key: _logInFormkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'LOG IN TO GREEN ACTIONS',
                style: TextStyle(
                  color: Colors.green[900],
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _emailcontroller,
                validator: (value) {
                  if (!EmailValidator.validate(value)) {
                    return 'Please write a valid e-mail';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'E-mail',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passwordcontroller,
                obscureText: false,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (isPressed == false) {
                      isPressed = true;
                      if (_logInFormkey.currentState.validate()) {
                        try {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              });

                          final user = await Provider.of<CustomAuthentication>(
                                  context,
                                  listen: false)
                              .emailLogIn(_emailcontroller.text,
                                  _passwordcontroller.text);

                          if (!user.emailVerified) {
                            isPressed = false;
                            Navigator.pop(context);
                            await Provider.of<CustomAuthentication>(context,
                                    listen: false)
                                .signOut();

                            await _showMyDialog();
                          }
                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                        } catch (e) {
                          isPressed = false;
                          Navigator.pop(context);
                          _errorDialog();
                        }
                      }
                    }
                  },
                  child: Text('Log in')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _singpageenum = singpageenum.register;
                    });
                  },
                  child: Text('Create an account')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _singpageenum = singpageenum.forgotpassword;
                    });
                  },
                  child: Text('Forgot my password'))
            ],
          )),
    );
  }

//add alert dialog to catch and Navigate.pop() Email or password is not correct
  Scaffold register() {
    final _signInFormkey = GlobalKey<FormState>();
    TextEditingController _passwordcontroller = TextEditingController();
    //TextEditingController _passwordconfirmcontroller = TextEditingController();
    TextEditingController _emailcontroller = TextEditingController();
    PasswordValidator passwordValidator = new PasswordValidator(
        uppercase: 1,
        min: 6,
        digits: 1,
        blacklist: ["password", "mysecretpassword"]);
    bool isPressed = false;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                _singpageenum = singpageenum.signInPage;
              });
            },
          )
        ],
        title: Text('Green Actions'),
      ),
      body: Form(
          key: _signInFormkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'REGISTER TO GREEN ACTIONS',
                style: TextStyle(
                  color: Colors.green[900],
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (!EmailValidator.validate(value)) {
                    return 'Please write a valid e-mail';
                  } else {
                    return null;
                  }
                },
                controller: _emailcontroller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'E-mail',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (!passwordValidator.validate(value)) {
                    return 'Please write a valid password';
                  } else {
                    return null;
                  }
                },
                controller: _passwordcontroller,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: 10,
              ),
              FlutterPwValidator(
                  controller: _passwordcontroller,
                  minLength: 6,
                  uppercaseCharCount: 1,
                  numericCharCount: 1,
                  specialCharCount: 0,
                  width: 400,
                  height: 150,
                  onSuccess: () {}),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (isPressed == false) {
                      isPressed = true;
                      if (_signInFormkey.currentState.validate()) {
                        try {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              });
                          final user = await Provider.of<CustomAuthentication>(
                                  context,
                                  listen: false)
                              .register(_emailcontroller.text,
                                  _passwordcontroller.text);
                          usermail = user.email;
                          if (!user.emailVerified) {
                            isPressed = false;
                            await user.sendEmailVerification();
                            await Provider.of<CustomAuthentication>(context,
                                    listen: false)
                                .signOut();
                            Navigator.pop(context);
                            await _showMyDialog();
                          }

                          setState(() {
                            _singpageenum = singpageenum.logIn;
                          });
                        } catch (e) {
                          isPressed = false;
                          Navigator.pop(context);
                          _errorDialog();
                        }
                      }
                    }
                  },
                  child: Text('Register')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _singpageenum = singpageenum.logIn;
                    });
                  },
                  child: Text('Log in to your account'))
            ],
          )),
    );
  }

  Padding resetPassword() {
    final _logInFormkey = GlobalKey<FormState>();
    TextEditingController _emailcontroller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
          key: _logInFormkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'RESET YOUR PASSWORD',
                style: TextStyle(
                  color: Colors.green[900],
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (!EmailValidator.validate(value)) {
                    return 'please write a valid email';
                  } else {
                    return null;
                  }
                },
                controller: _emailcontroller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'E-mail',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_logInFormkey.currentState.validate()) {
                      usermail = _emailcontroller.text;
                      try {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                        await Provider.of<CustomAuthentication>(context,
                                listen: false)
                            .resetPassword(_emailcontroller.text);

                        Navigator.pop(context);
                        await _resetDialog();
                      } catch (err) {
                        Navigator.pop(context);
                        await _alertDialog();
                      }
                    }
                  },
                  child: Text('Reset')),
              TextButton(
                onPressed: () {
                  setState(() {
                    _singpageenum = singpageenum.logIn;
                  });
                },
                child: Text('Back to login screen'),
              ),
            ],
          )),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('email confirmation'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('We sent to $usermail  a confirmation link'),
                  Text('Please confirm your email to log in your accout'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> _resetDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password reset'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('We sent to $usermail  a reset link'),
                  Text('Please go to your email to reset your password'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> _alertDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$usermail is invalid'),
            content: SingleChildScrollView(
              child: ListBody(),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> _errorDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('There is an error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [Text('Email or password is not correct')],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> _signinwithgoogle() async {
    setState(() {
      _ispressed = false;
    });
    await Provider.of<CustomAuthentication>(context, listen: false)
        .signInWithGoogle();
    setState(() {
      _ispressed = false;
    });
  }

  printfonk() {
    print('button is disabled');
  }
}

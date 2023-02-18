import 'package:authentication/provider/internet_provider.dart';
import 'package:authentication/provider/sign_in_provider.dart';
import 'package:authentication/screens/home_screen.dart';
import 'package:authentication/utils/config.dart';
import 'package:authentication/utils/next_screen.dart';
import 'package:authentication/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController facebookController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController twitterController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 40, right: 40, top: 90, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      image: AssetImage(config.app_icon),
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Welcome to flutterAuthenetication",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Learn Authentication with Provider",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    )
                  ],
                ),
              ),
              // roundedbutton
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google login button
                  RoundedLoadingButton(
                    controller: googleController,
                    onPressed: () {},
                    successColor: Colors.green,
                    color: Colors.red,
                    width: MediaQuery.of(context).size.width * 0.80,
                    elevation: 0,
                    borderRadius: 25,
                    child: Wrap(
                      children: const [
                        Icon(
                          FontAwesomeIcons.google,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Sign in with Google",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // facebook login button
                  RoundedLoadingButton(
                    controller: facebookController,
                    onPressed: () {
                      handleFacebookAuth();
                    },
                    successColor: Colors.blue,
                    color: Colors.blue,
                    width: MediaQuery.of(context).size.width * 0.80,
                    elevation: 0,
                    borderRadius: 25,
                    child: Wrap(
                      children: const [
                        Icon(
                          FontAwesomeIcons.facebook,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Sign in with Facebook",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // twitter login button
                  RoundedLoadingButton(
                    controller: twitterController,
                    onPressed: () {
                      handleTwitterAuth();
                    },
                    successColor: Colors.lightBlueAccent,
                    color: Colors.lightBlueAccent,
                    width: MediaQuery.of(context).size.width * 0.80,
                    elevation: 0,
                    borderRadius: 25,
                    child: Wrap(
                      children: const [
                        Icon(
                          FontAwesomeIcons.twitter,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Sign in with Twitter",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // handling google sigin in
  Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternerConnection();

    if (ip.hasInterner == false) {
      openSnackbar(
        context,
        "Check Your Interner Connection",
      );
      googleController.reset();
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          openSnackbar(context, sp.errorCode.toString());
          googleController.reset();
        } else {
          // checking whether user exists or not
          sp.chckUserExists().then((value) async {
            if (value == true) {
              // user exists
              await sp.getUserDataFromFirestore(sp.uid).then((value) {
                sp.saveDataToSharedPreferences().then((value) {
                  sp.setSignIn().then((value) {
                    googleController.success();
                    handleAfterSignIn();
                  });
                });
              });
            } else {
              // user does not exist
              sp.saveDataToFireStore().then((value) {
                sp.saveDataToSharedPreferences().then((value) {
                  sp.setSignIn().then((value) {
                    googleController.success();
                    handleAfterSignIn();
                  });
                });
              });
            }
          });
        }
      });
    }
  }

  // handling facebookAuthentication
  Future handleFacebookAuth() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternerConnection();

    if (ip.hasInterner == false) {
      openSnackbar(
        context,
        "Check Your Interner Connection",
      );
      facebookController.reset();
    } else {
      await sp.signInWithFacebook().then((value) {
        if (sp.hasError == true) {
          openSnackbar(context, sp.errorCode.toString());
          facebookController.reset();
        } else {
          // checking whether user exists or not
          sp.chckUserExists().then((value) async {
            if (value == true) {
              // user exists
              await sp.getUserDataFromFirestore(sp.uid).then((value) {
                sp.saveDataToSharedPreferences().then((value) {
                  sp.setSignIn().then((value) {
                    facebookController.success();
                    handleAfterSignIn();
                  });
                });
              });
            } else {
              // user does not exist
              sp.saveDataToFireStore().then((value) {
                sp.saveDataToSharedPreferences().then((value) {
                  sp.setSignIn().then((value) {
                    facebookController.success();
                    handleAfterSignIn();
                  });
                });
              });
            }
          });
        }
      });
    }
  }

  //handling twitter Auth
  Future handleTwitterAuth() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternerConnection();

    if (ip.hasInterner == false) {
      openSnackbar(
        context,
        "Check Your Interner Connection",
      );
      twitterController.reset();
    } else {
      await sp.signInWithTwitter().then((value) {
        if (sp.hasError == true) {
          openSnackbar(context, sp.errorCode.toString());
          twitterController.reset();
        } else {
          // checking whether user exists or not
          sp.chckUserExists().then((value) async {
            if (value == true) {
              // user exists
              await sp.getUserDataFromFirestore(sp.uid).then((value) {
                sp.saveDataToSharedPreferences().then((value) {
                  sp.setSignIn().then((value) {
                    twitterController.success();
                    handleAfterSignIn();
                  });
                });
              });
            } else {
              // user does not exist
              sp.saveDataToFireStore().then((value) {
                sp.saveDataToSharedPreferences().then((value) {
                  sp.setSignIn().then((value) {
                    googleController.success();
                    handleAfterSignIn();
                  });
                });
              });
            }
          });
        }
      });
    }
  }

  handleAfterSignIn() {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      nextScreenReplace(context, const HomeScreen());
    });
  }
}

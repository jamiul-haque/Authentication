import 'package:authentication/provider/internet_provider.dart';
import 'package:authentication/provider/sign_in_provider.dart';
import 'package:authentication/screens/home_screen.dart';
import 'package:authentication/utils/config.dart';
import 'package:authentication/utils/next_screen.dart';
import 'package:authentication/utils/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final formKey = GlobalKey<FormState>();
  // controller ->phone, email, name ,otp code
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                        image: AssetImage(config.app_icon),
                        height: 50,
                        width: 50),
                    const SizedBox(height: 10),
                    const Text(
                      "Phone Login",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Name Cannot be empty.";
                        }
                        return null;
                      },
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.account_circle),
                          hintText: "Jamiul Haque",
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: Colors.grey))),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email Address Cannot be empty.";
                        }
                        return null;
                      },
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          hintText: "abcd@gmail.com",
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: Colors.grey))),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Phone Number Cannot be empty.";
                        }
                        return null;
                      },
                      controller: phoneController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.phone),
                          hintText: "+880123456789",
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: Colors.grey))),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () {
                          login(context, phoneController.text.trim());
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        child: const Text(
                          "Register",
                        )),
                  ],
                ),
              )),
        ));
  }

  Future login(BuildContext context, String mobile) async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternerConnection();
    if (ip.hasInterner == false) {
      openSnackbar(context, "Check your interner connection", Colors.red);
    } else {
      if (formKey.currentState!.validate()) {
        FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: mobile,
            verificationCompleted: (AuthCredential credential) async {
              await FirebaseAuth.instance.signInWithCredential(credential);
            },
            verificationFailed: (FirebaseAuthException e) {
              openSnackbar(context, e.toString(), Colors.red);
            },
            codeSent: (String verificationId, int? forceResendingToken) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Enter Code"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: otpController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.code),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              final code = otpController.text.trim();
                              AuthCredential authCredential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: code);
                              User user = (await FirebaseAuth.instance
                                      .signInWithCredential(authCredential))
                                  .user!;
                              // save the value
                              sp.phoneNumberUser(user, emailController.text,
                                  nameController.text);
                              // checking whether user exists or not
                              sp.chckUserExists().then((value) async {
                                if (value == true) {
                                  // user exists
                                  await sp
                                      .getUserDataFromFirestore(sp.uid)
                                      .then((value) {
                                    sp
                                        .saveDataToSharedPreferences()
                                        .then((value) {
                                      sp.setSignIn().then((value) {
                                        nextScreenReplace(
                                            context, const HomeScreen());
                                      });
                                    });
                                  });
                                } else {
                                  // user does not exist
                                  sp.saveDataToFireStore().then((value) {
                                    sp
                                        .saveDataToSharedPreferences()
                                        .then((value) {
                                      sp.setSignIn().then((value) {
                                        nextScreenReplace(
                                            context, const HomeScreen());
                                      });
                                    });
                                  });
                                }
                              });
                            },
                            child: const Text("Confirm"),
                          ),
                        ],
                      ),
                    );
                  });
            },
            codeAutoRetrievalTimeout: (String verification) {});
      }
    }
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mu_card/dashboard.dart';
import 'package:mu_card/login/welcomename.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../apiConnection/apiConnection.dart';

class WelcomeMobile extends StatefulWidget {
  const WelcomeMobile({super.key});

  @override
  State<WelcomeMobile> createState() => _WelcomeMobileState();
}

class _WelcomeMobileState extends State<WelcomeMobile> {
  TextEditingController welcomeMobileController =
      TextEditingController(text: '');

  //visibility
  bool otpVisibility = false;
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  bool numberValidate = false;
  bool setNumberValidate = false;

  //phonenumber and otp
  String setedPhoneNumber = '';
  String otpEntered = '';

  //Timer Of OTP
  Timer? countdownTimer;
  Duration otpDuration = const Duration(minutes: 1);

  int pressedTimer = 0;

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    if (mounted) {
      setState(() {
        final seconds = otpDuration.inSeconds - reduceSecondsBy;
        if (seconds < 0) {
          countdownTimer!.cancel();
        } else {
          otpDuration = Duration(seconds: seconds);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //set timer
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(otpDuration.inMinutes.remainder(60));
    final seconds = strDigits(otpDuration.inSeconds.remainder(60));

    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        // stops: [0.5, 0.5],
        colors: [
          Colors.grey,
          Colors.white,
        ],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          backgroundColor: const Color.fromARGB(255, 133, 132, 132),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 9, 255, 0)),
                          value: setNumberValidate == false ? 0.3 : 0.5,
                          minHeight: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 70, 0, 0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        'Hi ${WelcomeName.welcomeName.toUpperCase()} !!',
                        style: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'Mooli',
                            color: Color.fromARGB(255, 38, 36, 36),
                            fontWeight: FontWeight.bold),
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      'Please Provide and verify your phone number',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Mooli',
                          color: Color.fromARGB(255, 121, 121, 121),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 55, 0, 0),
                    child: Text(
                      'Phone Number',
                      style: TextStyle(
                          fontSize: 17,
                          letterSpacing: 1,
                          fontFamily: 'Mooli',
                          color: Color.fromARGB(255, 38, 36, 36),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: InternationalPhoneNumberInput(
                  isEnabled: !setNumberValidate,
                  onInputChanged: (PhoneNumber number) {
                    // ignore: avoid_print
                    print(number.phoneNumber);
                    setState(() {
                      setedPhoneNumber = number.phoneNumber.toString();
                    });
                  },
                  onInputValidated: (bool value) {
                    // print(value);
                    if (value == true) {
                      setState(() {
                        numberValidate = true;
                      });
                    } else {
                      setState(() {
                        numberValidate = false;
                      });
                    }
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.DIALOG,
                  ),
                  // ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle:
                      const TextStyle(color: Colors.black, fontSize: 18),
                  textAlign: TextAlign.start,
                  textStyle: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Mooli',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                  formatInput: true,
                  maxLength: 12,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  // inputBorder: OutlineInputBorder(),
                  inputDecoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
                    filled: true,
                    fillColor: setNumberValidate == true
                        ? const Color.fromARGB(255, 225, 225, 225)
                        : Colors.white,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onSaved: (PhoneNumber number) {
                    // ignore: avoid_print
                    print('On Saved: $number');
                  },
                ),
                //   ],
                // ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Visibility(
                  visible: setNumberValidate,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            // ignore: prefer_interpolation_to_compose_strings
                            'Verify ' + setedPhoneNumber,
                            style: const TextStyle(
                                fontSize: 24,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 59, 59, 59)),
                          ),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Please enter the OTP sent to you for verification.',
                            style: TextStyle(
                                fontSize: 12.5,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 59, 59, 59)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Visibility(
                  visible: setNumberValidate,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OtpTextField(
                            numberOfFields: 6,
                            borderColor: const Color.fromARGB(255, 63, 63, 63),
                            enabledBorderColor: Colors.black,
                            textStyle: const TextStyle(
                                fontFamily: 'Mooli',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 81, 17, 92)),
                            //set to true to show as box or false to show as dash
                            showFieldAsBox: true,
                            //runs when a code is typed in
                            onCodeChanged: (String code) {
                              //handle validation or checks here
                            },
                            //runs when every textfield is filled
                            onSubmit: (String verificationCode) {
                              setState(() {
                                otpEntered = verificationCode;
                              });
                            }, // end onSubmit
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$minutes : $seconds',
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'Mooli',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        setNumberValidate = numberValidate;
                      });
                      if (setNumberValidate == true) {
                        if (pressedTimer == 0) {
                          startTimer();
                          pressedTimer++;
                        }
                        if (seconds == '00') {
                          // ignore: avoid_print
                          print("Time is over");
                        }
                        if (seconds != '00') {
                          // ignore: avoid_print
                          print(setedPhoneNumber);
                          checkIfMobileNumberExists(setedPhoneNumber);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Phone Number is not valid!',
                              style: TextStyle(
                                  fontFamily: 'Mooli',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      // ignore: deprecated_member_use
                      primary: const Color.fromARGB(255, 24, 0, 0), // background
                    ),
                    child: Text(
                      setNumberValidate == false ? 'Get OTP' : 'Verify',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 238, 255, 0),
                          fontSize: 21,
                          fontFamily: 'Mooli',
                          letterSpacing: 1.4),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !setNumberValidate,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 25),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          '<< Back To Login',
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 1,
                              fontFamily: 'Mooli',
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkIfMobileNumberExists(String mobileNumber) async {
    const apiUrl = API.checkMobileNumberExists;
    var response = await http.post(Uri.parse(apiUrl), body: {
      'phoneNum': mobileNumber,
    });

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      // ignore: avoid_print
      print(response.body);
      if (responseBody["exists"]) {
        int id = int.parse(responseBody['userId']);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLogin', true);
        await prefs.setInt('userId', id);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Login successfullly')));
        Get.off(() => Dashboard(userId: id));
      } else {
        Get.off(() => WelcomeName(phoneNum: mobileNumber));
      }
    }
  }
}

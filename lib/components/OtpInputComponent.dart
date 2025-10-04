import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPInput extends StatefulWidget {
  final Function(String) onCompleted;

  const OTPInput({Key? key, required this.onCompleted}) : super(key: key);

  @override
  _OTPInputState createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  // Function to get the full OTP value
  String getOTP() {
    return _controller1.text +
        _controller2.text +
        _controller3.text +
        _controller4.text;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 50,
          child: TextFormField(
            controller: index == 0
                ? _controller1
                : index == 1
                    ? _controller2
                    : index == 2
                        ? _controller3
                        : _controller4,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (value) {
              if (value.isEmpty) {
                // If input is empty and user pressed backspace, move focus to previous field
                if (index > 0) {
                  FocusScope.of(context).previousFocus();
                }
              } else if (value.length == 1) {
                // Only open (focus) next input after entering a digit
                if (index < 3) {
                  FocusScope.of(context).nextFocus();
                }
              }
              // Call onCompleted only when all fields are filled
              if (_controller1.text.length == 1 &&
                  _controller2.text.length == 1 &&
                  _controller3.text.length == 1 &&
                  _controller4.text.length == 1) {
                widget.onCompleted(getOTP());
              }
            },
          ),
        );
      }),
    );
  }
}

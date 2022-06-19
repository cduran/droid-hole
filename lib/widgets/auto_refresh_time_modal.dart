import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:droid_hole/widgets/option_box.dart';

class AutoRefreshTimeModal extends StatefulWidget {
  final int? time;
  final void Function(int) onChange;

  const AutoRefreshTimeModal({
    Key? key,
    required this.time,
    required this.onChange,
  }) : super(key: key);

  @override
  State<AutoRefreshTimeModal> createState() => _AutoRefreshTimeModalState();
}

class _AutoRefreshTimeModalState extends State<AutoRefreshTimeModal> {
  int? selectedOption;
  TextEditingController customTimeController = TextEditingController();
  bool showCustomDurationInput = false;
  bool customTimeIsValid = false;

  void _updateRadioValue(value) {
    setState(() {
      selectedOption = value;
      if (selectedOption != 5) {
        customTimeController.text = "";
        showCustomDurationInput = false;
      }
      else {
        Timer(const Duration(milliseconds: 250), () {
          setState(() {
            showCustomDurationInput = true;
          });
        });
      }
    });
  }

  void _validateCustomTime(value) {
    if (int.tryParse(value) != null) {
      setState(() {
        customTimeIsValid = true;
      });
    }
    else {
      setState(() {
        customTimeIsValid = false;
      });
    }
  }

  bool _selectionIsValid() {
    if (selectedOption != null && selectedOption != 5) {
      return true;
    }
    else if (selectedOption == 5 && customTimeIsValid == true) {
      return true;
    }
    else {
      return false;
    }
  }

  int _getTime() {
    switch (selectedOption) {
      case 0:
        return 1;

      case 1:
        return 2;

      case 2:
        return 5;

      case 3:
        return 10;

      case 4:
        return 30;

      case 5:
        return int.parse(customTimeController.text);

      default:
        return 0;
    }
  }

  int _setTime(int time) {
    switch (time) {
      case 1:
        return 0;

      case 2:
        return 1;

      case 5:
        return 2;

      case 10:
        return 3;

      case 30:
        return 4;

      default:
        setState(() {
          customTimeController.text = time.toString();
          _validateCustomTime(time.toString());
          showCustomDurationInput = true;
        });
        return 5;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.time != null) {
      selectedOption = _setTime(widget.time!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);   

    return Padding(
      padding: mediaQueryData.viewInsets,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: Platform.isIOS ? 20 : 0
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          height: selectedOption == 5 ? 418 : 315,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Text(
                "Auto refresh time",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: (mediaQueryData.size.width-70)/2,
                            margin: const EdgeInsets.only(
                              top: 10,
                              right: 5,
                              bottom: 5
                            ),
                            child: OptionBox(
                              optionsValue: selectedOption,
                              itemValue: 0,
                              onTap: _updateRadioValue,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 250),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: selectedOption == 0
                                      ? Theme.of(context).primaryColor
                                      : Colors.black87
                                  ),
                                  child: const Text("1 second"),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: (mediaQueryData.size.width-70)/2,
                            margin: const EdgeInsets.only(
                              top: 10,
                              left: 5,
                              bottom: 5
                            ),
                            child: OptionBox(
                              optionsValue: selectedOption,
                              itemValue: 1,
                              onTap: _updateRadioValue,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 250),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: selectedOption == 1
                                      ? Theme.of(context).primaryColor
                                      : Colors.black87
                                  ),
                                  child: const Text("2 seconds"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: (mediaQueryData.size.width-70)/2,
                            margin: const EdgeInsets.only(
                              top: 5,
                              right: 5,
                              bottom: 5
                            ),
                            child: OptionBox(
                              optionsValue: selectedOption,
                              itemValue: 2,
                              onTap: _updateRadioValue,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 250),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: selectedOption == 2
                                      ? Theme.of(context).primaryColor
                                      : Colors.black87
                                  ),
                                  child: const Text("5 seconds"),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: (mediaQueryData.size.width-70)/2,
                            margin: const EdgeInsets.only(
                              top: 5,
                              left: 5,
                              bottom: 5
                            ),
                            child: OptionBox(
                              optionsValue: selectedOption,
                              itemValue: 3,
                              onTap: _updateRadioValue,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 250),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: selectedOption == 3
                                      ? Theme.of(context).primaryColor
                                      : Colors.black87
                                  ),
                                  child: const Text("10 seconds"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: (mediaQueryData.size.width-70)/2,
                            margin: const EdgeInsets.only(
                              top: 5,
                              right: 5,
                              bottom: 10
                            ),
                            child: OptionBox(
                              optionsValue: selectedOption,
                              itemValue: 4,
                              onTap: _updateRadioValue,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 250),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: selectedOption == 4
                                      ? Theme.of(context).primaryColor
                                      : Colors.black87
                                  ),
                                  child: const Text("30 seconds"),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: (mediaQueryData.size.width-70)/2,
                            margin: const EdgeInsets.only(
                              top: 5,
                              left: 5,
                              bottom: 10
                            ),
                            child: OptionBox(
                              optionsValue: selectedOption,
                              itemValue: 5,
                              onTap: _updateRadioValue,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 250),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: selectedOption == 5
                                      ? Theme.of(context).primaryColor
                                      : Colors.black87
                                  ),
                                  child: const Text("Custom"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (showCustomDurationInput == true) 
                        Column(
                          children: [
                            const SizedBox(height: 25),
                            TextField(
                              onChanged: _validateCustomTime,
                              controller: customTimeController,
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: false
                              ),
                              decoration: InputDecoration(
                                errorText: !customTimeIsValid && customTimeController.text != ''
                                  ? "Value not valid" 
                                  : null,
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10)
                                  )
                                ),
                                labelText: 'Custom seconds',
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context), 
                          child: Row(
                            children: const [
                              Icon(Icons.cancel),
                              SizedBox(width: 10),
                              Text("Cancel")
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: _selectionIsValid() == true 
                            ? () {
                              Navigator.pop(context);
                              widget.onChange(_getTime());
                            }
                            : null,
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                              Colors.green.withOpacity(0.1)
                            ),
                            foregroundColor: MaterialStateProperty.all(
                              _selectionIsValid() == true 
                                ? Colors.green
                                : Colors.grey,
                            ),
                          ), 
                          child: Row(
                            children: const [
                              Icon(Icons.check),
                              SizedBox(width: 10),
                              Text("Confirm")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
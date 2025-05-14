import 'package:flutter/material.dart';
import 'package:mkrempire/app/controllers/app_controller.dart';
import 'package:get/get.dart';

class CustomTransactionPin extends StatefulWidget {
  @override
  _CustomTransactionPinState createState() => _CustomTransactionPinState();
}

class _CustomTransactionPinState extends State<CustomTransactionPin> {
  String pin = "";

  void _addDigit(String digit) {
    if (pin.length < 4) {
      setState(() {
        pin += digit;
      });
      if (pin.length == 4) {
        Get.back();
      }
    }
  }

  void _removeDigit() {
    if (pin.isNotEmpty) {
      setState(() {
        pin = pin.substring(0, pin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      maxChildSize: 1,
      minChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Enter Transaction PIN",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color:
                          index < pin.length ? Colors.black : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  String label;
                  if (index < 9) {
                    label = "${index + 1}";
                  } else if (index == 9) {
                    label = "";
                  } else if (index == 10) {
                    label = "0";
                  } else {
                    label = "⌫";
                  }
                  return GestureDetector(
                    onTap: () {
                      if (label == "⌫") {
                        _removeDigit();
                      } else if (label.isNotEmpty) {
                        _addDigit(label);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(label,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

void showTransactionPinSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: CustomTransactionPin(),
    ),
  );
}

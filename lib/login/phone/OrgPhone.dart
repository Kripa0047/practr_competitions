import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:practrCompetitions/Lang/English.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/login/otpVerify.dart';
import 'package:practrCompetitions/login/phone/OrgOtp.dart';
import 'package:practrCompetitions/utils/styles.dart';

final TextEditingController organiserPhoneController = TextEditingController();

class OrganiserPhone extends StatefulWidget {
  @override
  _OrganisationPhoneState createState() => _OrganisationPhoneState();
}

phoneValidAndSubmit(BuildContext context) async {
  bool _success = await verifyPhone(context);
  if (_success) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => OrganiserOTP(),
      ),
    );
  }
}

class _OrganisationPhoneState extends State<OrganiserPhone> {
  @override
  Widget build(BuildContext context) {
    return SingleFieldFormPhone(
      title: enterPhoneNumber,
      hintText: "9000111222",
      labelText: "mobile number",
      controller: organiserPhoneController,
      keyBoardType: TextInputType.phone,
      // prefixText: '+91 ',
      pushNamedAndRemoveUntil: true,
    );
  }
}

class SingleFieldFormPhone extends StatefulWidget {
  final String title;
  final String hintText;
  final String btnText;
  final String labelText;
  final TextInputType keyBoardType;
  final bool pushNamedAndRemoveUntil;
  final TextEditingController controller;
  final String prefixText;
  Function onPressed;

  SingleFieldFormPhone({
    this.btnText = "SUBMIT",
    this.hintText,
    this.title,
    this.labelText,
    this.pushNamedAndRemoveUntil = false,
    this.keyBoardType = TextInputType.text,
    this.controller,
    this.prefixText = '',
    this.onPressed,
  });

  @override
  _SingleFieldFormState createState() => _SingleFieldFormState();
}

class _SingleFieldFormState extends State<SingleFieldFormPhone> {
  bool show = false;
  checkConfirm() {
    print("show value $show");
    if (widget.controller.text.length >= 5) {
      setState(() {
        show = true;
      });
    } else {
      setState(() {
        show = false;
      });
    }
  }

  bool _isLoading = false;

  Future<void> checkFunction() async {
    setState(() {
      _isLoading = true;
    });
    // if()
  }

  @override
  void initState() {
    super.initState();
    print("show $show");
    show = false;
  }

  refresh() {
    checkConfirm();
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//              Container(
//                height: _height / 20,
//              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.title,
                style: kPrimaryTextStyle.copyWith(fontSize: 35, height: 1.2),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: AppTextField2(
                      keyboardType: widget.keyBoardType,
                      labelText: widget.labelText,
                      hintText: widget.hintText,
                      controller: widget.controller,
                      notify: refresh,
                      confirm: true,
                      prefixText: widget.prefixText,
                    ),
                  ),
                ],
              ),
              Spacer(),
              _isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              widget.btnText,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed:
                              !show ? null : () => phoneValidAndSubmit(context),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppTextField2 extends StatelessWidget {
  final int maxlines;
  final String hintText;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final TextCapitalization textCapitalization;
  Function notify;
  bool confirm = false;
  final String prefixText;

  AppTextField2({
    this.maxlines = 1,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    this.textCapitalization = TextCapitalization.sentences,
    this.notify,
    this.confirm,
    this.prefixText,
  });
  checkConfirm() {
    if (confirm ?? false)
      controller.addListener(() {
        notify();
        // print("controller value3: ${controller.text}");
      });
  }

  @override
  Widget build(BuildContext context) {
    checkConfirm();
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Form(
        child: TextField(
          textCapitalization: textCapitalization,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: TextStyle(fontSize: 20),

          // maxLength: 10,

          autofocus: true,
          autocorrect: false,
          maxLengthEnforced: true,

          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefix: Container(
//              width: 150,
              child: CountryPickerWidget(),

//              color: Colors.red,
//              child:
//              CountryPickerDropdown(
//                initialValue: 'IN',
//                itemBuilder: _buildDropdownItem,
//                onValuePicked: (Country country) {
//                  print("${country.name}");
//                  countryCode = '+' + country.phoneCode;
//                },
//              ),
            ),
            hintText: hintText,
            contentPadding: EdgeInsets.all(20),
            labelText: labelText,
          ),
        ),
      ),
    );
  }
}

class CountryPickerWidget extends StatefulWidget {
  @override
  _CountryPickerWidgetState createState() => _CountryPickerWidgetState();
}

class _CountryPickerWidgetState extends State<CountryPickerWidget> {
  Country _selected = Country(
    asset: "assets/flags/in_flag.png",
    dialingCode: "91",
    isoCode: "IN",
    name: "India",
    currency: "Indian rupee",
    currencyISO: "INR",
  );

  @override
  Widget build(BuildContext context) {
    return CountryPicker(
      dense: false,
      showFlag: true, //displays flag, true by default
      showDialingCode: true, //displays dialing code, false by default
      showName: false, //displays country name, true by default
      showCurrency: false, //eg. 'British pound'
      showCurrencyISO: false, //eg. 'GBP'
      onChanged: (Country country) {
        setState(() {
          _selected = country;

          countryCode = '+' + country.dialingCode;

          print('country code is: $countryCode');
          print('country code is: ${country.dialingCode}');
          print('country code is: ${country.currencyISO}');
          print('country code is: ${country.asset}');
          print('country code is: ${country.currency}');
        });
      },
      selectedCountry: _selected,
    );
  }
}

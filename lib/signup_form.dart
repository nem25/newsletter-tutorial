import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUpForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpFormState();
  }
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? name;
  String sentResponse = "Sign up failed. Please try again.";
  bool showResponse = false;
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text.';
                }
                return null;
              },
              onSaved: (name) => this.name = name,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(), labelText: 'Name'),
            ),
            SizedBox(height: 12),
            TextFormField(
              // The validator receives the text that the user has entered.
              validator: (val) => !EmailValidator.validate(val!, true)
                  ? 'Please enter a valid email.'
                  : null,
              onSaved: (email) => this.email = email,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(), labelText: 'Email'),
            ),
            SizedBox(height: 12),
            Visibility(visible: showResponse, child: Text(sentResponse)),
            Visibility(
                visible: showLoading,
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                )),
            SizedBox(height: 18),
            ElevatedButton(
              onPressed: submit,
              child: Text('Sign Up'),
            )
          ],
        ),
      ),
    );
  }

  Future submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        showLoading = true;
        showResponse = false;
      });

      try {
        //Send request
        //Call firebase function
        HttpsCallable callable =
            FirebaseFunctions.instance.httpsCallable('signUp');
        final results = await callable();
        sentResponse = results.data;
        // sentResponse = "Success!";
        _formKey.currentState!.reset();
      } catch (err) {
        print(err.toString());
      }
      setState(() {
        showLoading = false;
        showResponse = true;
      });
    }
  }
}

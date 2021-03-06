import 'dart:io';

import 'package:chat_app/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submit, this.isLoading);

  final isLoading;
  final void Function(String email, String password, String username,
      File image, bool isLogin) submit;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  Map<String, String> userDetails = {
    'email': '',
    'username': '',
    'password': '',
  };
  File _userImageFile;

  void _pickImage(File image) {
    _userImageFile = image;
  }

  void _submitForm() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image.'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (!isValid) return;
    _formKey.currentState.save();
    widget.submit(userDetails['email'].trim(), userDetails['password'].trim(),
        userDetails['username'].trim(), _userImageFile, _isLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickImage),
                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email address'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@'))
                        return 'Please enter a valid email address';
                      return null;
                    },
                    onSaved: (value) {
                      userDetails['email'] = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4)
                          return 'Please enter at least four characters';
                        return null;
                      },
                      onSaved: (value) {
                        userDetails['username'] = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value.length < 7)
                        return 'Please enter a longer password';
                      return null;
                    },
                    onSaved: (value) {
                      userDetails['password'] = value;
                    },
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

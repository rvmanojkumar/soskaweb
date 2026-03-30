import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../core/constants/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitted = false;
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.forgotPassword(_emailController.text.trim());
      
      if (success) {
        setState(() {
          _isSubmitted = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Failed to send reset email'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: _isSubmitted
              ? _buildSuccessScreen()
              : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 50),
                      
                      Icon(
                        Icons.lock_reset,
                        size: 80,
                        color: AppColors.primary,
                      ),
                      
                      SizedBox(height: 24),
                      
                      Text(
                        'Reset Password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      Text(
                        'Enter your email address and we\'ll send you a link to reset your password.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      
                      SizedBox(height: 32),
                      
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Send Button
                      ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _resetPassword,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: AppColors.primary,
                        ),
                        child: authProvider.isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'SEND RESET LINK',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Back to Login
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Back to Login'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
  
  Widget _buildSuccessScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle,
          size: 80,
          color: Colors.green,
        ),
        
        SizedBox(height: 24),
        
        Text(
          'Check Your Email',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        SizedBox(height: 16),
        
        Text(
          'We have sent a password reset link to ${_emailController.text}',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        
        SizedBox(height: 32),
        
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14),
            backgroundColor: AppColors.primary,
          ),
          child: Text(
            'BACK TO LOGIN',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../widgets/fade_transition_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController nssfController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  final Color mustard = Color(0xFFFFDB58);
  final Color mustardDark = Color(0xFFD4A017);
  final Color black = Colors.black;
  final Color grey = Colors.grey;
  final Color white = Colors.white;

  // Test credentials
  final String testUsername = 'User1';
  final String testPassword = 'pass123';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeInAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();

    // Pre-fill the text fields with test credentials
    nssfController.text = testUsername;
    passwordController.text = testPassword;
  }

  @override
  void dispose() {
    nssfController.dispose();
    passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final String username = nssfController.text;
    final String password = passwordController.text;
    _login(username, password);
  }

  void _login(String username, String password) {
    if (username == testUsername && password == testPassword) {
      print('Login successful');
      
      BlocProvider.of<AuthBloc>(context).add(
        LoginSubmitted(
          nssfNumber: testUsername,
          password: testPassword,
        ),
      );
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        title: Text(
          'Pension Pal Login',
          style: TextStyle(color: mustard, fontWeight: FontWeight.bold),
        ),
        backgroundColor: black,
        elevation: 2,
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.pushReplacementNamed(context, '/dashboard');
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        // App Logo
                        Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 200, 
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 50),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                          margin: EdgeInsets.only(bottom: 30),
                          child: Text(
                            'Welcome Back',
                            style: TextStyle(
                              color: white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextField(
                          controller: nssfController,
                          style: TextStyle(color: white),
                          decoration: InputDecoration(
                            labelText: 'NSSF Number',
                            labelStyle: TextStyle(color: white),
                            prefixIcon: Icon(Icons.account_circle, color: mustardDark),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: mustard),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),
                        
                        TextField(
                          controller: passwordController,
                          style: TextStyle(color: white),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: white),
                            prefixIcon: Icon(Icons.lock, color: mustardDark),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: mustard),
                            ),
                          ),
                          obscureText: true,
                        ),

                        SizedBox(height: 30),

                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(mustard),
                              );
                            }
                            return SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _onLoginPressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: mustard,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  elevation: 5,
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        FadeTransitionWidget(
                          child: TextButton(
                            onPressed: () {
                              // Handle forgot password
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: mustardDark, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

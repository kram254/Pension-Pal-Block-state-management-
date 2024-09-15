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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeInAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  @override
  void dispose() {
    nssfController.dispose();
    passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }


  void _onLoginPressed() {
  // For testing purposes, you can use these credentials to bypass the login screen
  final String testUsername = 'User1';
  final String testPassword = 'pass123';

  // Assuming you have a method to handle login logic
  _login(testUsername, testPassword);
}

void _login(String username, String password) {
  // Implement your login logic here
  // For example, you can call an API to authenticate the user
  if (username == 'User1' && password == 'pass123') {
    // Navigate to the next screen or show a success message
    print('Login successful');
  } else {
    // Show an error message
    print('Invalid credentials');
  }
}

  // void _onLoginPressed() {
  //   BlocProvider.of<AuthBloc>(context).add(
  //     LoginSubmitted(
  //       nssfNumber: nssfController.text,
  //       password: passwordController.text,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        title: Text(
          'Pension Pal Login',
          style: TextStyle(color: mustard, fontWeight: FontWeight.bold),
        ),
        backgroundColor: black,
        elevation: 0,
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
                        SizedBox(height: 80),
                        // App Logo
                        Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 200, 
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 20),


                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                          margin: EdgeInsets.only(bottom: 30),
                          child: Text(
                            'Welcome Back',
                            style: TextStyle(
                              color: black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextField(
                          controller: nssfController,
                          decoration: InputDecoration(
                            labelText: 'NSSF Number',
                            prefixIcon: Icon(Icons.account_circle, color: mustardDark),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock, color: mustardDark),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
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
                        Spacer(),
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








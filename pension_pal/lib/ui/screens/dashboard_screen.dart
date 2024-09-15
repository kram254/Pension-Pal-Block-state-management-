import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/pension_bloc.dart';
import '../widgets/pension_card.dart';

// Define theme colors
const Color mustard = Color(0xFFFFDB58);
const Color mustardDark = Color(0xFFD4A017);

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Trigger loading of pension data
    BlocProvider.of<PensionBloc>(context).add(LoadPensionData());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pension Dashboard',
          style: TextStyle(color: mustard, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: BlocBuilder<PensionBloc, PensionState>(
        builder: (context, state) {
          if (state is PensionLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(mustard),
              ),
            );
          } else if (state is PensionLoaded) {
            if (state.pensions.isEmpty) {
              return Center(
                child: Text(
                  'No pensions available.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: state.pensions.length,
                itemBuilder: (context, index) {
                  final pension = state.pensions[index];
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: FadeTransitionWidget(
                      child: PensionCard(pension: pension),
                    ),
                  );
                },
              ),
            );
          } else if (state is PensionError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class FadeTransitionWidget extends StatefulWidget {
  final Widget child;

  const FadeTransitionWidget({required this.child});

  @override
  _FadeTransitionWidgetState createState() => _FadeTransitionWidgetState();
}

class _FadeTransitionWidgetState extends State<FadeTransitionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
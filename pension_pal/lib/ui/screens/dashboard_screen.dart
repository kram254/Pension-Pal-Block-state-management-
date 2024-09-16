import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/pension_bloc.dart';
import '../../data/repositories/pension_repository.dart';
import '../../utils/routes.dart';
import '../widgets/pension_card.dart';

// Define theme colors
const Color mustard = Color(0xFFFFDB58);
const Color mustardDark = Color(0xFFD4A017);
const Color black = Colors.black;
const Color yellow = Colors.yellow;
const Color grey = Colors.grey;

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PensionBloc(context.read<PensionRepository>())..add(LoadPensionData()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Pension Dashboard',
            style: TextStyle(color: mustard, fontWeight: FontWeight.bold),
          ),
          backgroundColor: black,
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: black,
        body: BlocBuilder<PensionBloc, PensionState>(
          builder: (context, state) {
            if (state is PensionLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(mustard),
                ),
              );
            } else if (state is PensionLoaded) {
              if (state.pensions.isEmpty) {
                return const Center(
                  child: Text(
                    'No pensions available.',
                    style: TextStyle(
                      color: grey,
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
                      duration: const Duration(milliseconds: 500),
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
                  style: const TextStyle(
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: yellow,
          onPressed: () {
            Navigator.pushNamed(context, Routes.addPension).then((result) {
              if (result == true) {
                // Refresh the pension list after adding a new pension
                context.read<PensionBloc>().add(LoadPensionData());
              }
            });
          },
          child: const Icon(Icons.add, color: black),
        ),
      ),
    );
  }
}

class FadeTransitionWidget extends StatefulWidget {
  final Widget child;

  const FadeTransitionWidget({Key? key, required this.child}) : super(key: key);

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
      duration: const Duration(milliseconds: 800),
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
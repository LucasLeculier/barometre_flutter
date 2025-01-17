import 'package:flutter/material.dart';
import '../../controllers/barometer_controller.dart';
import '../widgets/barometer_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/background_container.dart';

class BarometerScreen extends StatefulWidget {
  const BarometerScreen({super.key, required this.title});
  final String title;

  @override
  State<BarometerScreen> createState() => _BarometerScreenState();
}

class _BarometerScreenState extends State<BarometerScreen> with SingleTickerProviderStateMixin {
  final BarometerController _controller = BarometerController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _setupController();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _setupController() {
    _controller.addListener(_handleControllerUpdate);
    _controller.getCurrentPressure();
  }

  void _handleControllerUpdate() {
    setState(() {
      if (!_controller.isLoading && _controller.error.isEmpty) {
        _animationController.forward(from: 0);
      }
      
      if (_controller.error.isNotEmpty && mounted) {
        _showErrorSnackBar();
      }
    });
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_controller.error),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Réessayer',
          textColor: Theme.of(context).colorScheme.onError,
          onPressed: _controller.getCurrentPressure,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerUpdate);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BackgroundContainer(
        child: _buildContent(),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
      elevation: 2,
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 80.0),
          child: Center(
            child: _buildMainContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    if (_controller.isLoading) {
      return const CircularProgressIndicator();
    }
    if (_controller.error.isNotEmpty) {
      return ErrorDisplayWidget(error: _controller.error);
    }
    return BarometerWidget(
      weatherData: _controller.weatherData,
      animation: _animation,
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _controller.getCurrentPressure,
      icon: const Icon(Icons.refresh),
      label: const Text('Actualiser'),
    );
  }
} 
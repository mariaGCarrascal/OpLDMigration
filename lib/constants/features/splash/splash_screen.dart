import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextPage;
  final Duration? minDuration;
  final Duration fadeDuration;
  final Future<void> Function()? onInit;

  const SplashScreen({
    super.key,
    required this.nextPage,
    this.minDuration,
    this.fadeDuration = const Duration(milliseconds: 1000), 
    this.onInit,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isInitComplete = false;
  bool _startFadeOut = false;
  bool _removeSplash = false;

  @override
  void initState() {
    super.initState();
    _startApp();
  }

  Future<void> _startApp() async {
    await Future.wait([
      Future.delayed(widget.minDuration!),
      if (widget.onInit != null) widget.onInit!(),
    ]);

    if (!mounted) return;

    setState(() {
      _isInitComplete = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      setState(() {
        _startFadeOut = true;
      });

      await Future.delayed(widget.fadeDuration);
      if (!mounted) return;
      setState(() {
        _removeSplash = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_removeSplash) {
      return widget.nextPage;
    }

    return Stack(
      children: [
        _isInitComplete ? widget.nextPage : const SizedBox.expand(),

        IgnorePointer(
          key: const ValueKey('splash_overlay'),
          ignoring: _startFadeOut,
          child: AnimatedOpacity(
            opacity: _startFadeOut ? 0.0 : 1.0,
            duration: widget.fadeDuration,
            curve: Curves.easeOut,
            child: _buildSplashContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildSplashContent() {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 11, 11),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: const Text(
                      'OpLD',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 230,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Courier New',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: 'MADE IN ',
                        style: TextStyle(
                          color: Color.fromARGB(255, 151, 148, 148),
                        ),
                      ),
                      TextSpan(
                        text: 'PA',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 255),
                        ),
                      ),
                      TextSpan(
                        text: 'NA',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      TextSpan(
                        text: 'MA',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
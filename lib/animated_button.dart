import 'package:animated_button/custom_painter.dart';
import 'package:flutter/material.dart';

enum SaveStatus { idle, loading, success }

class AnimatedSaveButton extends StatefulWidget {
  const AnimatedSaveButton({super.key});

  @override
  State<AnimatedSaveButton> createState() => _AnimatedSaveButtonState();
}

class _AnimatedSaveButtonState extends State<AnimatedSaveButton>
    with SingleTickerProviderStateMixin {
  SaveStatus _status = SaveStatus.idle;
  late AnimationController _controller;
  late Animation<double> _widhtAnimation;
  late Animation<double> _bumpAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<Color?> _textColorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
    );

    // widht animation
    _widhtAnimation = Tween<double>(begin: 80.0, end: 120.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOutBack),
      ),
    );

    _bumpAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _colorAnimation = ColorTween(
      begin: Colors.grey.shade300,
      end: Colors.black,
    ).animate(_controller);

    _textColorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.white,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> handlePress() async {
    if (_status != SaveStatus.idle) return;

    setState(() {
      _status = SaveStatus.loading;
    });
    await _controller.forward();
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _status = SaveStatus.success;
    });

    await Future.delayed(Duration(seconds: 1));

    _controller.reverse();
    setState(() {
      _status = SaveStatus.idle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Animated Button"), centerTitle: true),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return GestureDetector(
              onTap: handlePress,
              child: SizedBox(
                width: _widhtAnimation.value + 15,
                height: 70,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: AnimatedButtonPainter(
                          color: _colorAnimation.value!,
                          bumpFactor: _bumpAnimation.value,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 22,
                      left: 0,
                      right: 14,
                      child: SizedBox(
                        height: 46,
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(0, 0.2),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              _status == SaveStatus.idle
                                  ? "Save"
                                  : (_status == SaveStatus.loading
                                        ? "Saving"
                                        : "Saved"),
                              style: TextStyle(
                                color: _textColorAnimation.value,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      right: 17,
                      child: ScaleTransition(
                        scale: _bumpAnimation,
                        child: Opacity(
                          opacity: _status == SaveStatus.idle
                              ? 0
                              : 1, // hide bump when idle
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: Center(
                              child: _status == SaveStatus.loading
                                  ? const SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

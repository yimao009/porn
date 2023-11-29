import 'package:flutter/material.dart';

void main() => runApp(const SignUpApp());

class SignUpApp extends StatelessWidget {
  const SignUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const SignUpScreen(),
        '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 600,
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome!',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  double _formProgress = 0;

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress),
          Text(
            'Sign up',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _firstNameTextController,
              decoration: const InputDecoration(hintText: 'First Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(hintText: 'Last Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter User Name';
                }
                return null;
              },
              controller: _usernameTextController,
              decoration: const InputDecoration(hintText: 'User Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _emailTextController,
              decoration: const InputDecoration(hintText: 'email'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _passwordTextController,
              decoration: const InputDecoration(hintText: 'password'),
            ),
          ),
          TextButton(
            style:
                ButtonStyle(foregroundColor: MaterialStateProperty.resolveWith(
              (states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.white;
              },
            ), backgroundColor: MaterialStateProperty.resolveWith(
              (states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.blue;
              },
            )),
            // onPressed: _formProgress == 1 ? showWelcomeScreen : null,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Processing Data'),
                  ),
                );
              }
            },
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }

  void showWelcomeScreen() {
    Navigator.of(context).pushNamed('/welcome');
  }

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _firstNameTextController,
      _lastNameTextController,
      _usernameTextController,
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }
}

class AnimatedProgressIndicator extends StatefulWidget {
  final double value;
  const AnimatedProgressIndicator({
    super.key,
    required this.value,
  });

  @override
  State<AnimatedProgressIndicator> createState() =>
      _AnimatedProgressIndicatorState();
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));

    final colorTween = TweenSequence([
      TweenSequenceItem(
          tween: ColorTween(begin: Colors.red, end: Colors.orange), weight: 1),
      TweenSequenceItem(
          tween: ColorTween(begin: Colors.purple, end: Colors.yellow),
          weight: 1),
      TweenSequenceItem(
          tween: ColorTween(begin: Colors.yellow, end: Colors.green),
          weight: 1),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(covariant AnimatedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value?.withOpacity(0.4),
      ),
    );
  }
}

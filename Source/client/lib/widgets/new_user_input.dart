import 'package:flutter/material.dart';

import '../singletons/grpc_client.dart';
import '../singletons/logger.dart';
import '../proto/tracker.pbgrpc.dart';

class NewUserInput extends StatefulWidget {
  const NewUserInput({super.key});

  @override
  State<NewUserInput> createState() => _NewUserInputState();
}

class _NewUserInputState extends State<NewUserInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Logger logger = Logger();

  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text;
      setState(() {
        _isValid = text.length >= 5 && !text.contains(' ');
      });
    });

    // Add listener to re-sync the controller when the text field regains focus
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.text = _controller.text; // Re-sync the controller
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _validate(String value) {
    setState(() {
      _isValid = value.length >= 5 && !value.contains(' ');
    });
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await GrpcClient().createUser(_controller.text.trim());
        if (response.status == TrackerStatus.OK) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User created: ${response.user.name}')),
          );

          _controller.clear();
          setState(() => _isValid = false);

          logger.info('User created: ${response.user.name}');
          logger.debug('Response -> $response');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create user')),
          );

          logger.warning('Failed to create user -> $response');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create user')),
        );

        logger.error('Error creating user -> $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 200.0,
        minHeight: 175.0,
        maxWidth: 900.0,
        maxHeight: 200.0,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth * 0.3;
          final height = constraints.maxHeight * 0.2;

          return SizedBox(
            width: width,
            height: height,
            child: Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: TextStyle(
                          color: _isValid ? Colors.black : Colors.red,
                          fontStyle: _isValid ? FontStyle.normal : FontStyle.italic,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Enter New username',
                          hintText: 'Must be at least 5 characters and contain no spaces',
                        ),
                        onChanged: _validate,
                        validator: (value) {
                          if (value == null || value.length < 5 || value.contains(' ')) {
                            return 'Username must be at least 5 characters and contain no spaces.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _isValid ? _handleSubmit : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isValid ? Colors.purple : Colors.grey, // Purple when enabled, grey when disabled
                          foregroundColor: Colors.white, // White text color
                        ),
                        child: const Text('Create User'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
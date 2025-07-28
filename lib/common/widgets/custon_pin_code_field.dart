import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ---------------------------------------------------------------------------
///  REUSABLE OTP / PIN INPUT WIDGET
/// ---------------------------------------------------------------------------
class PinCodeFields extends StatefulWidget {
  const PinCodeFields({
    super.key,
    this.length = 6,
    this.boxSize = 40,
    this.boxSpacing = 8,
    this.textStyle,
    this.boxDecoration,
    this.onCompleted,
  });

  /// How many digits?
  final int length;

  /// Square box width / height
  final double boxSize;

  /// Gap between boxes
  final double boxSpacing;

  /// Text style for each digit
  final TextStyle? textStyle;

  /// Decoration for the digit container
  final BoxDecoration? boxDecoration;

  /// Called when user fills all boxes
  final ValueChanged<String>? onCompleted;

  @override
  State<PinCodeFields> createState() => _PinCodeFieldsState();
}

class _PinCodeFieldsState extends State<PinCodeFields> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      // move to next field
      if (index + 1 < widget.length) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    // If user pressed backspace on empty field, move back
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    final code = _controllers.map((c) => c.text).join();
    if (code.length == widget.length && !code.contains('')) {
      widget.onCompleted?.call(code);
    }
    setState(() {}); // redraw to reflect current state
  }

  BoxDecoration get _defaultBoxDecoration => BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFFFFFFF),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          width: widget.boxSize,
          height: widget.boxSize,
          margin: EdgeInsets.symmetric(horizontal: widget.boxSpacing / 2),
          decoration: widget.boxDecoration ?? _defaultBoxDecoration,
          alignment: Alignment.center,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            autofocus: index == 0,
            textAlign: TextAlign.center,
            maxLength: 1,
            keyboardType: TextInputType.number,
            style: widget.textStyle ??
                const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            onChanged: (val) => _onChanged(val, index),
          ),
        );
      }),
    );
  }
}

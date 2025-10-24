import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Reusable OTP / PIN input widget
/// - supports pasting a full code into any box (it will distribute the digits)
/// - moves focus forward/back automatically
/// - calls `onCompleted` when all boxes are filled
class PinCodeFields extends StatefulWidget {
  const PinCodeFields({
    super.key,
    this.length = 6,
    this.boxSize = 40,
    this.boxSpacing = 8,
    this.textStyle,
    this.boxDecoration,
    this.onCompleted,
    this.autoFocus = true,
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

  /// Whether to autofocus the first field
  final bool autoFocus;

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

    // Optional: listen for paste events on the first field (not required,
    // we handle paste in each field in _handlePaste).
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  /// Called whenever a field changes. Handles:
  ///  - single char input: move focus forward
  ///  - deletion to empty: move focus backward
  ///  - paste (value.length > 1): distribute characters across boxes starting at index
  void _onChanged(String value, int index) {
    // If user pasted multiple characters into one field, distribute them
    if (value.length > 1) {
      _handlePaste(value, index);
      return;
    }

    // Normal single-character input:
    if (value.isNotEmpty) {
      // move to next field if available
      if (index + 1 < widget.length) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // last box filled -> remove focus
        _focusNodes[index].unfocus();
      }
    } else {
      // if cleared and not first box, move back
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    _notifyIfComplete();
    setState(() {});
  }

  /// Distribute pasted text (only digits) starting at `startIndex`.
  /// Example: boxes = 4, startIndex = 1, pasted "9876" -> fill indexes 1,2,3 with 9,8,7 (stop at end)
  void _handlePaste(String pasted, int startIndex) {
    final digits = pasted.replaceAll(RegExp(r'[^0-9]'), '').split('');
    if (digits.isEmpty) return;

    int writeIndex = startIndex;
    for (final d in digits) {
      if (writeIndex >= widget.length) break;
      _controllers[writeIndex].text = d;
      writeIndex++;
    }

    // move focus to the next empty box or unfocus when done
    if (writeIndex < widget.length) {
      _focusNodes[writeIndex].requestFocus();
    } else {
      FocusScope.of(context).unfocus();
    }

    _notifyIfComplete();
    setState(() {});
  }

  /// Join controller texts and call onCompleted if all boxes are filled.
  void _notifyIfComplete() {
    final code = _controllers.map((c) => c.text.trim()).join();
    final allFilled = _controllers.every((c) => c.text.trim().isNotEmpty);

    if (allFilled && code.length == widget.length) {
      // unfocus to close keyboard
      FocusScope.of(context).unfocus();

      // call callback
      widget.onCompleted?.call(code);
    }
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
            autofocus: widget.autoFocus && index == 0,
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
            onSubmitted: (_) {
              // If user taps done on keyboard, try notify if complete
              _notifyIfComplete();
            },
          ),
        );
      }),
    );
  }
}

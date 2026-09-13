// import 'package:flutter/material.dart';

// class SignupPasswordField extends StatefulWidget {
//   final IconData icon;
//   final String hintText;
//   final String label;
//   final bool isOptional;
//   final FormFieldValidator<String>? validator;
//   final ValueChanged<String>? onChanged;
//   final TextEditingController? controller;
//   final String? initialValue;
//   final bool enabled;

//   const SignupPasswordField({
//     super.key,
//     required this.icon,
//     required this.hintText,
//     required this.label,
//     this.isOptional = false,
//     this.validator,
//     this.onChanged,
//     this.controller,
//     this.initialValue,
//     this.enabled = true,
//   });

//   @override
//   State<SignupPasswordField> createState() => _SignupPasswordFieldState();
// }

// class _SignupPasswordFieldState extends State<SignupPasswordField> {
//   bool _obscureText = true;

//   void _toggleVisibility() {
//     setState(() => _obscureText = !_obscureText);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.isOptional ? "${widget.label} (Optional)" : widget.label,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF0F2D62),
//             fontFamily: "Inter",
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: const Color(0xffD1D5DB)),
//             borderRadius: BorderRadius.circular(10),
//             color: widget.enabled
//                 ? const Color(0xffFFFFFF)
//                 : const Color(0xffF3F4F6),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//           child: Row(
//             children: [
//               Icon(widget.icon, color: const Color(0xff6B7280), size: 20),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: TextFormField(
//                   controller: widget.controller,
//                   initialValue:
//                       widget.controller == null ? widget.initialValue : null,
//                   onChanged: widget.onChanged,
//                   validator: widget.validator,
//                   obscureText: _obscureText,
//                   enabled: widget.enabled,
//                   keyboardType: TextInputType.visiblePassword,
//                   decoration: InputDecoration(
//                     hintText: widget.hintText,
//                     hintStyle: const TextStyle(
//                       color: Color(0xFFADAEBC),
//                       fontSize: 16,
//                       fontFamily: "Inter",
//                     ),
//                     border: InputBorder.none,
//                     isDense: true,
//                     contentPadding: const EdgeInsets.symmetric(vertical: 14),
//                     suffixIcon: GestureDetector(
//                       onTap: _toggleVisibility,
//                       child: Padding(
//                         padding: const EdgeInsets.only(right: 4),
//                         child: Icon(
//                           _obscureText
//                               ? Icons.visibility_off_outlined
//                               : Icons.visibility_outlined,
//                           color: const Color(0xff6B7280),
//                           size: 22,
//                         ),
//                       ),
//                     ),
//                   ),
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Color(0xFF111827),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 20),
//       ],
//     );
//   }
// }



import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignupPasswordField extends StatefulWidget {
  final IconData icon;
  final String hintText;
  final String label;
  final bool isOptional;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String? initialValue;
  final bool enabled;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const SignupPasswordField({
    super.key,
    required this.icon,
    required this.hintText,
    required this.label,
    this.isOptional = false,
    this.validator,
    this.onChanged,
    this.controller,
    this.initialValue,
    this.enabled = true,
    this.focusNode,
    this.textInputAction,
  }) : assert(
         controller == null || initialValue == null,
         'Provide either a controller or an initialValue, not both. '
         'When a controller is supplied, seed it with the starting text '
         'yourself (e.g. TextEditingController(text: value)).',
       );

  @override
  State<SignupPasswordField> createState() => _SignupPasswordFieldState();
}

class _SignupPasswordFieldState extends State<SignupPasswordField> {
  bool _obscureText = true;

  // We always drive the TextFormField off a controller we own the
  // lifecycle of. This avoids relying on TextFormField's implicit
  // internal controller, whose `initialValue` is only ever read on the
  // very first build — meaning any later rebuild with fresh data (e.g.
  // arriving from an API call) was previously just ignored, making the
  // field look "stuck" or out of sync with the rest of the form.
  late TextEditingController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = TextEditingController(text: widget.initialValue);
      _ownsController = true;
    }
  }

  @override
  void didUpdateWidget(covariant SignupPasswordField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Parent swapped which controller (or none) we should be using —
    // tear down the one we own (if any) and re-attach.
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) {
        _controller.dispose();
      }
      _initController();
      return;
    }

    // We're on our own internal controller and the caller handed us a
    // new `initialValue` (e.g. profile data finished loading after the
    // first frame). Push it into the field instead of silently dropping
    // it, but only if the user hasn't already typed something different
    // in the meantime.
    if (_ownsController &&
        widget.initialValue != oldWidget.initialValue &&
        _controller.text == (oldWidget.initialValue ?? '')) {
      final newText = widget.initialValue ?? '';
      _controller.value = _controller.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
        composing: TextRange.empty,
      );
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isOptional ? "${widget.label} (Optional)" : widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0F2D62),
            fontFamily: "Inter",
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffD1D5DB)),
            borderRadius: BorderRadius.circular(10),
            color: widget.enabled
                ? const Color(0xffFFFFFF)
                : const Color(0xffF3F4F6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              Icon(widget.icon, color: const Color(0xff6B7280), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  focusNode: widget.focusNode,
                  onChanged: widget.onChanged,
                  validator: widget.validator,
                  obscureText: _obscureText,
                  enabled: widget.enabled,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: widget.textInputAction,
                  autocorrect: false,
                  enableSuggestions: false,
                  autofillHints: const [AutofillHints.password],
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      color: Color(0xFFADAEBC),
                      fontSize: 16,
                      fontFamily: "Inter",
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    suffixIcon: IconButton(
                      // Bare GestureDetector + small Icon meant the tap
                      // target was only ~22px — below Material's 48dp
                      // minimum, so taps near (but not dead-center on)
                      // the icon simply missed. IconButton gives a real,
                      // reliable hit-test area.
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xff6B7280),
                        size: 22,
                      ),
                      splashRadius: 20,
                      tooltip: _obscureText
                          ? 'Show password'
                          : 'Hide password',
                      onPressed: widget.enabled ? _toggleVisibility : null,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
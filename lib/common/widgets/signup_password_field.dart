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
  });

  @override
  State<SignupPasswordField> createState() => _SignupPasswordFieldState();
}

class _SignupPasswordFieldState extends State<SignupPasswordField> {
  bool _obscureText = true;

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
                  controller: widget.controller,
                  initialValue:
                      widget.controller == null ? widget.initialValue : null,
                  onChanged: widget.onChanged,
                  validator: widget.validator,
                  obscureText: _obscureText,
                  enabled: widget.enabled,
                  keyboardType: TextInputType.visiblePassword,
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
                    suffixIcon: GestureDetector(
                      onTap: _toggleVisibility,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xff6B7280),
                          size: 22,
                        ),
                      ),
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

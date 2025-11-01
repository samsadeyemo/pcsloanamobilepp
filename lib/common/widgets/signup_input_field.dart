import 'package:flutter/material.dart';

class SignupInputField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final String label;
  final bool isOptional;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String? initialValue;
  final bool enabled;

  // ✅ New optional parameter
  final bool isPhoneNumber;

  const SignupInputField({
    super.key,
    required this.icon,
    required this.hintText,
    required this.label,
    this.isOptional = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.controller,
    this.initialValue,
    this.enabled = true,
    this.isPhoneNumber = false, // ✅ default: false (non-breaking)
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isOptional ? "$label (Optional)" : label,
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
            color: enabled ? const Color(0xffFFFFFF) : const Color(0xffF3F4F6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          height: 56,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Icon(icon, color: const Color(0xff6B7280), size: 20),
              const SizedBox(width: 8),

              // ✅ If it's a phone number, show +234 prefix
              if (isPhoneNumber) ...[
                const Text(
                  "+234",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF0F2D62),
                    fontWeight: FontWeight.w500,
                    fontFamily: "Inter",
                     height: 1.25, //
                  ),
                ),
                const SizedBox(width: 6),
              ],

              // ✅ Input field
              Expanded(
                child: TextFormField(
                  controller: controller,
                  initialValue: controller == null ? initialValue : null,
                  onChanged: onChanged,
                  validator: validator,
                  keyboardType: keyboardType,
                  enabled: enabled,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: Color(0xFFADAEBC),
                      fontSize: 16,
                      fontFamily: "Inter",
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(fontSize: 16,
                  height: 1.25,),
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

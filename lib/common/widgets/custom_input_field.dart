import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final String label;
  final bool isOptional;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const CustomInputField({
    super.key,
    required this.icon,
    required this.hintText,
    required this.label,
    this.isOptional = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.controller,
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
            border: Border.all(color: Color(0xffD1D5DB)),
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffFFFFFF),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xff6B7280), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  onChanged: onChanged,
                  validator: validator,
                  keyboardType: keyboardType,
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
                  style: const TextStyle(fontSize: 16),
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

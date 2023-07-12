import 'package:flutter/material.dart';
import 'package:flutter_study_2/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onchanged;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autofocus = false,
    required this.onchanged,
  });

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      ),
    ); //UnderlineInputBorder()
    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      // password
      obscureText: obscureText,
      autofocus: autofocus,
      onChanged: onchanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        hintStyle: const TextStyle(color: BODY_TEXT_COLOR, fontSize: 14.0),
        errorText: errorText,
        fillColor: INPUT_BG_COLOR,
        // true 배경색 있음.
        filled: true,
        // 모든 Input 상태의 기본 스타일 세팅.
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),
        ),
      ),
    );
  }
}

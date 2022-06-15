import 'package:flutter/material.dart';
import 'package:qmodi_tracking/colors.dart';



class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.hint,
      // this.label,
      this.pretext,
      this.sufText,
      this.maxLength,
      this.initialValue,
      this.icon,
      this.enabled,
      this.prefixIcon,
      this.suffixIcon,
      this.keyType,
      this.keyAction,
      this.textEditingController,
      this.onSubmited,
      this.validate,
      this.onChanged});

  final String? hint;
  // final String? label;
  final String? pretext;
  final String? sufText;
  final String? initialValue;
  final int? maxLength;
  final bool? enabled;
  final Widget? icon, prefixIcon, suffixIcon;
  final TextInputType? keyType;
  final TextEditingController? textEditingController;
  final TextInputAction? keyAction;
 String? Function(String?)? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onChanged: this.onChanged,
        maxLength: this.maxLength,
        controller: textEditingController,
        enabled: enabled,
        keyboardType: this.keyType,
        textInputAction: this.keyAction,
        initialValue: this.initialValue,
        validator:validate ,
        decoration: InputDecoration(
          isDense: true,
          prefixText: this.pretext,
          suffixText: this.sufText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              (12),
            ),
            borderSide: BorderSide(
              color: AppColors.accentcolor,
            
            ),
          ),
          // labelText: label,
          hintText: hint,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          // labelStyle: Theme.of(context).textTheme.headline4!.copyWith(
          //     color: AppColors.secondary,
          //     fontFamily: FontFamily.sofiaPro,
          //     fontSize: 14),
          hintStyle: Theme.of(context).textTheme.headline4!.copyWith(
                color: AppColors.accentcolor,
              
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
              ),
        ),
        // validator: validate,
        onFieldSubmitted: onSubmited);
  }
}

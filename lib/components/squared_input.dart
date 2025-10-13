import 'package:flutter/material.dart';

class SquaredInput extends StatelessWidget {

  final void Function(String) onChange;
  final String? label;
  final TextInputType? keyboardType;
  final IconData? icon;
  final String? value;

  const SquaredInput({super.key, required this.onChange, this.label, this.keyboardType, this.icon, this.value});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value),
      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible),
      decoration: InputDecoration(
        icon: icon != null ? Icon(icon) : null,
        label: label != null ? Text(label!) : Text(""),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.grey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2.0, 
          ),
        ),
      ),
      keyboardType: keyboardType ?? TextInputType.text,
      onChanged: (input) {onChange(input);},
      
    );
  }
}
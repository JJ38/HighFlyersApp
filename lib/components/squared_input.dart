import 'package:flutter/material.dart';


class SquaredInput extends StatefulWidget {

  final void Function(String) onChange;
  final String? label;
  final TextInputType? keyboardType;
  final IconData? icon;
  final String? value;
  final int maxLength;

  const SquaredInput({super.key, required this.onChange, this.label, this.keyboardType, this.icon, this.value, this.maxLength = 10000});

  @override
  State<SquaredInput> createState() => _SquaredInputState();
}

class _SquaredInputState extends State<SquaredInput> {

  late TextEditingController textEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    textEditingController = TextEditingController(text: widget.value);

  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: widget.maxLength,
      controller: textEditingController,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible),
      decoration: InputDecoration(
        icon: widget.icon != null ? Icon(widget.icon) : null,
        label: widget.label != null ? Text(widget.label!) : Text(""),
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
        counterText: ''
      ),
      keyboardType: widget.keyboardType ?? TextInputType.text,
      onChanged: (input) {widget.onChange(input);},
    );
  }
}

import "package:flutter/material.dart";

typedef TextEditingControllerCallback = void Function(
    TextEditingController controller);

class FormItem<T> extends StatefulWidget {
  final String label;
  final ValueChanged<T>? onValueChanged;
  final Icon? icon;
  final String? initialValue;
  final bool readOnly;
  final Icon? suffixIcon;
  final TextEditingControllerCallback? onSuffixIconTap;

  const FormItem(
      {Key? key,
      required this.label,
      this.icon,
      this.initialValue,
      this.readOnly = false,
      this.onValueChanged,
      this.suffixIcon,
      this.onSuffixIconTap})
      : super(key: key);

  @override
  State<FormItem> createState() => _FormItemState();
}

class _FormItemState extends State<FormItem> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        readOnly: widget.readOnly,
        controller: _controller,
        decoration: InputDecoration(
            icon: widget.icon,
            label: Text(widget.label),
            suffixIcon: widget.suffixIcon != null
                ? IconButton(
                    onPressed: () {
                      if (widget.onSuffixIconTap != null) {
                        widget.onSuffixIconTap!(_controller);
                      }
                    },
                    icon: widget.suffixIcon!)
                : null),
        key: widget.key,
        onChanged: widget.onValueChanged,
      ),
    );
  }
}

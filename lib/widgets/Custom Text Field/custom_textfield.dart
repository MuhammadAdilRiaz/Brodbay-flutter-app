import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final EdgeInsetsGeometry contentPadding;

  const CustomTextField({
    Key? key,
    this.controller,
    this.label,
    this.hint,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.enabled = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 14), required TextInputAction textInputAction, required FloatingLabelBehavior floatingLabelBehavior,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController _internalController;
  bool _showClear = false;
  bool _obscured = false;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    _obscured = widget.obscureText;
    _showClear = _effectiveController.text.isNotEmpty;
    _effectiveController.addListener(_handleControllerChange);
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleControllerChange);
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  void _handleControllerChange() {
    final hasText = _effectiveController.text.isNotEmpty;
    if (hasText != _showClear) {
      setState(() => _showClear = hasText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: _effectiveController,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      enabled: widget.enabled,
      inputFormatters: widget.inputFormatters,
      obscureText: _obscured,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefix,
        // Build suffix: custom suffix passed in + clear or toggle
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.suffix != null) widget.suffix!,
            if (widget.obscureText)
              IconButton(
                icon: Icon(_obscured ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscured = !_obscured),
                splashRadius: 20,
                color: theme.iconTheme.color,
              ),
            if (_showClear)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _effectiveController.clear();
                  widget.onChanged?.call('');
                  // keep focus if you want:
                  // FocusScope.of(context).requestFocus(FocusNode());
                },
                splashRadius: 20,
                color: theme.iconTheme.color,
              ),
          ],
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: widget.contentPadding,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey.shade500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red.shade700),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
      ),
    );
  }
}

import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_base_project/core/theme/app_form_field.dart';

const int _defaultMinLinesOnMultiline = 16;

class CustomTextFormField extends FormField<String> {
  /// Creates a [FormField] that contains a [TextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the
  /// default). If [controller] is null, then a [TextEditingController]
  /// will be constructed automatically and its `text` will be initialized
  /// to [initialValue] or the empty string.
  ///
  /// For documentation about the various parameters, see the [TextField] class
  /// and [TextField], the constructor.
  CustomTextFormField({
    Key? key,
    required this.data,
    this.controller,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration? decoration,
    String? hintText,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    ToolbarOptions? toolbarOptions,
    bool? showCursor,
    String obscuringCharacter = '•',
    bool obscureText = false,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    MaxLengthEnforcement? maxLengthEnforcement,
    int? maxLines = 1,

    /// when multiline = true, minLines = 6
    int? minLines,
    bool expands = false,
    int? maxLength,
    bool multiline = false,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onFieldSubmitted,
    FormFieldSetter<String>? onSaved,
    GestureTapCallback? onTap,
    MouseCursor? mouseCursor,
    void Function(String, Map<String, dynamic>)? onAppPrivateCommand,
    AutovalidateMode? autovalidateMode,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    ui.BoxHeightStyle selectionHeightStyle = ui.BoxHeightStyle.tight,
    ui.BoxWidthStyle selectionWidthStyle = ui.BoxWidthStyle.tight,
    Brightness? keyboardAppearance,
    bool? enableInteractiveSelection,
    TextSelectionControls? selectionControls,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    Iterable<String>? autofillHints,
    ScrollController? scrollController,
    Clip clipBehavior = Clip.hardEdge,
    String? restorationId,
    bool enableIMEPersonalizedLearning = true,
  })  : assert(initialValue == null || controller == null),
        assert(obscuringCharacter.length == 1),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(
          !obscureText || maxLines == 1,
          'Obscured fields cannot be multiline.',
        ),
        assert(
          maxLength == null ||
              maxLength == TextField.noMaxLength ||
              maxLength > 0,
        ),
        super(
          key: key,
          restorationId: restorationId,
          initialValue:
              controller != null ? controller.text : (initialValue ?? ''),
          onSaved: onSaved,
          validator: validator,
          enabled: enabled ?? decoration?.enabled ?? true,
          autovalidateMode: autovalidateMode ??
              (validator != null ? AutovalidateMode.onUserInteraction : null),
          builder: (FormFieldState<String> field) {
            final _CustomTextFormFieldState state =
                field as _CustomTextFormFieldState;
            final InputDecoration effectiveDecoration = (decoration ??
                    (multiline
                        ? AppFormField.multilineShadowInputDecoration
                        : AppFormField.shadowInputDecoration))
                .copyWith(hintText: hintText);
            // .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            void onChangedHandler(String value) {
              field.didChange(value);

              if (onChanged != null) {
                onChanged(value);
              }
            }

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: TextField(
                restorationId: restorationId,
                controller: state._effectiveController,
                focusNode: focusNode,
                decoration:
                    effectiveDecoration.copyWith(errorText: field.errorText),
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                style: style,
                strutStyle: strutStyle,
                textAlign: textAlign,
                textAlignVertical: textAlignVertical,
                textDirection: textDirection,
                textCapitalization: textCapitalization,
                autofocus: autofocus,
                toolbarOptions: toolbarOptions,
                readOnly: readOnly,
                showCursor: showCursor,
                obscuringCharacter: obscuringCharacter,
                obscureText: obscureText,
                autocorrect: autocorrect,
                smartDashesType: smartDashesType ??
                    (obscureText
                        ? SmartDashesType.disabled
                        : SmartDashesType.enabled),
                smartQuotesType: smartQuotesType ??
                    (obscureText
                        ? SmartQuotesType.disabled
                        : SmartQuotesType.enabled),
                enableSuggestions: enableSuggestions,
                maxLengthEnforcement: maxLengthEnforcement,
                maxLines: multiline ? null : maxLines,
                minLines: minLines == null && multiline
                    ? _defaultMinLinesOnMultiline
                    : minLines,
                expands: expands,
                maxLength: maxLength,
                onChanged: onChangedHandler,
                onTap: onTap,
                onAppPrivateCommand: onAppPrivateCommand,
                onEditingComplete: onEditingComplete,
                onSubmitted: onFieldSubmitted,
                inputFormatters: inputFormatters,
                enabled: enabled ?? decoration?.enabled ?? true,
                cursorWidth: cursorWidth,
                cursorHeight: cursorHeight,
                cursorRadius: cursorRadius,
                cursorColor: cursorColor,
                selectionHeightStyle: selectionHeightStyle,
                selectionWidthStyle: selectionWidthStyle,
                scrollPadding: scrollPadding,
                scrollPhysics: scrollPhysics,
                scrollController: scrollController,
                dragStartBehavior: dragStartBehavior,
                keyboardAppearance: keyboardAppearance,
                enableInteractiveSelection:
                    enableInteractiveSelection ?? (!obscureText || !readOnly),
                selectionControls: selectionControls,
                mouseCursor: mouseCursor,
                buildCounter: buildCounter,
                autofillHints: autofillHints,
                clipBehavior: clipBehavior,
                enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
              ),
            );
          },
        );

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  final ValueNotifier<String> data;

  @override
  FormFieldState<String> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends FormFieldState<String> {
  RestorableTextEditingController? _controller;

  TextEditingController get _effectiveController =>
      _textFormField.controller ?? _controller!.value;

  CustomTextFormField get _textFormField => super.widget as CustomTextFormField;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(oldBucket, initialRestore);
    if (_controller != null) {
      _registerController();
    }
    // Make sure to update the internal [FormFieldState] value to sync up with
    // text editing controller value.
    setValue(_effectiveController.text);
  }

  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller!, 'controller');
  }

  @override
  void initState() {
    super.initState();
    if (_textFormField.controller == null) {
      final String initialValue =
          widget.initialValue ?? _textFormField.data.value;
      _createLocalController(
        TextEditingValue(text: initialValue),
      );
    } else {
      _textFormField.controller!.addListener(_handleControllerChanged);
    }
    // setValue(widget.initialValue ?? widget.data.value);
    _textFormField.data.addListener(_onData);
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);
    _controller = value == null
        ? RestorableTextEditingController()
        : RestorableTextEditingController.fromValue(value);
    if (!restorePending) {
      _registerController();
    }
  }

  void _onData() {
    if (_effectiveController.text != _textFormField.data.value) {
      _effectiveController.text = _textFormField.data.value;
    }
  }

  @override
  void didUpdateWidget(CustomTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_textFormField.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _textFormField.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && _textFormField.controller == null) {
        _createLocalController(oldWidget.controller!.value);
      }

      if (_textFormField.controller != null) {
        setValue(_textFormField.controller!.text);
        if (oldWidget.controller == null) {
          unregisterFromRestoration(_controller!);
          _controller!.dispose();
          _controller = null;
        }
      }
    }

    _handleControllerChanged();
  }

  @override
  void dispose() {
    _textFormField.data.removeListener(_onData);
    _textFormField.controller?.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    if (_effectiveController.text != value) {
      _effectiveController.text = value ?? '';
      _effectiveController.selection =
          TextSelection.collapsed(offset: value?.length ?? 0);
    }
    _textFormField.data.value = _effectiveController.text;
  }

  @override
  void reset() {
    // setState will be called in the superclass, so even though state is being
    // manipulated, no setState call is needed here.
    _effectiveController.text =
        widget.initialValue ?? _textFormField.data.value;
    super.reset();
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != value) {
      didChange(_effectiveController.text);
    }
  }
}

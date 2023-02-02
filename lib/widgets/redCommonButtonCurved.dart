import 'package:flutter/material.dart';

class CommonButtonCurved extends StatefulWidget {
  final String? text;
  final Function? fn;
  final Color? color;
  final Color? borderColor;
  final Color? textcolor;
  final bool? curving;
  final bool? isMapFn;
  const CommonButtonCurved(
      {Key? key,
      this.text,
      this.fn,
      this.color,
      this.borderColor,
      this.textcolor,
      this.curving,
      this.isMapFn})
      : super(key: key);

  @override
  _CommonButtonCurvedState createState() => _CommonButtonCurvedState();
}

class _CommonButtonCurvedState extends State<CommonButtonCurved>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.fn as void Function()?,
      child: Container(
        height: 52 ,
        margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: widget.borderColor!),
            borderRadius: widget.curving!
                ? const BorderRadius.all(Radius.circular(10.0))
                : const BorderRadius.all(Radius.circular(4.0)),
            color: widget.color,
          ),
          child: Text(
            widget.text!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: widget.textcolor,
            ),
          ),
        ),
      ),
    );
  }
}

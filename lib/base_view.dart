import 'package:flutter/material.dart';
import 'package:my_table/my_table.dart';

class BaseView extends StatefulWidget {
  const BaseView({
    super.key,
    required this.child,
    this.value,
    this.onSelected,
  });

  final Widget child;
  final MyTableType? value;
  final Function(MyTableType type)? onSelected;

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 300,
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: ListView(
            children: MyTableType.values.map((type) {
              return ListTile(
                leading: widget.value == type ? const Icon(Icons.check) : null,
                title: Text(type.name.toString()),
                onTap: () {
                  widget.onSelected?.call(type);
                },
              );
            }).toList(),
          ),
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}

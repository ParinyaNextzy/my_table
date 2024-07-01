import 'package:flutter/material.dart';
import 'package:my_table/content_storage.dart';
import 'package:intl/intl.dart';

enum MyTableType {
  flexFirstFixedOther,
  flexOtherWhenFirstColumnZero,
  scrollWhenAllColumnIsFixed,
}

class MyTable extends StatefulWidget {
  const MyTable({
    super.key,
    this.type = MyTableType.scrollWhenAllColumnIsFixed,
  });

  final MyTableType type;

  @override
  State<MyTable> createState() => _MyTableState();
}

class _MyTableState extends State<MyTable> {
  static const double buttonColumn = 48;
  static const double fixedColumn = 150;
  static const double gameColumn = 200;

  final storage = ContentStorage();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: storage,
      builder: (context, _) {
        return Theme(
          data: _customTheme(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return switch (widget.type) {
                MyTableType.flexFirstFixedOther => _buildFlexFirstFixedOther(constraints),
                MyTableType.flexOtherWhenFirstColumnZero => _buildFlexOtherWhenFirstColumnZero(constraints),
                MyTableType.scrollWhenAllColumnIsFixed => _buildScrollTable(constraints),
              };
            },
          ),
        );
      },
    );
  }

  //*=============================================*//

  Widget _buildFlexFirstFixedOther(BoxConstraints constraints) {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(buttonColumn),
        1: FlexColumnWidth(1),
        4: FixedColumnWidth(gameColumn),
        6: FixedColumnWidth(buttonColumn),
      },
      defaultColumnWidth: const FixedColumnWidth(fixedColumn),
      children: _getTableContent(),
    );
  }

  Widget _buildScrollTable(BoxConstraints constraints) {
    final shouldScroll = constraints.maxWidth < (buttonColumn + (fixedColumn * 4) + gameColumn + buttonColumn);
    final columnWidths = switch (shouldScroll) {
      false => const {
          0: FixedColumnWidth(buttonColumn),
          1: FlexColumnWidth(1),
          4: FixedColumnWidth(gameColumn),
          6: FixedColumnWidth(buttonColumn),
        },
      true => const {
          0: FixedColumnWidth(buttonColumn),
          4: FixedColumnWidth(gameColumn),
          6: FixedColumnWidth(buttonColumn),
        },
    };

    final table = Table(
      columnWidths: columnWidths,
      defaultColumnWidth: const FixedColumnWidth(fixedColumn),
      children: _getTableContent(),
    );

    if (shouldScroll) {
      return Scrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: table,
        ),
      );
    }
    return table;
  }

  Widget _buildFlexOtherWhenFirstColumnZero(BoxConstraints constraints) {
    final shouldFlex = constraints.maxWidth < (buttonColumn + (fixedColumn * 3) + gameColumn + buttonColumn);
    final columnWidths = switch (shouldFlex) {
      false => const {
          0: FixedColumnWidth(buttonColumn),
          1: FlexColumnWidth(1),
          4: FixedColumnWidth(gameColumn),
          6: FixedColumnWidth(buttonColumn),
        },
      true => const {
          0: FixedColumnWidth(buttonColumn),
          1: FixedColumnWidth(0),
          4: FlexColumnWidth(1.5),
          6: FixedColumnWidth(buttonColumn),
        },
    };

    final defaultColumnWidth = switch (shouldFlex) {
      true => const FlexColumnWidth(1),
      false => const FixedColumnWidth(fixedColumn),
    };

    final table = Table(
      columnWidths: columnWidths,
      defaultColumnWidth: defaultColumnWidth,
      children: _getTableContent(),
    );

    if (shouldFlex) {
      return table;
    }
    return table;
  }

  //*=============================================*//

  List<TableRow> _getTableContent() {
    return [
      _buildHeaderRow(),
      for (var data in storage.data) ...[
        _buildContentRow(data),
      ],
    ];
  }

  ThemeData _customTheme() {
    return Theme.of(context).copyWith(
      checkboxTheme: CheckboxThemeData(
        side: const BorderSide(
          width: 2,
          color: Colors.black38,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          iconColor: WidgetStatePropertyAll(Colors.black38),
        ),
      ),
    );
  }

  TableRow _buildHeaderRow() {
    Color backgroundColor = Colors.grey.shade100;
    return TableRow(
      children: [
        CustomTableCell(
          color: backgroundColor,
          child: Checkbox(
            value: storage.isSelectedAll,
            onChanged: (value) {
              storage.toggleSelectedAll();
            },
          ),
        ),
        CustomTableCell(
          color: backgroundColor,
          onTap: () {
            storage.toggelSort();
          },
          child: RichText(
            maxLines: 2,
            text: TextSpan(
              children: [
                const TextSpan(text: 'Campaign '),
                WidgetSpan(
                  child: Icon(
                    storage.isSortAsc ? Icons.arrow_downward : Icons.arrow_upward,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        CustomTableCell(
          color: backgroundColor,
          child: Text('Create at'),
        ),
        CustomTableCell(
          color: backgroundColor,
          child: Text('End at'),
        ),
        CustomTableCell(
          color: backgroundColor,
          child: Text('Game'),
        ),
        CustomTableCell(
          color: backgroundColor,
          child: Text('Publish'),
        ),
        CustomTableCell(
          color: backgroundColor,
          child: SizedBox.shrink(),
        ),
      ],
    );
  }

  TableRow _buildContentRow(FakeData data) {
    return TableRow(
      children: [
        CustomTableCell(
          child: Checkbox(
            value: storage.selectedData.contains(data),
            onChanged: (value) {
              storage.toggleSelected(data);
            },
          ),
        ),
        CustomTableCell(child: Text(data.campaignName, maxLines: 2, overflow: TextOverflow.ellipsis)),
        CustomTableCell(child: Text(DateFormat('dd MMM yyyy').format(data.createAt))),
        CustomTableCell(child: Text(DateFormat('dd MMM yyyy').format(data.endAt))),
        CustomTableCell(child: GameTile(name: data.gameName, type: data.gameType)),
        CustomTableCell(child: PublishBadge(isPublish: data.isPublish)),
        CustomTableCell(
          height: 64,
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ),
      ],
    );
  }
}

class CustomTableCell extends StatelessWidget {
  const CustomTableCell({
    super.key,
    this.padding,
    this.alignment,
    this.color,
    this.height = 48,
    this.onTap,
    required this.child,
  });

  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final Color? color;
  final double height;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Material(
        color: color ?? Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: height,
              child: Align(
                alignment: alignment ?? Alignment.centerLeft,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

///

class PublishBadge extends StatelessWidget {
  const PublishBadge({
    super.key,
    this.isPublish = false,
  });

  final bool isPublish;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isPublish ? Colors.cyan.shade200 : Colors.grey.shade200,
      ),
      child: Text(isPublish ? 'Published' : 'draft'),
    );
  }
}

class GameTile extends StatelessWidget {
  const GameTile({
    super.key,
    required this.name,
    required this.type,
  });

  final String name;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
          child: SizedBox.square(
            dimension: 32,
            child: Placeholder(),
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(
                type,
                style: TextStyle(color: Colors.grey.shade400),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

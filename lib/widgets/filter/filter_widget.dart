import 'package:flutter/material.dart';
import 'package:flutter_danain/utils/type_defs.dart';
import 'package:flutter_danain/widgets/text/text_widget.dart';

enum FilterType {
  kapsul,
  general,
}

class MultipleFilter extends StatefulWidget {
  final List<dynamic>? dataSelected;
  final List<dynamic> dataList;
  final String displayKey;
  final String idKey;
  final Function1<List<dynamic>, void> onSelect;
  final FilterType type;
  final Color contentColor;
  final Color titleColor;
  const MultipleFilter({
    super.key,
    required this.dataSelected,
    required this.idKey,
    required this.displayKey,
    required this.dataList,
    required this.onSelect,
    this.type = FilterType.general,
    required this.contentColor,
    required this.titleColor,
  });

  @override
  State<MultipleFilter> createState() => _MultipleFilterState();
}

class _MultipleFilterState extends State<MultipleFilter> {
  late List<dynamic> value;

  @override
  void initState() {
    super.initState();
    value = List<dynamic>.from(widget.dataSelected ?? []);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == FilterType.kapsul) {
      return Wrap(
        children: widget.dataList.map((e) {
          final isSelected = value.contains(e[widget.idKey]);
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                if (value.contains(e[widget.idKey])) {
                  value.remove(e[widget.idKey]);
                } else {
                  value.add(e[widget.idKey]);
                }
              });
              widget.onSelect(value);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.only(right: 8, bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isSelected ? widget.titleColor : const Color(0xffEEEEEE),
                ),
                color:
                    isSelected ? widget.contentColor : const Color(0xffEEEEEE),
              ),
              child: TextWidget(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                text: e[widget.displayKey].toString(),
                color: isSelected ? widget.titleColor : const Color(0xff777777),
              ),
            ),
          );
        }).toList(),
      );
    }
    return Column(
      children: widget.dataList.map((e) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              if (value.contains(e[widget.idKey])) {
                value.remove(e[widget.idKey]);
              } else {
                value.add(e[widget.idKey]);
              }
            });
            widget.onSelect(value);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffDDDDDD),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: e[widget.displayKey].toString(),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                checkWidget(value.contains(e[widget.idKey])),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget checkWidget(bool isCheck) {
    if (isCheck) {
      return Icon(
        Icons.check_box,
        color: widget.titleColor,
        size: 20,
      );
    }
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: const Color(0xffDDDDDD),
        ),
      ),
    );
  }
}

class SingleFilter extends StatelessWidget {
  final dynamic currentValue;
  final List<dynamic> dataList;
  final String displayKey;
  final String idKey;
  final Function1<dynamic, void> onSelect;
  final FilterType type;
  final Color primaryColor;
  const SingleFilter({
    super.key,
    required this.currentValue,
    required this.idKey,
    required this.displayKey,
    required this.dataList,
    required this.onSelect,
    this.type = FilterType.general,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    if (type == FilterType.kapsul) {
      return Wrap(
        children: dataList.map(
          (e) {
            final isSelected = e[idKey] == currentValue;
            return GestureDetector(
              onTap: () {
                onSelect(e[idKey]);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                margin: const EdgeInsets.only(right: 8, bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isSelected ? primaryColor : const Color(0xffEEEEEE),
                ),
                child: TextWidget(
                  text: e[displayKey].toString(),
                  color: isSelected ? Colors.white : const Color(0xff777777),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          },
        ).toList(),
      );
    }
    return Column(
      children: dataList.map((e) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            onSelect(e[idKey]);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xff777777),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: e[displayKey].toString(),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                checkWidget(e[idKey] == currentValue),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget checkWidget(bool isCheck) {
    return Icon(
      isCheck ? Icons.radio_button_checked : Icons.radio_button_off,
      color: isCheck ? primaryColor : const Color(0xffDDDDDD),
      size: 16,
    );
  }
}

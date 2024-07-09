import 'package:flutter/material.dart';
import 'package:flutter_danain/component/home/home_component.dart';
import 'package:flutter_danain/utils/type_defs.dart';
import 'package:flutter_danain/widgets/form/text_field_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class TextFormSelectSearch extends StatefulWidget {
  final Map<String, dynamic>? dataSelected;
  final List<dynamic> listData;
  final String placeHolder;
  final String? label;
  final String idDisplay;
  final String textDisplay;
  final String? modalTitle;
  final String searchPlaceholder;
  final Function1<dynamic, void> onSelect;
  const TextFormSelectSearch({
    super.key,
    this.dataSelected,
    required this.textDisplay,
    required this.placeHolder,
    this.label,
    required this.idDisplay,
    required this.listData,
    required this.searchPlaceholder,
    required this.onSelect,
    this.modalTitle,
  });

  @override
  State<TextFormSelectSearch> createState() => _TextFormSelectSearchState();
}

class _TextFormSelectSearchState extends State<TextFormSelectSearch> {
  @override
  Widget build(BuildContext context) {
    final Widget dataWidget = widget.dataSelected != null
        ? selectedText(widget.dataSelected![widget.textDisplay].toString())
        : placeHolderText(widget.placeHolder);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Column(
            children: [
              TextWidget(
                text: widget.label!,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: HexColor('#AAAAAA'),
              ),
              const SpacerV(value: 4),
            ],
          ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return DropdownSearch(
                  dataSelected: widget.dataSelected ?? {},
                  label: widget.modalTitle ?? widget.placeHolder,
                  keyId: widget.idDisplay,
                  displayKey: widget.textDisplay,
                  listData: widget.listData,
                  placeHolderSearch: widget.searchPlaceholder,
                  onSelected: widget.onSelect,
                );
              },
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: Color(0xFFDDDDDD),
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dataWidget,
                SvgPicture.asset(
                  'assets/images/icons/dropdown.svg',
                  width: 16,
                  height: 16,
                  fit: BoxFit.scaleDown,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget selectedText(String text) {
    return TextWidget(
      text: shortText(text, 35),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  Widget placeHolderText(String text) {
    return TextWidget(
      text: text,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: const Color(0xffBEBEBE),
    );
  }
}

class DropdownSearch extends StatefulWidget {
  final Map<String, dynamic> dataSelected;
  final String label;
  final String placeHolderSearch;
  final String keyId;
  final String displayKey;
  final List<dynamic> listData;
  final Function1<dynamic, void> onSelected;

  const DropdownSearch({
    super.key,
    required this.dataSelected,
    required this.label,
    required this.keyId,
    required this.displayKey,
    required this.listData,
    required this.placeHolderSearch,
    required this.onSelected,
  });

  @override
  State<DropdownSearch> createState() => _DropdownSearchState();
}

class _DropdownSearchState extends State<DropdownSearch> {
  List<dynamic> _filteredData = [];
  final controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      _filteredData = widget.listData;
    });
  }

  void filterData(String searchTerm) {
    setState(() {
      _filteredData = searchInList(widget.listData, searchTerm);
    });
  }

  List<dynamic> searchInList(
    List<dynamic> originalList,
    String searchTerm,
  ) {
    return originalList
        .where((map) => map[widget.displayKey]
            .toString()
            .toLowerCase()
            .replaceAll(' ', '')
            .contains(searchTerm.toLowerCase().replaceAll(' ', '')))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height / 1.5,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: HexColor('#EEEEEE'),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Headline3(text: widget.label),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: HexColor('#AAAAAA'),
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                width: MediaQuery.of(context).size.width,
                child: TextF(
                  isHintVisible: false,
                  onChanged: filterData,
                  controller: controller,
                  hintText: widget.placeHolderSearch,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _filteredData.map((e) {
                      final isSelect =
                          e[widget.keyId] == widget.dataSelected[widget.keyId];
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pop(context);
                          widget.onSelected(e);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                          ),
                          width: MediaQuery.of(context).size.width,
                          color: isSelect ? HexColor('#F1FCF4') : Colors.white,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: HexColor('#EEEEEE'),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: TextWidget(
                              text: e[widget.displayKey].toString(),
                              fontSize: 14,
                              fontWeight:
                                  isSelect ? FontWeight.w500 : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextFormSelect extends StatefulWidget {
  final Map<String, dynamic>? dataSelected;
  final Function1<Map<String, dynamic>, void> onSelect;
  final String placeHolder;
  final String label;
  final String idDisplay;
  final String textDisplay;
  final List<dynamic> listData;
  const TextFormSelect({
    super.key,
    this.dataSelected,
    required this.textDisplay,
    required this.placeHolder,
    required this.label,
    required this.onSelect,
    required this.idDisplay,
    required this.listData,
  });

  @override
  State<TextFormSelect> createState() => _TextFormSelectState();
}

class _TextFormSelectState extends State<TextFormSelect> {
  @override
  Widget build(BuildContext context) {
    final Widget dataWidget = widget.dataSelected != null
        ? selectedText(widget.dataSelected![widget.textDisplay].toString())
        : placeHolderText(widget.placeHolder);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: widget.label,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: HexColor('#AAAAAA'),
        ),
        const SpacerV(value: 4),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return TextSelectDropdown(
                  dataSelected: widget.dataSelected,
                  label: widget.placeHolder,
                  keyId: widget.idDisplay,
                  displayKey: widget.textDisplay,
                  listData: widget.listData,
                  action: (value) {
                    widget.onSelect(value);
                  },
                );
              },
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: Color(0xFFDDDDDD),
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dataWidget,
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: 16,
                  color: HexColor('#999999'),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget selectedText(String text) {
    return TextWidget(
      text: shortText(text, 35),
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: HexColor('#333333'),
    );
  }

  Widget placeHolderText(String text) {
    return TextWidget(
      text: text,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: const Color(0xffBEBEBE),
    );
  }
}

class TextSelectDropdown extends StatefulWidget {
  final Map<String, dynamic>? dataSelected;
  final String label;
  final String keyId;
  final String displayKey;
  final List<dynamic> listData;
  final Function1<Map<String, dynamic>, void> action;

  const TextSelectDropdown({
    super.key,
    this.dataSelected,
    required this.label,
    required this.keyId,
    required this.displayKey,
    required this.listData,
    required this.action,
  });

  @override
  State<TextSelectDropdown> createState() => _TextSelectDropdownState();
}

class _TextSelectDropdownState extends State<TextSelectDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: TextWidget(
                    text: widget.label,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    align: TextAlign.center,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: Color(0xffAAAAAA),
                  size: 16,
                ),
              ),
            ],
          ),
          listWidget(widget.listData),
        ],
      ),
    );
  }

  Widget listWidget(List<dynamic> list) {
    if (list.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(
          child: TextWidget(
            text: 'Tidak ada opsi',
            align: TextAlign.center,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }
    return SizedBox(
      height: 250,
      child: ListView.builder(
        itemCount: widget.listData.length,
        itemBuilder: (context, index) {
          final item = widget.listData[index];
          final isSelected = widget.dataSelected != null &&
              widget.dataSelected![widget.keyId] == item[widget.keyId];
          // ignore: use_colored_box
          return Container(
            color: isSelected ? HexColor('#F1FCF4') : Colors.white,
            child: ListTile(
              title: TextWidget(
                text: item[widget.displayKey].toString(),
                align: TextAlign.center,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
              onTap: () {
                widget.action(item as Map<String, dynamic>);
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}

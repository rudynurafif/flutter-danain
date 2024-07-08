import 'package:flutter/material.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class ModalBottomListItem extends StatelessWidget {
  final TextEditingController actualController;
  final TextEditingController displayController;
  final List<Map<String, dynamic>> dataVal;
  final String label;

  ModalBottomListItem(
    this.actualController,
    this.displayController,
    this.dataVal,
    this.label,
  );

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Headline3(
                    text: label,
                    align: TextAlign.center,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: HexColor('#AAAAAA'),
                  size: 16,
                ),
              )
            ],
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: dataVal.length,
              itemBuilder: (context, index) {
                final item = dataVal[index];
                return Container(
                  color: actualController.text == item['id'].toString()
                      ? HexColor('#F1FCF4')
                      : Colors.white,
                  child: ListTile(
                    title: actualController.text == item['id'].toString()
                        ? Subtitle500(
                            text: item['display'],
                            align: TextAlign.center,
                          )
                        : SubtitleExtra(
                            text: item['display'],
                            align: TextAlign.center,
                          ),
                    onTap: () {
                      actualController.text = item['id'].toString();
                      displayController.text = item['display'];
                      print(actualController.text);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ModalBottomListItemObject extends StatefulWidget {
  final Map<String, dynamic>? dataSelected;
  final List<dynamic> dataVal;
  final String label;
  final Function1<Map<String, dynamic>, void> actionSelect;

  @override
  const ModalBottomListItemObject({
    super.key,
    this.dataSelected,
    required this.dataVal,
    required this.label,
    required this.actionSelect,
  });

  @override
  State<ModalBottomListItemObject> createState() =>
      _ModalBottomListItemObjectState();
}

class _ModalBottomListItemObjectState extends State<ModalBottomListItemObject> {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Headline3(
                    text: widget.label,
                    align: TextAlign.center,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: HexColor('#AAAAAA'),
                  size: 16,
                ),
              )
            ],
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: widget.dataVal.length,
              itemBuilder: (context, index) {
                final item = widget.dataVal[index];
                return Container(
                  color: widget.dataSelected != null &&
                          widget.dataSelected!['id'] == item['id']
                      ? HexColor('#F1FCF4')
                      : Colors.white,
                  child: ListTile(
                    title: widget.dataSelected != null &&
                            widget.dataSelected!['id'] == item['id']
                        ? Subtitle500(
                            text: item['nama'],
                            align: TextAlign.center,
                          )
                        : SubtitleExtra(
                            text: item['nama'],
                            align: TextAlign.center,
                          ),
                    onTap: () {
                      widget.actionSelect(item);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ModalBottomListItemObjectCustom extends StatefulWidget {
  final Map<String, dynamic>? dataSelected;
  final List<dynamic> dataVal;
  final String label;
  final Function1<Map<String, dynamic>, void> actionSelect;
  final String idKey;

  @override
  const ModalBottomListItemObjectCustom({
    super.key,
    this.dataSelected,
    required this.dataVal,
    required this.label,
    required this.actionSelect,
    required this.idKey,
  });

  @override
  State<ModalBottomListItemObjectCustom> createState() =>
      _ModalBottomListItemObjectCustomState();
}

class _ModalBottomListItemObjectCustomState
    extends State<ModalBottomListItemObjectCustom> {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Headline3(
                    text: widget.label,
                    align: TextAlign.center,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: HexColor('#AAAAAA'),
                  size: 16,
                ),
              )
            ],
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: widget.dataVal.length,
              itemBuilder: (context, index) {
                final item = widget.dataVal[index];
                return Container(
                  color: widget.dataSelected != null &&
                          widget.dataSelected![widget.idKey] ==
                              item[widget.idKey]
                      ? HexColor('#F1FCF4')
                      : Colors.white,
                  child: ListTile(
                    title: widget.dataSelected != null &&
                            widget.dataSelected![widget.idKey] ==
                                item[widget.idKey]
                        ? Subtitle500(
                            text: item['keterangan'],
                            align: TextAlign.center,
                          )
                        : SubtitleExtra(
                            text: item['keterangan'],
                            align: TextAlign.center,
                          ),
                    onTap: () {
                      widget.actionSelect(item);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ModalBottomListItem2 extends StatelessWidget {
  final TextEditingController actualController;
  final TextEditingController displayController;
  final List<Map<String, dynamic>> dataVal;
  final String label;

  ModalBottomListItem2(
    this.actualController,
    this.displayController,
    this.dataVal,
    this.label,
  );

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Headline3(
                    text: label,
                    align: TextAlign.center,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: HexColor('#AAAAAA'),
                  size: 16,
                ),
              )
            ],
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: dataVal.length,
              itemBuilder: (context, index) {
                final item = dataVal[index];
                return Container(
                  color: actualController.text == item['id'].toString()
                      ? HexColor('#F1FCF4')
                      : Colors.white,
                  child: ListTile(
                    title: actualController.text == item['id'].toString()
                        ? Subtitle500(
                            text: item['nama'],
                            align: TextAlign.center,
                          )
                        : SubtitleExtra(
                            text: item['nama'],
                            align: TextAlign.center,
                          ),
                    onTap: () {
                      actualController.text = item['id'].toString();
                      displayController.text = item['nama'];
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ModalBottomListItemWithSearch extends StatefulWidget {
  final TextEditingController actualController;
  final TextEditingController displayController;
  final List<dynamic> dataVal;
  final String label;

  ModalBottomListItemWithSearch(
    this.actualController,
    this.displayController,
    this.dataVal,
    this.label,
  );

  @override
  _ModalBottomListItemWithSearchState createState() =>
      _ModalBottomListItemWithSearchState();
}

class _ModalBottomListItemWithSearchState
    extends State<ModalBottomListItemWithSearch> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _filteredData = widget.dataVal;
  }

  void _filterData(String searchTerm) {
    setState(() {
      _filteredData = searchInList(widget.dataVal, searchTerm);
    });
  }

  List<dynamic> searchInList(
    List<dynamic> originalList,
    String searchTerm,
  ) {
    return originalList.where((map) {
      String combinedValues =
          map.values.map((value) => value.toString().toLowerCase()).join(' ');
      return combinedValues.contains(searchTerm.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Headline3(
              text: widget.label == 'Cari Bank' ? 'Pilih Bank' : widget.label),
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: HexColor('#AAAAAA'),
                size: 16,
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: _searchController,
                  onChanged: _filterData,
                  decoration: inputDecorNoError(context, '${widget.label}')),
            ),
            Expanded(
              child: SizedBox(
                child: ListView.builder(
                  itemCount: _filteredData.length,
                  itemBuilder: (context, index) {
                    final item = _filteredData[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(width: 1, color: HexColor('#EEEEEE')),
                          top: BorderSide(width: 1, color: HexColor('#EEEEEE')),
                        ),
                        color: widget.actualController.text ==
                                item['id'].toString()
                            ? HexColor('#F1FCF4')
                            : Colors.white,
                      ),
                      child: ListTile(
                        title: widget.actualController.text ==
                                item['id'].toString()
                            ? Subtitle500(
                                text: item['nama'],
                              )
                            : SubtitleExtra(
                                text: item['nama'],
                              ),
                        onTap: () {
                          widget.actualController.text = item['id'].toString();
                          widget.displayController.text = item['nama'];
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

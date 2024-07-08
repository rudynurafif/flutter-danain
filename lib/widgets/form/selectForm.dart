import 'package:flutter/material.dart';
import 'package:flutter_danain/data/remote/response/simulasi_cicilan/list_produk.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class SelectForm extends StatelessWidget {
  final List<dynamic> data;
  final int? value;
  final String placeHolder;
  final void Function(int?)? changeResponse;

  const SelectForm({
    Key? key,
    required this.data,
    this.value,
    required this.placeHolder,
    required this.changeResponse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffDDDDDD),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff288C50),
                width: 1.0,
              ),
            ),
          ),
          hint: Text(
            placeHolder,
            style: const TextStyle(color: Color(0xffDDDDDD)),
          ),
          icon: SvgPicture.asset(
            'assets/images/icons/dropdown.svg',
            width: 16,
            height: 21,
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
          value: value,
          onChanged: changeResponse,
          items: data.map<DropdownMenuItem<int>>((valueItem) {
            return DropdownMenuItem<int>(
              value: valueItem['value'] as int?,
              child: Text(
                valueItem['name'] as String,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class SelectFormTenor extends StatelessWidget {
  final List<ListProductResponse> data;
  final ListProductResponse? value;
  final String placeHolder;
  final void Function(ListProductResponse?)? changeResponse;

  const SelectFormTenor({
    Key? key,
    required this.data,
    this.value,
    required this.placeHolder,
    required this.changeResponse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ListProductResponse>(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffDDDDDD), width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffDDDDDD), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff288C50), width: 1.0),
        ),
      ),
      alignment: Alignment.bottomCenter, // Set alignment to always appear at the bottom
      hint: Text(
        placeHolder,
        style: TextStyle(color: Color(0xffDDDDDD)),
      ),
      icon: SvgPicture.asset(
        'assets/images/icons/dropdown.svg',
        width: 16,
        height: 21,
      ),
      dropdownColor: Colors.white,
      isExpanded: true,
      isDense: true,
      value: value,

      onChanged: changeResponse,
      items: data.map<DropdownMenuItem<ListProductResponse>>((valueItem) {
        return DropdownMenuItem<ListProductResponse>(
          value: valueItem,
          child: Text(
            '${valueItem.tenor} Bulan',
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
    );
  }
}

class SelectFormContent extends StatefulWidget {
  final Map<String, dynamic>? dataSelected;
  final String placeHolder;
  final String label;
  const SelectFormContent({
    super.key,
    this.dataSelected,
    required this.placeHolder,
    required this.label,
  });

  @override
  State<SelectFormContent> createState() => _SelectFormContentState();
}

class _SelectFormContentState extends State<SelectFormContent> {
  @override
  Widget build(BuildContext context) {
    final Widget dataWidget = widget.dataSelected != null
        ? SubtitleExtra(text: widget.dataSelected!['nama'])
        : SubtitleExtra(
            text: widget.placeHolder,
            color: HexColor('#BEBEBE'),
          );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle3(
          text: widget.label,
          color: HexColor('#AAAAAA'),
        ),
        const SizedBox(height: 4),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0xFFDDDDDD)),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              dataWidget,
              SvgPicture.asset(
                'assets/images/icons/dropdown.svg',
                width: 16,
                height: 21,
                fit: BoxFit.scaleDown,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SelectFormContentCustom extends StatefulWidget {
  final Map<String, dynamic>? dataSelected;
  final String placeHolder;
  final String label;
  const SelectFormContentCustom({
    super.key,
    this.dataSelected,
    required this.placeHolder,
    required this.label,
  });

  @override
  State<SelectFormContentCustom> createState() => _SelectFormContentCustomState();
}

class _SelectFormContentCustomState extends State<SelectFormContentCustom> {
  @override
  Widget build(BuildContext context) {
    final Widget dataWidget = widget.dataSelected != null
        ? SubtitleExtra(text: widget.dataSelected!['keterangan'])
        : SubtitleExtra(
            text: widget.placeHolder,
            color: HexColor('#BEBEBE'),
          );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle3(
          text: widget.label,
          color: HexColor('#AAAAAA'),
        ),
        const SizedBox(height: 4),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0xFFDDDDDD)),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              dataWidget,
              SvgPicture.asset(
                'assets/images/icons/dropdown.svg',
                width: 16,
                height: 21,
                fit: BoxFit.scaleDown,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SelecFormMonth extends StatefulWidget {
  final String label;
  final String month;
  final String year;
  const SelecFormMonth({
    super.key,
    required this.month,
    required this.year,
    required this.label,
  });

  @override
  State<SelecFormMonth> createState() => _SelecFormMonthState();
}

class _SelecFormMonthState extends State<SelecFormMonth> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle3(
          text: widget.label,
          color: HexColor('#AAAAAA'),
        ),
        const SizedBox(height: 4),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFDDDDDD)),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SubtitleExtra(
                text: '${widget.month} ${widget.year}',
                color: HexColor('#333333'),
              ),
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: HexColor('#AAAAAA'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

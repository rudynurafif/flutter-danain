import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/pendanaan/pendanaan.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class StepPembuka extends StatefulWidget {
  final PendanaanBloc pBloc;
  const StepPembuka({super.key, required this.pBloc});

  @override
  State<StepPembuka> createState() => _StepPembukaState();
}

class _StepPembukaState extends State<StepPembuka> {
  int pendanaanValue = 0; // Initialize with the default value
  late StreamSubscription<int> _pendanaanStreamSubscription;
  StreamController<int> _pendanaanStreamController = StreamController<int>();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadPendanaanValue();
    _setupPendanaanStream();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _pendanaanStreamSubscription.cancel();
    _pendanaanStreamController.close();
    super.dispose();
  }

  Future<void> loadPendanaanValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pendanaanValue = prefs.getInt('pendanaan') ?? 0;
    });
  }

  void _setupPendanaanStream() {
    _pendanaanStreamSubscription =
        _pendanaanStreamController.stream.listen((newValue) {
      setState(() {
        pendanaanValue = newValue;
      });
    });

    Timer.periodic(Duration(seconds: 1), (_) {
      checkForPendanaanUpdate();
    });
  }

  Future<void> checkForPendanaanUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = prefs.getInt('pendanaan') ?? 0;
    if (newValue != pendanaanValue) {
      _pendanaanStreamController.add(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingDanain();
    } else {
      if (pendanaanValue == 1) {
        return StepListPendanaan(pBloc: widget.pBloc);
      }
      return PengenalanProduk(pBloc: widget.pBloc);
    }
  }
}

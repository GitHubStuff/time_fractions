import 'package:flutter/material.dart';
import 'package:flutter_extras/flutter_extras.dart';
import 'package:theme_manager/theme_manager.dart';
import 'package:time_fractions_package/time_fractions_package.dart';

class ScaffoldWidget extends StatefulWidget {
  ScaffoldWidget({Key? key}) : super(key: key);

  @override
  _ScaffoldWidget createState() => _ScaffoldWidget();
}

///----------------------------------------------------
class _ScaffoldWidget extends ObservingStatefulWidget<ScaffoldWidget> {
  final TextStyle _style = const TextStyle(fontSize: 28.0);
  late TextEditingController _amountController;
  late TextEditingController _factorController;
  List<String> _data = ['seconds', 'minutes', 'hours'];

  @override
  initState() {
    super.initState();
    _amountController = TextEditingController();
    _factorController = TextEditingController();
  }

  @override
  dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playback Time'),
        actions: [
          ThemeControlWidget(),
        ],
      ),
      body: _body(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _doTheMath(context);
        },
        tooltip: 'Calculate',
        child: Icon(Icons.equalizer),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 40.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: _style,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Time Amount',
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _factorController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: _style,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Time Factor',
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(_data[0], style: _style),
          Text(_data[1], style: _style),
          Text(_data[2], style: _style),
        ],
      ),
    );
  }

  void _doTheMath(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
    final String tokens = _amountController.text;
    if (_factorController.text.isEmpty) _factorController.text = '1.0';
    final double factor = double.parse(_factorController.text);
    VideoTimeParser videoTimeParser = VideoTimeParser.parse(tokens);
    setState(() {
      _data = videoTimeParser.byFactor(factor);
    });
  }
}

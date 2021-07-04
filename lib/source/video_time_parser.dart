import 'package:flutter_extras/flutter_extras.dart';
import 'package:intl/intl.dart';

class VideoTimeParser {
  String? _hours;
  String? _minutes;
  String? _seconds;

  DateTimeElement _currentState = DateTimeElement.second;
  String? _token;
  int? get hours => _hours == null ? null : int.parse(_hours!);

  int? get minutes => _minutes == null ? null : int.parse(_minutes!);
  int? get seconds => _seconds == null ? null : int.parse(_seconds!);

  List<String> byFactor(double factor) {
    final List<String> result = [];
    final Duration baseDuration = Duration(hours: (hours ?? 0), minutes: (minutes ?? 0), seconds: (seconds ?? 0));
    final adjusted = baseDuration.inSeconds.toDouble() / factor;
    final Duration duration = Duration(seconds: adjusted.toInt());
    final NumberFormat formatter = NumberFormat('###,###,#00');
    final justSeconds = '${formatter.format(duration.inSeconds)}';
    result.add(justSeconds);

    final justMinutes = '${formatter.format(duration.inMinutes)}:${formatter.format(duration.inSeconds - duration.inMinutes * 60)}';
    result.add(justMinutes);
    final last =
        '${formatter.format(duration.inHours)}:${formatter.format((duration.inMinutes - (duration.inHours * 60)))}:${formatter.format((duration.inSeconds - duration.inMinutes * 60))}';
    result.add(last);
    return result;
  }

  void _handleState() {
    switch (_currentState) {
      case DateTimeElement.microsecond:
      case DateTimeElement.millisecond:
      case DateTimeElement.day:
      case DateTimeElement.month:
      case DateTimeElement.year:
        assert(false, 'Cannot parse ${_currentState.toString()}');
        return;
      case DateTimeElement.second:
        _seconds = _token;
        _currentState = DateTimeElement.minute;
        break;
      case DateTimeElement.minute:
        _minutes = _token;
        _currentState = DateTimeElement.hour;
        break;
      case DateTimeElement.hour:
        _hours = _token;
        break;
    }
  }

  void _parse(String tokens) {
    if (tokens.isEmpty) {
      if (_token != null) _handleState();
      return;
    }
    final token = tokens.substring(0, 1);
    if (token.contains(RegExp(r'[0-9]'))) {
      _token = (_token ?? '') + token;
    } else {
      _handleState();
      _token = null;
    }
    _parse(tokens.substring(1));
  }

  static VideoTimeParser parse(String tokenString) {
    String tokens = '';
    for (int i = 0; i < tokenString.length; i++) {
      final item = tokenString.substring(i, i + 1);
      if (item.contains(RegExp(r'[0-9]'))) {
        tokens += tokenString.substring(i, i + 1);
      } else {
        tokens += '.';
      }
    }
    String elements = tokens.split('.').reversed.toList().join('.');
    return VideoTimeParser().._parse(elements);
  }
}

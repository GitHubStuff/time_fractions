//import 'package:tracers/tracers.dart';

import 'package:test/test.dart';
import 'package:time_fractions/source/video_time_parser.dart';

void main() {
  test('parse and factor', () {
    VideoTimeParser result = VideoTimeParser.parse('1*2*3');
    expect(result.seconds, 1);
    expect(result.minutes, 2);
    expect(result.hours, 3);
    List<String> times = result.byFactor(1.5);
    expect(times[0], '..:..:7280');
    expect(times[1], '..:121:20');
    expect(times[2], '02:01:20');
  });
}

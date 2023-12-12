import 'dart:io';
import 'dart:convert';

void main() {
  final File file = File('./input.txt');
  file.readAsLines().then((List<String> lines) {
    partOne(lines);
  });
  final sum = part2(file);
  print('Part Two: $sum');
}

void partOne(List<String> lines) {
  int sum = 0;
  for (final line in lines) {
    final parts = line.split(' ');
    final cfg = parts[0];
    final numsStr = parts[1].split(',');
    final nums = numsStr.map((numStr) => int.parse(numStr)).toList();
    sum += count(cfg, nums);
  }
  print('Part One: $sum');

}



int count(String cfg, List<int> nums) {
  if (cfg.isEmpty) {
    if (nums.isEmpty) {
      return 1;
    }
    return 0;
  }

  if (nums.isEmpty) {
    if (cfg.contains("#")) {
      return 0;
    }
    return 1;
  }

  var result = 0;

  if (cfg[0] == '.' || cfg[0] == '?') {
    result += count(cfg.substring(1), nums);
  }

  if (cfg[0] == '#' || cfg[0] == '?') {
    if (nums[0] <= cfg.length &&
        !cfg.substring(0, nums[0]).contains(".") &&
        (nums[0] == cfg.length || cfg[nums[0]] != '#')) {
      if (nums[0] == cfg.length) {
        result += count("", nums.sublist(1));
      } else {
        result += count(cfg.substring(nums[0] + 1), nums.sublist(1));
      }
    }
  }

  return result;
}


int part2(File file) {
  try {
    final input = file.readAsStringSync();
    final recordsAndGroups = parse(input);
    final records = recordsAndGroups[0];
    final groups = recordsAndGroups[1];
    int sum = 0;

    for (var i = 0; i < records.length; i++) {
      sum += solve(unfoldRecord(records[i]), unfoldGroup(groups[i]));
    }

    return sum;
  } catch (e) {
    return 0;
  }
}

String unfoldRecord(String record) {
  final res = StringBuffer();
  for (var i = 0; i < record.length * 5; i++) {
    if (i != 0 && i % record.length == 0) {
      res.write('?');
    }
    res.write(record[i % record.length]);
  }

  return res.toString();
}

List<int> unfoldGroup(List<int> group) {
  var res = <int>[];
  for (var i = 0; i < group.length * 5; i++) {
    res.add(group[i % group.length]);
  }

  return res;
}

int solve(String record, List<int> group) {
  var cache =
  List.generate(record.length, (i) => List.filled(group.length + 1, -1));

  return dp(0, 0, record, group, cache);
}

int dp(int i, int j, String record, List<int> group, List<List<int>> cache) {
  if (i >= record.length) {
    if (j < group.length) {
      return 0;
    }
    return 1;
  }

  if (cache[i][j] != -1) {
    return cache[i][j];
  }

  var res = 0;
  if (record[i] == '.') {
    res = dp(i + 1, j, record, group, cache);
  } else {
    if (record[i] == '?') {
      res += dp(i + 1, j, record, group, cache);
    }
    if (j < group.length) {
      var count = 0;
      for (var k = i; k < record.length; k++) {
        if (count > group[j] ||
            record[k] == '.' ||
            (count == group[j] && record[k] == '?')) {
          break;
        }
        count += 1;
      }

      if (count == group[j]) {
        if (i + count < record.length && record[i + count] != '#') {
          res += dp(i + count + 1, j + 1, record, group, cache);
        } else {
          res += dp(i + count, j + 1, record, group, cache);
        }
      }
    }
  }

  cache[i][j] = res;
  return res;
}

List<dynamic> parse(String input) {
  var records = <String>[];
  var groups = <List<int>>[];

  for (var line in LineSplitter.split(input.replaceAll('\r\n', '\n'))) {
    var parts = line.split(' ');
    records.add(parts[0]);
    var group = parts[1].split(',').map((num) => int.parse(num)).toList();
    groups.add(group);
  }

  return [records, groups];
}

import 'dart:async';
import 'dart:io';

import 'util.dart';

// ignore: prefer_interpolation_to_compose_strings
final _shaRegEx = RegExp(r'^' + shaRegexPattern + r'$');

bool isValidSha(String value) => _shaRegEx.hasMatch(value);

Future<ProcessResult> runGit(List<String> args,
    {bool throwOnError = true, String processWorkingDir}) async {
  final pr = await Process.run('git', args,
      workingDirectory: processWorkingDir, runInShell: true);

  if (throwOnError) {
    _throwIfProcessFailed(pr, 'git', args);
  }
  return pr;
}

void _throwIfProcessFailed(
    ProcessResult pr, String process, List<String> args) {
  assert(pr != null);
  if (pr.exitCode != 0) {
    final message = '''
stdout:
${pr.stdout}
stderr:
${pr.stderr}''';

    throw ProcessException(process, args, message, pr.exitCode);
  }
}

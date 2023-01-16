import 'dart:io';

import 'package:code_statistics/widgets/form_item.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeFormat on DateTime {
  String format({String pattern = "yyyy-MM-dd"}) {
    return DateFormat(pattern).format(this);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/*
git log
--author="songyang"
--since="2019-05-01"
--until="2019-05-31"
--pretty=tformat:
--numstat
-- .
":(exclude)static/built"
":(exclude)static/bower_components"
| awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }'
 */
// git log --since="2023-01-01" --until="2023-01-16" --pretty=tformat: --numstat -- . | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s
// ", add, subs, loc }'
// git log --since="2023-01-01" --until="2023-01-16" --pretty=tformat:  --numstat  -- . | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }'

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String _projectPath = ""; // 项目路径
  String _excludeDir = ""; // 排除目录
  String _excludeFile = ""; // 排除文件
  DateTime _endTime = DateTime.now(); // 结束时间
  DateTime _startTime =
      DateTime(DateTime.now().year, DateTime.now().month); // 开始时间

  @override
  void initState() {
    super.initState();
  }

  void _calcCode() {
    String command = "git";
    List<String> arguments = [
      "log",
      "--since=\"${_startTime.format()}\"",
      "--until=\"${_endTime.format()}\"",
      "--pretty=tformat:",
      "--numstat",
      "--",
      ".",
    ];
    arguments += _excludeDir.split(",").where((element) => element.isNotEmpty).map((e) => "\":(exclude)$e\"").toList();
    arguments += _excludeFile.split(",").where((element) => element.isNotEmpty).map((e) => "\":(exclude)$e\"").toList();
    arguments+=[
      "|",
      "awk",
      "'{ add += \$1; subs += \$2; loc += \$1 - \$2 } END { printf \"added lines: %s, removed lines: %s, total lines: %s\\n\", add, subs, loc }'"
    ];
    Process.run(
      command,
      arguments,
      runInShell: true,
      workingDirectory: _projectPath,
    ).then((result) {
      print('${result.stdout.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Form(
              key: _globalKey,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    FormItem(
                      initialValue: _projectPath,
                      label: "项目",
                      // icon: Icon(Icons.computer_outlined),
                      suffixIcon: Icon(Icons.folder_copy_outlined),
                      onSuffixIconTap: (controller) {
                        getDirectoryPath().then((value) {
                          if (value != null) {
                            _projectPath = value;
                            controller.text = value;
                          }
                        });
                      },
                    ),
                    FormItem(
                      initialValue: _excludeDir,
                      required: false,
                      label: "排除目录（可添加多项，以英文逗号隔开）",
                      // icon: Icon(Icons.folder_outlined),
                      suffixIcon: Icon(Icons.folder_copy_outlined),
                      onSuffixIconTap: (controller) {
                        getDirectoryPath(initialDirectory: _projectPath)
                            .then((value) {
                          if (value != null) {
                            _excludeDir += "$value,";
                            controller.text = _excludeDir;
                          }
                        });
                      },
                    ),
                    FormItem(
                      initialValue: _excludeFile,
                      required: false,
                      label: "排除文件（可添加多项，以英文逗号隔开）",
                      // icon: Icon(Icons.file_copy_outlined),
                      suffixIcon: Icon(Icons.file_copy_outlined),
                      onSuffixIconTap: (controller) {
                        openFiles(initialDirectory: _projectPath).then((value) {
                          for (var element in value) {
                            _excludeFile += "${element.path},";
                            controller.text = _excludeFile;
                          }
                        });
                      },
                    ),
                    FormItem(
                      initialValue: DateFormat("yyyy-MM-dd").format(_startTime),
                      label: "开始时间",
                      // icon: Icon(Icons.timer_rounded),
                      suffixIcon: Icon(Icons.calendar_month_outlined),
                      onSuffixIconTap: (controller) {
                        showDatePicker(
                          context: context,
                          initialDate: _startTime,
                          firstDate: DateTime(
                              DateTime.now().year, DateTime.now().month),
                          lastDate: DateTime.now(),
                        ).then((value) {
                          if (value != null) {
                            _startTime = value;
                            controller.text = value.format();
                          }
                        });
                      },
                    ),
                    FormItem(
                      initialValue: _endTime.format(),
                      label: "结束时间",
                      // icon: Icon(Icons.timer_off),
                      suffixIcon: Icon(
                        Icons.calendar_month_outlined,
                      ),
                      onSuffixIconTap: (controller) {
                        showDatePicker(
                          context: context,
                          initialDate: _endTime,
                          firstDate: DateTime(
                              DateTime.now().year, DateTime.now().month),
                          lastDate: DateTime.now(),
                        ).then((value) {
                          if (value != null) {
                            _endTime = value;
                            controller.text = value.format();
                          }
                        });
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _globalKey.currentState?.reset();
                          },
                          child: Text("清空"),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _calcCode();
                          },
                          child: Text("提交"),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            flex: 2,
          ),
          Flexible(
            child: Placeholder(),
            flex: 3,
          )
        ],
      ),
    );
  }
}

import 'package:code_statistics/widgets/form_item.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
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
                label: "排除目录（可添加多项，以英文逗号隔开）",
                // icon: Icon(Icons.folder_outlined),
                suffixIcon: Icon(Icons.folder_copy_outlined),
                onSuffixIconTap: (controller) {
                  getDirectoryPath(initialDirectory: _projectPath)
                      .then((value) {
                    if (value != null) {
                      _excludeDir = value;
                      controller.text = _excludeDir;
                    }
                  });
                },
              ),
              FormItem(
                initialValue: _excludeFile,
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
                          firstDate: _startTime,
                          lastDate: DateTime.now())
                      .then((value) {
                    if (value != null) {
                      _startTime = value;
                      controller.text = DateFormat("yyyy-MM-dd").format(value);
                    }
                  });
                },
              ),
              FormItem(
                initialValue: DateFormat("yyyy-MM-dd").format(_endTime),
                label: "结束时间",
                // icon: Icon(Icons.timer_off),
                suffixIcon: Icon(Icons.calendar_month_outlined),
                onSuffixIconTap: (controller) {
                  showDatePicker(
                          context: context,
                          initialDate: _endTime,
                          firstDate: _startTime,
                          lastDate: DateTime.now())
                      .then((value) {
                    if (value != null) {
                      _endTime = value;
                      controller.text = DateFormat("yyyy-MM-dd").format(value);
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
                    onPressed: () {},
                    child: Text("清空"),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("提交"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String _projectPath = ""; // 项目路径
  List<String> _excludePath = List.empty(); // 排除目录
  String _excludeFile = ""; // 排除文件

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("代码统计工具"),),
      body: Form(
        key: _globalKey,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              FormField(builder: (context) {
                return Row(
                  children: [
                    const Text("选择项目："),
                    Text(_projectPath),
                    OutlinedButton(
                      onPressed: () {
                        getDirectoryPath().then((value) {
                          if (value != null) {
                            setState(() {
                              _projectPath = value;
                            });
                          }
                        });
                      },
                      child: const Text("请选择"),
                    )
                  ],
                );
              }),
              FormField(builder: (context) {
                return Row(
                  children: [
                    const Text("排除目录："),
                    _excludePath.isNotEmpty
                        ? Column(
                            children: ListTile.divideTiles(
                                context: this.context,
                                tiles: _excludePath.map(
                                  (e) => Text(e),
                                )).toList(),
                          )
                        : Container(),
                    OutlinedButton(
                      onPressed: () {
                        getDirectoryPath(initialDirectory: _projectPath)
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              _excludePath = _excludePath + [value];
                            });
                          }
                        });
                      },
                      child: const Text("添加"),
                    )
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib_example/device_details/device_details_bloc.dart';

class LogsContainerView extends StatelessWidget {
  final Stream<List<DebugLog>> _logs;

  LogsContainerView(this._logs);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: SizedBox.expand(
        child: Column(
          children: <Widget>[
            Flexible(
              child: StreamBuilder<List<DebugLog>>(
                initialData: [],
                stream: _logs,
                builder: (context, snapshot) => _buildLogs(context, snapshot),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogs(BuildContext context, AsyncSnapshot<List<DebugLog>> logs) {
    final data = logs.data;
    return ListView.builder(
      itemCount: data?.length,
      shrinkWrap: true,
      itemBuilder: (buildContext, index) {
        Widget body([TextOverflow overflow = TextOverflow.ellipsis]) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    data?[index].time ?? "",
                    style: TextStyle(fontSize: 9),
                  ),
                ),
                Text(
                  data?[index].content ?? "",
                  overflow: overflow,
                  softWrap: true,
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          );
        }

        return InkWell(
          onTap: () {
            showBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close),
                        ),
                        body(TextOverflow.visible),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: body(),
          ),
        );
      },
    );
  }
}

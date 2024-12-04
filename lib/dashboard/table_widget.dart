import 'package:civic_voice/components/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TableWidget extends StatelessWidget {
  const TableWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find();

    return Expanded(
      flex: 3,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return DataTable(
              columns: const [
                DataColumn(label: Text('S No.')),
                DataColumn(label: Text('User Id')),
                DataColumn(label: Text('Address')),
                DataColumn(label: Text('Problem Category')),
                DataColumn(label: Text('Landmark')),
                DataColumn(label: Text('Cordinates')),
              ],
              rows: List.generate(
                controller.data.length,
                (index) => DataRow(cells: [
                  DataCell(Text(
                    '${index + 1}',
                  )),
                  DataCell(SizedBox(
                    width: 200,
                    child: Text(
                      controller.data[index].userId,
                      softWrap: true,
                      style: _textStyle(),
                    ),
                  )),
                  DataCell(SizedBox(
                    width: 200,
                    child: Text(
                      controller.data[index].address,
                      softWrap: true,
                      style: _textStyle(),
                    ),
                  )),
                  DataCell(Text(
                    controller.data[index].category,
                    style: _textStyle(),
                  )),
                  DataCell(Text(
                    controller.data[index].landMark.toString(),
                    style: _textStyle(),
                  )),
                  DataCell(Text(
                    "${controller.data[index].latitude} ${controller.data[index].longitude}",
                    style: _textStyle(),
                  )),
                ]),
              ),
            );
          }),
        ),
      ),
    );
  }

  TextStyle _textStyle() {
    return const TextStyle(fontSize: 12);
  }
}

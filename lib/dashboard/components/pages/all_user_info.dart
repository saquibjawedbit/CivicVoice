import 'package:civic_voice/components/constants/category_complaint.dart';
import 'package:civic_voice/components/controller/dashboard_controller.dart';
import 'package:civic_voice/components/models/complain_model.dart';
import 'package:civic_voice/dashboard/components/pages/complaint_info.dart';
import 'package:civic_voice/dashboard/components/pages/user_info_page.dart';
import 'package:civic_voice/dashboard/components/utils/side_bar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllUserInfo extends StatefulWidget {
  const AllUserInfo({super.key});

  @override
  State<AllUserInfo> createState() => _AllUserInfoState();
}

class _AllUserInfoState extends State<AllUserInfo> {
  List<ComplainModel> _complainsList = [];
  final DashboardController _dashboardController = Get.find();
  String? category;

  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _complainIdController = TextEditingController();

  void _onSubmit() async {
    String city = _regionController.text;
    String complainId = _complainIdController.text;

    if (complainId.isNotEmpty) {
      _complainsList.clear();
      ComplainModel? complainModel =
          await _dashboardController.fetchComplain(complainId);
      if (complainModel == null) {
        _complainsList = [];
        return;
      }
      _complainsList.add(complainModel);
      setState(() {});
    }

    if (city.isEmpty && category == null) return;

    _complainsList = await _dashboardController.fetchAllComplainModel(
            city.toLowerCase(), category) ??
        [];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(
            selectedOption: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Users Information",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _regionController,
                        decoration: const InputDecoration(
                            labelText: "Enter Your Region"),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _complainIdController,
                        decoration:
                            const InputDecoration(labelText: "Complain Id"),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    _dropDownSearch(context),
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton.filled(
                      onPressed: _onSubmit,
                      icon: const Icon(Icons.search),
                      color: Colors.blue.shade50,
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('S No.')),
                    DataColumn(label: Text('User Id')),
                    DataColumn(label: Text('Address')),
                    DataColumn(label: Text('Problem Category')),
                    DataColumn(label: Text('Landmark')),
                    DataColumn(label: Text('Cordinates')),
                    DataColumn(label: SizedBox()),
                  ],
                  rows: List.generate(
                    _complainsList.length,
                    (index) => DataRow(
                      cells: [
                        DataCell(Text(
                          '${index + 1}',
                        )),
                        DataCell(SizedBox(
                          width: 200,
                          child: Text(
                            _complainsList[index].userId,
                            softWrap: true,
                            style: _textStyle(),
                          ),
                        )),
                        DataCell(SizedBox(
                          width: 200,
                          child: Text(
                            _complainsList[index].address,
                            softWrap: true,
                            style: _textStyle(),
                          ),
                        )),
                        DataCell(Text(
                          _complainsList[index].category,
                          style: _textStyle(),
                        )),
                        DataCell(Text(
                          _complainsList[index].landMark.toString(),
                          style: _textStyle(),
                        )),
                        DataCell(Text(
                          "${_complainsList[index].latitude} ${_complainsList[index].longitude}",
                          style: _textStyle(),
                        )),
                        DataCell(
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) {
                              // Handle menu item selection
                              switch (value) {
                                case 'Open Problem':
                                  Get.to(
                                    () => ComplaintInfo(
                                      complainId: _complainsList[index].id!,
                                    ),
                                  );
                                  break;
                                case 'User Info':
                                  // Add action for Option 2
                                  Get.to(() => UserInfo(
                                      uid: _complainsList[index].userId));
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem<String>(
                                value: 'Open Problem',
                                child: Text('Open Problem'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'User Info',
                                child: Text('User Info'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _textStyle() {
    return const TextStyle(fontSize: 12);
  }

  Widget _dropDownSearch(context) {
    return SizedBox(
      width: 400,
      child: DropdownSearch<String>(
        validator: (value) {
          if (value == null) {
            return "Required";
          }
          return null;
        },
        popupProps: PopupProps.menu(
          fit: FlexFit.loose,
          itemBuilder: (context, item, isDisabled, isSelected) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text(
              item,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
        ),
        items: (f, cs) => problemCategory,
        filterFn: (item, filter) =>
            item.toLowerCase().contains(filter.toLowerCase()), // Search logic,

        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            hintText: "Choose a Category",
            suffixIconColor:
                Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 16,
            ),
          ),
          baseStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
              ),
        ),
        onChanged: (String? selectedItem) {
          category = selectedItem;
        },
      ),
    );
  }
}

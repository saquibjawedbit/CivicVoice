import 'package:civic_voice/components/controller/dashboard_controller.dart';
import 'package:civic_voice/components/models/complain_model.dart';
import 'package:civic_voice/components/models/user_model.dart';
import 'package:civic_voice/dashboard/components/utils/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  UserModel? _userModel;
  final DashboardController _dbController = Get.find();
  List<ComplainModel> _history = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    _loadData();
    super.didChangeDependencies();
  }

  void _loadData() async {
    try {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      _userModel = await _dbController.fetchUser(args);
      _history = await _dbController.fetchAllUserComplainModel(args) ?? [];
      setState(() {});
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(
            selectedOption: 0,
          ),
          (_userModel == null)
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 36, right: 12, top: 24),
                    child: Column(
                      children: [
                        Text(
                          "User Detail",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 42),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        _info(),
                        Scrollbar(
                          controller: _scrollController,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('S No.')),
                                DataColumn(label: Text('Id')),
                                DataColumn(label: Text('Title')),
                                DataColumn(label: Text('Problem Category')),
                                DataColumn(label: Text('Address')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: SizedBox()),
                              ],
                              rows: List.generate(
                                _history.length,
                                (index) => DataRow(
                                  cells: [
                                    DataCell(Text(
                                      '${index + 1}',
                                    )),
                                    DataCell(SizedBox(
                                      width: 200,
                                      child: Text(
                                        _history[index].id!,
                                        softWrap: true,
                                        style: _textStyle(),
                                      ),
                                    )),
                                    DataCell(SizedBox(
                                      width: 200,
                                      child: Text(
                                        _history[index].title,
                                        softWrap: true,
                                        style: _textStyle(),
                                      ),
                                    )),
                                    DataCell(Text(
                                      _history[index].category,
                                      style: _textStyle(),
                                    )),
                                    DataCell(SizedBox(
                                      width: 250,
                                      child: Text(
                                        _history[index].address.toString(),
                                        style: _textStyle(),
                                      ),
                                    )),
                                    DataCell(Text(
                                      "Status: ${(_history[index].status == 0) ? "Pending" : (_history[index].status == 1) ? "Working" : "Resolved"}",
                                      style: _textStyle(),
                                    )),
                                    DataCell(
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert),
                                        onSelected: (value) {
                                          // Handle menu item selection
                                          switch (value) {
                                            case 'Open Problem':
                                              Get.toNamed('/complain',
                                                  arguments:
                                                      _history[index].id);
                                              break;
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem<String>(
                                            value: 'Open Problem',
                                            child: Text('Open Problem'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _info() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 12,
        ),
        _details(),
        const Expanded(
          child: Icon(
            Icons.account_circle_rounded,
            size: 240,
          ),
        ),
      ],
    );
  }

  Widget _details() {
    return SizedBox(
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "UID: ${_userModel!.id ?? "Error loading"}",
            style: _textStyle(),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "User Name: ${_userModel!.name ?? "Not Updated"}",
            style: _textStyle(),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Phone Number: ${_userModel!.phoneNumber}",
            style: _textStyle(),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Email Id: ${_userModel!.email ?? "Not Updated"}",
            style: _textStyle(),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Number of Complains: ${_userModel!.complaintCount}",
            style: _textStyle(),
          ),
        ],
      ),
    );
  }

  TextStyle _textStyle() {
    return const TextStyle(
      fontSize: 18,
      color: Colors.black,
    );
  }
}

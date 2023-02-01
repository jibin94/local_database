import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note_model.dart';
import '../services/database_helper.dart';
import '../widgets/note_widget.dart';
import 'note_screen.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({Key? key}) : super(key: key);

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  TextEditingController dateController = TextEditingController();

  DateTime currentDate = DateTime.now();
  // Initial Selected Value
  int _selectedId = 1;
  String dropDownValue = 'Food';

  List<Map<String, dynamic>>? categoryMaps;
  List<Map<String, dynamic>>? newCategoryMaps;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeDb();
    dateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
  }

  Future<void> _loadCategories() async {
    categoryMaps = await DatabaseHelper.getCategories();
    newCategoryMaps = List<Map<String, dynamic>>.from(categoryMaps!);

    if (categoryMaps != null) {
      _selectedId = categoryMaps![0]["categoryId"];
      dropDownValue = categoryMaps![0]["categoryTitle"];

      Map<String, dynamic> data = {"categoryId": 4, "categoryTitle": "All"};

      newCategoryMaps!.add(data);
    }

    categoryMaps = newCategoryMaps;

    setState(() {});

    for (var category in categoryMaps!) {
      print(category["categoryId"]);
      print(category["categoryTitle"]);
    }
  }

  _initializeDb() async {
    final db1 = await DatabaseHelper.getCategoryDB();
    await DatabaseHelper.insertCategories(db1);

    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("executed build");
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Items App'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NoteScreen()));
            setState(() {});
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: TextFormField(
                        enabled: false,
                        controller: dateController,
                        keyboardType: TextInputType.datetime,
                        validator: (title) {
                          if (title!.isEmpty) {
                            return 'Date cannot be empty';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Date',
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      icon: const Icon(Icons.calendar_month)),
                  categoryMaps != null
                      ? Expanded(
                          child: DropdownButton<int>(
                            isExpanded: true,
                            hint: const Text('Select a category'),
                            items: categoryMaps!
                                .map((Map<String, dynamic> category) {
                              return DropdownMenuItem<int>(
                                value: category['categoryId'],
                                child: Text(category['categoryTitle']),
                              );
                            }).toList(),
                            onChanged: (int? selectedId) {
                              setState(() {
                                dropDownValue = categoryMaps!.firstWhere(
                                    (Map<String, dynamic> category) =>
                                        category['categoryId'] ==
                                        selectedId)['categoryTitle'];
                                _selectedId = selectedId!;
                              });
                            },
                            value: _selectedId,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Item>?>(
                //DatabaseHelper.getSpecific('jibin', dateController.text.trim())
                //DatabaseHelper.getAllNotes()
                future: DatabaseHelper.getSpecific(
                    _selectedId, dateController.text.trim()),
                builder: (context, AsyncSnapshot<List<Item>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Center(
                            child: SizedBox(
                          child: CircularProgressIndicator(),
                          height: 30,
                          width: 30,
                        )),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    debugPrint("snapshot has data");
                    print(snapshot.data);
                    if (snapshot.data != null) {
                      return ListView.builder(
                        itemBuilder: (context, index) => NoteWidget(
                          note: snapshot.data![index],
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NoteScreen(
                                          note: snapshot.data![index],
                                        )));
                            setState(() {});
                          },
                          onLongPress: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Are you sure you want to delete this item?'),
                                    actions: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red)),
                                        onPressed: () async {
                                          await DatabaseHelper.deleteNote(
                                              snapshot.data![index]);
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: const Text('Yes'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('No'),
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                        itemCount: snapshot.data!.length,
                      );
                    }
                    return const Center(
                      child: Text('No items added'),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'No items added',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2023),
        lastDate: DateTime(2024));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        dateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_database/models/note_model.dart';
import 'package:local_database/services/database_helper.dart';

class NoteScreen extends StatefulWidget {
  final Item? note;
  const NoteScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  // Initial Selected Value
  int _selectedId = 1;
  String dropDownValue = 'Food';

  DateTime currentDate = DateTime.now();

  List<Map<String, dynamic>>? categoryMaps;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      descriptionController.text = widget.note!.description;
      dateController.text = widget.note!.date;
    } else {
      dateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
    }
  }

  Future<void> _loadCategories() async {
    categoryMaps = await DatabaseHelper.getCategories();

    setState(() {});

    if (categoryMaps != null) {
      _selectedId = categoryMaps![0]["categoryId"];
      dropDownValue = categoryMaps![0]["categoryTitle"];
    }

    for (var category in categoryMaps!) {
      print(category["categoryId"]);
      print(category["categoryTitle"]);
    }

    if (widget.note != null) {
      _selectedId = widget.note!.categoryId;
      dropDownValue = widget.note!.categoryName;

      print("received dropdown value is : $dropDownValue");
      print("received dropdown id is : $_selectedId");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add an item' : 'Edit item'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: TextFormField(
                controller: titleController,
                maxLines: 1,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                    hintText: 'Title',
                    labelText: 'Item title',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 0.75,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ))),
              ),
            ),
            TextFormField(
              textInputAction: TextInputAction.done,
              controller: descriptionController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                  hintText: 'Type here the description',
                  labelText: 'Item description',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 0.75,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ))),
              keyboardType: TextInputType.multiline,
              onChanged: (str) {},
              maxLines: 5,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 25.0, bottom: 10),
              child: Text("Select a category"),
            ),
            categoryMaps != null
                ? DropdownButton<int>(
                    isDense: false,
                    isExpanded: true,
                    hint: const Text('Select a category'),
                    items: categoryMaps!.map((Map<String, dynamic> category) {
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
                  )
                : Container(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
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
                IconButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    icon: const Icon(Icons.calendar_month))
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () async {
                      final title = titleController.value.text;
                      final description = descriptionController.value.text;

                      final date = dateController.value.text;

                      if (title.isEmpty || description.isEmpty) {
                        return;
                      }

                      final Item model = Item(
                          title: title,
                          description: description,
                          categoryName: dropDownValue,
                          categoryId: _selectedId,
                          date: date,
                          id: widget.note?.id);

                      debugPrint(model.toString());
                      if (widget.note == null) {
                        await DatabaseHelper.addNote(model);
                      } else {
                        await DatabaseHelper.updateNote(model);
                      }

                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.blue,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                )))),
                    child: Text(
                      widget.note == null ? 'Add' : 'Update',
                      style: const TextStyle(fontSize: 18),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2022),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        dateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
      });
    }
  }
}

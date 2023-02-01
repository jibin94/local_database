import 'package:flutter/material.dart';
import 'package:local_database/models/note_model.dart';

class NoteWidget extends StatelessWidget {
  final Item note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  const NoteWidget(
      {Key? key,
      required this.note,
      required this.onTap,
      required this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  note.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              Text("Description : ${note.description}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400)),
              spacing(),
              Text("Category : ${note.categoryName}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400)),
              spacing(),
              Text("Date : ${note.date}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400)),
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  IconButton(
                    onPressed: onTap,
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  IconButton(
                    onPressed: onLongPress,
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    padding: EdgeInsets.zero,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget spacing() {
    return const SizedBox(
      height: 5,
    );
  }
}

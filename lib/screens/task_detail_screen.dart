import 'package:flutter/material.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/screens/task_form_screen.dart';
import 'package:todo_list_app/services/task_service.dart';
import 'package:intl/intl.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskFormScreen(task: task),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool? confirmed = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirmar Exclusão'),
                  content: Text('Tem certeza que deseja excluir esta tarefa?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Excluir'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                TaskService().deleteTask(task.id);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descrição:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(task.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text(
              'Data de Vencimento:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(DateFormat('dd/MM/yyyy').format(task.dueDate),
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text(
              'Categoria:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(task.category, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

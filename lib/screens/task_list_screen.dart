import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/screens/task_detail_screen.dart';
import 'package:todo_list_app/screens/task_form_screen.dart';
import 'package:todo_list_app/services/task_service.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Minhas Tarefas'),
        centerTitle: true,
        backgroundColor: Color(0xFF0cb7f2),
      ),
      body: StreamBuilder<List<Task>>(
        stream: TaskService().getTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Sem tarefas ainda.'),
            );
          }

          Map<String, List<Task>> tasksByCategory = {};
          snapshot.data!.forEach((task) {
            if (!tasksByCategory.containsKey(task.category)) {
              tasksByCategory[task.category] = [];
            }
            tasksByCategory[task.category]!.add(task);
          });

          return ListView.builder(
            itemCount: tasksByCategory.length,
            itemBuilder: (context, index) {
              String category = tasksByCategory.keys.toList()[index];
              List<Task> tasks = tasksByCategory[category]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFF0cb7f2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Dismissible(
                        key: Key(task.id),
                        background: Container(
                          color: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerLeft,
                          child: Icon(Icons.edit, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                    
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirmar Exclusão'),
                                  content: Text('Tem certeza que deseja excluir esta tarefa?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: Text('Confirmar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (direction == DismissDirection.startToEnd) {
                      
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TaskFormScreen(task: task)),
                            );
                            return false; // Impede a remoção
                          }
                          return false;
                        },
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            setState(() {
                              tasks.removeAt(index);
                            });
                          
                            TaskService().deleteTask(task.id);
                          }
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                          color: _isDueSoon(task.dueDate) ? Colors.yellow.shade100 : Colors.white,
                          child: ListTile(
                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              task.description,
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            trailing: Text(
                              DateFormat('dd/MM/yyyy HH:mm').format(task.dueDate),
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskFormScreen()),
          );
        },
        backgroundColor: Color(0xFF0cb7f2),
        child: Icon(Icons.add),
      ),
    );
  }

  bool _isDueSoon(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inHours;
    return difference <= 24 && difference >= 0;
  }
}

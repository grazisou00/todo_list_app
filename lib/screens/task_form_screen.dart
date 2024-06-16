import 'package:flutter/material.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/services/task_service.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _dueDate;
  late TimeOfDay _dueTime;
  late String _category;

  final List<String> _categories = ['Trabalho', 'Pessoal', 'Estudos'];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _dueDate = widget.task!.dueDate;
      _dueTime = TimeOfDay.fromDateTime(widget.task!.dueDate);
      _category = widget.task!.category;
    } else {
      _title = '';
      _description = '';
      _dueDate = DateTime.now();
      _dueTime = TimeOfDay.now();
      _category = _categories.first;
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate)
      setState(() {
        _dueDate = picked;
      });
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _dueTime,
    );
    if (picked != null && picked != _dueTime)
      setState(() {
        _dueTime = picked;
      });
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      final DateTime fullDueDate = DateTime(
        _dueDate.year,
        _dueDate.month,
        _dueDate.day,
        _dueTime.hour,
        _dueTime.minute,
      );

      final newTask = Task(
        id: widget.task?.id ?? DateTime.now().toString(),
        title: _title,
        description: _description,
        dueDate: fullDueDate,
        category: _category,
      );

      if (widget.task == null) {
        TaskService().addTask(newTask);
      } else {
        TaskService().updateTask(newTask);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Adicionar Tarefa' : 'Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
                onChanged: (value) => _title = value,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
                onChanged: (value) => _description = value,
              ),
              ListTile(
                title: Text("Data de Vencimento"),
                subtitle: Text("${_dueDate.toLocal()}".split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: Text("Hora de Vencimento"),
                subtitle: Text("${_dueTime.format(context)}"),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
              DropdownButtonFormField(
                value: _category,
                decoration: InputDecoration(labelText: 'Categoria'),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value as String;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
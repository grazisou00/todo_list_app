import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_app/models/task.dart';

class TaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Task>> getTasks() {
    try {
      return _db.collection('tasks').snapshots().map((snapshot) => snapshot.docs
          .map((doc) => Task.fromMap(doc.data(), doc.id))
          .toList());
    } catch (e) {
      print('Erro ao recuperar tarefas: $e');
      return Stream.empty();
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await _db.collection('tasks').add(task.toMap());
    } catch (e) {
      print('Erro ao adicionar tarefa: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _db.collection('tasks').doc(task.id).update(task.toMap());
    } catch (e) {
      print('Erro ao atualizar tarefa: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _db.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print('Erro ao deletar tarefa: $e');
    }
  }
}

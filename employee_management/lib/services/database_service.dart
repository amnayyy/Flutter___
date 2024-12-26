import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart';
import '../models/employee.dart';
import '../models/task.dart';

class DatabaseService {
  Database? _database;

  DatabaseService() {
    _initializeSqlite();
  }

  void _initializeSqlite() {
    if (Platform.isWindows) {
      print('SQLite initialized for Windows.');
    }
  }

  Database get database {
    if (_database != null) return _database!;
    print('Database is not initialized, initializing now...');
    _database = _initDB();
    return _database!;
  }

  Database _initDB() {
    print('Initializing database...');
    final dbFolder = Directory(join(Directory.current.path, 'db'));
    if (!dbFolder.existsSync()) {
      dbFolder.createSync();
    }
    String path = join(dbFolder.path, 'employee_management.db');
    print('Database path: $path');

    final db = sqlite3.open(path);
    _createDB(db);
    return db;
  }

  void _createDB(Database db) {
    print('Creating database tables...');
    db.execute('''
      CREATE TABLE IF NOT EXISTS employees(
        id TEXT PRIMARY KEY,
        nom TEXT NOT NULL,
        prenom TEXT NOT NULL,
        email TEXT NOT NULL,
        telephone TEXT NOT NULL,
        poste TEXT NOT NULL,
        departement TEXT NOT NULL,
        dateEmbauche TEXT NOT NULL
      )
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS tasks(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        employeeId TEXT NOT NULL,
        employeeName TEXT NOT NULL,
        FOREIGN KEY (employeeId) REFERENCES employees (id)
      )
    ''');
    
    print('Database tables created successfully');
  }

  // Employee methods
  void insertEmployee(Employee employee) {
    final db = database;
    try {
      print('Inserting employee: ${employee.nom} ${employee.prenom}');
      db.execute(
        'INSERT INTO employees (id, nom, prenom, email, telephone, poste, departement, dateEmbauche) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [
          employee.id,
          employee.nom,
          employee.prenom,
          employee.email,
          employee.telephone,
          employee.poste,
          employee.departement,
          employee.dateEmbauche.toIso8601String()
        ]
      );
      print('Employee inserted successfully');
    } catch (e) {
      print('Error inserting employee: $e');
      rethrow;
    }
  }

  List<Employee> getAllEmployees() {
    final db = database;
    print('Getting all employees...');

    try {
      final result = db.select('SELECT * FROM employees');
      print('Found ${result.length} employees');

      return result.map((row) => Employee(
        id: row['id'].toString(),
        nom: row['nom'].toString(),
        prenom: row['prenom'].toString(),
        email: row['email'].toString(),
        telephone: row['telephone'].toString(),
        poste: row['poste'].toString(),
        departement: row['departement'].toString(),
        dateEmbauche: DateTime.parse(row['dateEmbauche'].toString()),
      )).toList();
    } catch (e) {
      print('Error getting employees: $e');
      rethrow;
    }
  }

  void updateEmployee(Employee employee) {
    final db = database;
    print('Updating employee: ${employee.nom} ${employee.prenom}');

    try {
      db.execute(
        'UPDATE employees SET nom = ?, prenom = ?, email = ?, telephone = ?, poste = ?, departement = ?, dateEmbauche = ? WHERE id = ?',
        [
          employee.nom,
          employee.prenom,
          employee.email,
          employee.telephone,
          employee.poste,
          employee.departement,
          employee.dateEmbauche.toIso8601String(),
          employee.id
        ]
      );
      print('Employee updated successfully');
    } catch (e) {
      print('Error updating employee: $e');
      rethrow;
    }
  }

  void deleteEmployee(String id) {
    final db = database;
    print('Deleting employee with id: $id');

    try {
      db.execute('DELETE FROM employees WHERE id = ?', [id]);
      print('Employee deleted successfully');
    } catch (e) {
      print('Error deleting employee: $e');
      rethrow;
    }
  }

  List<Employee> searchEmployees(String query) {
    final db = database;
    print('Searching employees with query: $query');

    try {
      final result = db.select(
        'SELECT * FROM employees WHERE nom LIKE ? OR prenom LIKE ? OR poste LIKE ?',
        ['%$query%', '%$query%', '%$query%']
      );

      return result.map((row) => Employee(
        id: row['id'].toString(),
        nom: row['nom'].toString(),
        prenom: row['prenom'].toString(),
        email: row['email'].toString(),
        telephone: row['telephone'].toString(),
        poste: row['poste'].toString(),
        departement: row['departement'].toString(),
        dateEmbauche: DateTime.parse(row['dateEmbauche'].toString()),
      )).toList();
    } catch (e) {
      print('Error searching employees: $e');
      rethrow;
    }
  }

  // Task methods
  void insertTask(Task task) {
    final db = database;
    try {
      print('Inserting task: ${task.title}');
      db.execute(
        'INSERT INTO tasks (id, title, description, date, isCompleted, employeeId, employeeName) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [
          task.id,
          task.title,
          task.description,
          task.date.toIso8601String(),
          task.isCompleted ? 1 : 0,
          task.employeeId,
          task.employeeName,
        ]
      );
      print('Task inserted successfully');
    } catch (e) {
      print('Error inserting task: $e');
      rethrow;
    }
  }

  List<Task> getTasksForDate(DateTime date) {
    final db = database;
    final startOfDay = DateTime(date.year, date.month, date.day).toIso8601String();
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59).toIso8601String();

    try {
      final result = db.select(
        'SELECT * FROM tasks WHERE date BETWEEN ? AND ?',
        [startOfDay, endOfDay]
      );

      return result.map((row) => Task(
        id: row['id'].toString(),
        title: row['title'].toString(),
        description: row['description'].toString(),
        date: DateTime.parse(row['date'].toString()),
        isCompleted: row['isCompleted'] == 1,
        employeeId: row['employeeId'].toString(),
        employeeName: row['employeeName'].toString(),
      )).toList();
    } catch (e) {
      print('Error getting tasks: $e');
      rethrow;
    }
  }

  List<Task> getTasksForEmployee(String employeeId) {
    final db = database;
    try {
      final result = db.select(
        'SELECT * FROM tasks WHERE employeeId = ?',
        [employeeId]
      );

      return result.map((row) => Task(
        id: row['id'].toString(),
        title: row['title'].toString(),
        description: row['description'].toString(),
        date: DateTime.parse(row['date'].toString()),
        isCompleted: row['isCompleted'] == 1,
        employeeId: row['employeeId'].toString(),
        employeeName: row['employeeName'].toString(),
      )).toList();
    } catch (e) {
      print('Error getting tasks for employee: $e');
      rethrow;
    }
  }

  void updateTask(Task task) {
    final db = database;
    try {
      db.execute(
        'UPDATE tasks SET title = ?, description = ?, date = ?, isCompleted = ?, employeeId = ?, employeeName = ? WHERE id = ?',
        [
          task.title,
          task.description,
          task.date.toIso8601String(),
          task.isCompleted ? 1 : 0,
          task.employeeId,
          task.employeeName,
          task.id,
        ]
      );
      print('Task updated successfully');
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  void deleteTask(String id) {
    final db = database;
    try {
      db.execute('DELETE FROM tasks WHERE id = ?', [id]);
      print('Task deleted successfully');
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }
}

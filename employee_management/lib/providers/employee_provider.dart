import 'package:flutter/foundation.dart';
import '../models/employee.dart';
import '../models/task.dart';
import '../services/database_service.dart';

class EmployeeProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Employee> _employees = [];
  List<Task> _tasks = [];
  String _searchQuery = '';
  bool _isLoggedIn = false;

  List<Employee> get employees => _searchQuery.isEmpty 
      ? _employees 
      : _employees.where((employee) => 
          employee.nom.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          employee.prenom.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          employee.poste.toLowerCase().contains(_searchQuery.toLowerCase())
        ).toList();
  
  List<Task> get tasks => _tasks;
  bool get isLoggedIn => _isLoggedIn;

  EmployeeProvider() {
    _loadEmployees();
  }

  void _loadEmployees() {
    _employees = _databaseService.getAllEmployees();
    notifyListeners();
  }

  void addEmployee(Employee employee) {
    _databaseService.insertEmployee(employee);
    _loadEmployees();
  }

  void updateEmployee(Employee employee) {
    _databaseService.updateEmployee(employee);
    _loadEmployees();
  }

  void deleteEmployee(String id) {
    _databaseService.deleteEmployee(id);
    _loadEmployees();
  }

  void searchEmployees(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  bool login(String username, String password) {
    // Pour cet exemple, nous utilisons des identifiants codés en dur
    // Dans une vraie application, vous devriez vérifier avec votre backend
    if (username == 'admin' && password == 'admin123') {
      _isLoggedIn = true;
      _loadEmployees();
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
    _searchQuery = '';
    notifyListeners();
  }

  // Task methods
  void addTask(Task task) {
    _databaseService.insertTask(task);
    notifyListeners();
  }

  List<Task> getTasksForDate(DateTime date) {
    return _databaseService.getTasksForDate(date);
  }

  List<Task> getTasksForEmployee(String employeeId) {
    return _databaseService.getTasksForEmployee(employeeId);
  }

  void updateTask(Task task) {
    _databaseService.updateTask(task);
    notifyListeners();
  }

  void deleteTask(String id) {
    _databaseService.deleteTask(id);
    notifyListeners();
  }
}

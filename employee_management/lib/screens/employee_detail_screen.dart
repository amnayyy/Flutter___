import 'package:flutter/material.dart';
import '../models/employee.dart';
import 'package:provider/provider.dart';
import '../providers/employee_provider.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final Employee employee;

  const EmployeeDetailScreen({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _emailController;
  late TextEditingController _telephoneController;
  late TextEditingController _posteController;
  late TextEditingController _departementController;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.employee.nom);
    _prenomController = TextEditingController(text: widget.employee.prenom);
    _emailController = TextEditingController(text: widget.employee.email);
    _telephoneController = TextEditingController(text: widget.employee.telephone);
    _posteController = TextEditingController(text: widget.employee.poste);
    _departementController = TextEditingController(text: widget.employee.departement);
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _posteController.dispose();
    _departementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier ${widget.employee.nom} ${widget.employee.prenom}'),
        backgroundColor: const Color(0xFF808080),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _prenomController,
              decoration: const InputDecoration(
                labelText: 'Prénom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _telephoneController,
              decoration: const InputDecoration(
                labelText: 'Téléphone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _posteController,
              decoration: const InputDecoration(
                labelText: 'Poste',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _departementController,
              decoration: const InputDecoration(
                labelText: 'Département',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final updatedEmployee = Employee(
                  id: widget.employee.id,
                  nom: _nomController.text,
                  prenom: _prenomController.text,
                  email: _emailController.text,
                  telephone: _telephoneController.text,
                  poste: _posteController.text,
                  departement: _departementController.text,
                  dateEmbauche: widget.employee.dateEmbauche,
                );

                context.read<EmployeeProvider>().updateEmployee(updatedEmployee);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0000FF),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Enregistrer les modifications',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

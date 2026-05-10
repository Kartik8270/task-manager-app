import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_widgets.dart';

class AddEditTaskScreen extends StatefulWidget {
  final TaskModel? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _taskService = TaskService();
  final _uuid = const Uuid();

  DateTime _selectedDate = DateTime.now();
  bool _isCompleted = false;
  bool _isLoading = false;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDate = widget.task!.date;
      _isCompleted = widget.task!.isCompleted;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      if (_isEditing) {
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          date: _selectedDate,
          isCompleted: _isCompleted,
        );
        await _taskService.updateTask(updatedTask);
      } else {
        final newTask = TaskModel(
          id: _uuid.v4(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          date: _selectedDate,
          isCompleted: _isCompleted,
          userId: userId,
          createdAt: DateTime.now(),
        );
        await _taskService.addTask(newTask);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing ? 'Task updated successfully!' : 'Task added successfully!',
            ),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button and title
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isEditing ? 'Edit Task' : 'New Task',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ).animate().fadeIn().slideX(begin: -0.2),

                const SizedBox(height: 32),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title field
                      _buildSectionLabel('Task Title'),
                      CustomTextField(
                        label: '',
                        hint: 'e.g. Complete project report',
                        controller: _titleController,
                        prefixIcon: const Icon(Icons.title_rounded, color: AppTheme.textSecondary),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter a task title';
                          }
                          if (val.trim().length < 3) {
                            return 'Title must be at least 3 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Description field
                      _buildSectionLabel('Description'),
                      CustomTextField(
                        label: '',
                        hint: 'Add details about this task...',
                        controller: _descriptionController,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        prefixIcon: const Icon(Icons.description_outlined, color: AppTheme.textSecondary),
                        validator: (val) => null, // Optional
                      ),

                      const SizedBox(height: 20),

                      // Date picker
                      _buildSectionLabel('Due Date'),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: const Border.fromBorderSide(
                              BorderSide(color: Color(0xFFE8E8F0), width: 1.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: AppTheme.textSecondary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: AppTheme.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Status toggle
                      _buildSectionLabel('Status'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: const Border.fromBorderSide(
                            BorderSide(color: Color(0xFFE8E8F0), width: 1.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isCompleted
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              color: _isCompleted
                                  ? AppTheme.successColor
                                  : AppTheme.textSecondary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _isCompleted ? 'Completed' : 'Pending',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: _isCompleted
                                    ? AppTheme.successColor
                                    : AppTheme.textSecondary,
                              ),
                            ),
                            const Spacer(),
                            Switch.adaptive(
                              value: _isCompleted,
                              onChanged: (val) => setState(() => _isCompleted = val),
                              activeColor: AppTheme.successColor,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      PrimaryButton(
                        text: _isEditing ? 'Update Task' : 'Add Task',
                        onPressed: _saveTask,
                        isLoading: _isLoading,
                        icon: _isEditing ? Icons.save_outlined : Icons.add_rounded,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }
}

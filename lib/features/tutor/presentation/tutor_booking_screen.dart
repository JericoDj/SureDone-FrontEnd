import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/tutor/domain/tutor_models.dart';
import 'package:suredone/core/services/booking_service.dart';
import 'package:suredone/features/activity/domain/activity_item.dart';

class TutorBookingScreen extends StatefulWidget {
  final Tutor tutor;

  const TutorBookingScreen({super.key, required this.tutor});

  @override
  State<TutorBookingScreen> createState() => _TutorBookingScreenState();
}

class _TutorBookingScreenState extends State<TutorBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Student Info
  final _nameController = TextEditingController();
  String _gradeLevel = 'Primary 1';
  final List<String> _gradeLevels = [
    'Primary 1', 'Primary 2', 'Primary 3', 
    'Primary 4', 'Primary 5', 'Primary 6'
  ];
  final _goalController = TextEditingController();
  final _promoController = TextEditingController();
  
  // Subject Selection
  late List<String> _availableSubjects;
  late List<String> _selectedSubjects;
  final _customSubjectController = TextEditingController();
  bool _isAddingSubject = false;

  // Date Selection
  final List<DateTime> _selectedDates = [];

  // Payment
  String _paymentMethod = 'Cash';
  final List<String> _paymentMethods = ['Cash', 'GCash', 'Maya'];

  @override
  void initState() {
    super.initState();
    _availableSubjects = List.from(widget.tutor.subjects);
    _selectedSubjects = [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    _promoController.dispose();
    _customSubjectController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = now.add(const Duration(days: 3)); // 3 days lead time
    final lastDate = now.add(const Duration(days: 365));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && !_selectedDates.contains(picked)) {
      setState(() {
        _selectedDates.add(picked);
        _selectedDates.sort();
      });
    }
  }

  void _removeDate(DateTime date) {
    setState(() {
      _selectedDates.remove(date);
    });
  }

  void _showPaymentMethodSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Select Payment Method", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              ..._paymentMethods.map((method) => ListTile(
                leading: Icon(
                  method == 'Cash' ? Icons.money : Icons.phone_android,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(method),
                trailing: _paymentMethod == method ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () {
                  setState(() => _paymentMethod = method);
                  Navigator.pop(context);
                },
              )),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _addCustomSubject() {
    if (_customSubjectController.text.isNotEmpty) {
      setState(() {
        final newSubject = _customSubjectController.text;
        _availableSubjects.add(newSubject);
        _selectedSubjects.add(newSubject);
        _customSubjectController.clear();
        _isAddingSubject = false;
      });
    }
  }

  double get _totalPrice => widget.tutor.pricePerHour * _selectedDates.length;

  void _confirmBooking() {
     if (_formKey.currentState!.validate()) {
      final booking = ActivityItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: "Tutoring with ${widget.tutor.name}",
        providerName: widget.tutor.name,
        date: _selectedDates.map((d) => "${d.month}/${d.day}").join(", "),
        price: "₱${_totalPrice.toStringAsFixed(0)}",
        status: ActivityStatus.requested,
        imageUrl: widget.tutor.avatarUrl,
        studentName: _nameController.text,
        gradeLevel: _gradeLevel,
        subjects: List.from(_selectedSubjects),
        paymentMethod: _paymentMethod,
      );

      BookingService().addBooking(booking);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Booking Requested! Check Activity tab.")));
      context.go('/activity'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Session")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tutor Summary
                    Row(
                      children: [
                        CircleAvatar(backgroundImage: NetworkImage(widget.tutor.avatarUrl)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Booking with ${widget.tutor.name}", style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text("₱${widget.tutor.pricePerHour}/session", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                    const Divider(height: 32),

                    // Student Details
                    const Text("Student Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: "Student Name", border: OutlineInputBorder()),
                      validator: (v) => v?.isNotEmpty == true ? null : "Required",
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _gradeLevel,
                      items: _gradeLevels.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (v) => setState(() => _gradeLevel = v!),
                      decoration: const InputDecoration(labelText: "Grade Level", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _goalController,
                      decoration: const InputDecoration(labelText: "Goal for Sessions", border: OutlineInputBorder(), hintText: "e.g. Prepare for exams"),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),

                    // Subjects
                    const Text("Subjects to Focus On", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _availableSubjects.map((subject) {
                        final isSelected = _selectedSubjects.contains(subject);
                        // Start with tutor subjects, allow user to add more
                        // If it's a custom subject (not in original tutor subjects), allow delete/edit via long press or just delete
                        final isCustom = !widget.tutor.subjects.contains(subject);
                        
                        return InputChip(
                          label: Text(subject),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedSubjects.add(subject);
                              } else {
                                _selectedSubjects.remove(subject);
                              }
                            });
                          },
                          onDeleted: isCustom ? () {
                            setState(() {
                              _availableSubjects.remove(subject);
                              _selectedSubjects.remove(subject);
                            });
                          } : null,
                        );
                      }).toList(),
                    ),
                     if (_isAddingSubject)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(child: TextField(controller: _customSubjectController, decoration: const InputDecoration(hintText: "Enter subject"))),
                            IconButton(onPressed: _addCustomSubject, icon: const Icon(Icons.check)),
                            IconButton(onPressed: () => setState(() => _isAddingSubject = false), icon: const Icon(Icons.close)),
                          ],
                        ),
                      )
                    else
                      TextButton.icon(
                        onPressed: () => setState(() => _isAddingSubject = true),
                        icon: const Icon(Icons.add),
                        label: const Text("Add Custom Subject"),
                      ),
                    
                    const SizedBox(height: 24),

                    // Dates
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Select Dates", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        TextButton(onPressed: () => _selectDate(context), child: const Text("Add Date")),
                      ],
                    ),
                    const Text("Minimum 3 days lead time required.", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 8),
                    if (_selectedDates.isEmpty)
                      const Text("No dates selected", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))
                    else
                      Wrap(
                        spacing: 8,
                        children: _selectedDates.map((date) => Chip(
                          label: Text("${date.month}/${date.day}/${date.year}"),
                          onDeleted: () => _removeDate(date),
                        )).toList(),
                      ),
                    const SizedBox(height: 24),

                    // Payment
                    const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _showPaymentMethodSheet,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_paymentMethod, style: const TextStyle(fontSize: 16)),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                   
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _promoController,
                      decoration: const InputDecoration(labelText: "Promo Code (Optional)", border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Total & Confirm
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Price:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("₱${_totalPrice.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).primaryColor)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedDates.isEmpty ? null : _confirmBooking,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        minimumSize: const Size(0, 45), // Global Override
                      ),
                      child: const Text("Confirm Booking"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/fitness/domain/fitness_models.dart';
import 'package:suredone/core/services/booking_service.dart';
import 'package:suredone/features/activity/domain/activity_item.dart';

class FitnessBookingScreen extends StatefulWidget {
  final FitnessCoach coach;

  const FitnessBookingScreen({super.key, required this.coach});

  @override
  State<FitnessBookingScreen> createState() => _FitnessBookingScreenState();
}

class _FitnessBookingScreenState extends State<FitnessBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Client Info
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _promoController = TextEditingController();
  
  // Focus Area Selection
  late List<String> _availableFocusAreas;
  late List<String> _selectedFocusAreas;

  // Date Selection
  final List<DateTime> _selectedDates = [];

  // Payment
  String _paymentMethod = 'Cash';
  final List<String> _paymentMethods = ['Cash', 'GCash', 'Maya'];

  @override
  void initState() {
    super.initState();
    _availableFocusAreas = List.from(widget.coach.focusAreas);
    _selectedFocusAreas = [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = now.add(const Duration(days: 1)); 
    final lastDate = now.add(const Duration(days: 90));

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

  double get _totalPrice => widget.coach.pricePerHour * _selectedDates.length;

  void _confirmBooking() {
     if (_formKey.currentState!.validate()) {
      if (_selectedDates.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select at least one date."))
        );
        return;
      }
      
      final booking = ActivityItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: "Training with ${widget.coach.name}",
        providerName: widget.coach.name,
        date: _selectedDates.map((d) => "${d.month}/${d.day}").join(", "),
        price: "₱${_totalPrice.toStringAsFixed(0)}",
        status: ActivityStatus.requested,
        imageUrl: widget.coach.avatarUrl,
        studentName: _nameController.text, // Reusing studentName for Client Name
        gradeLevel: _contactController.text, // Reusing gradeLevel for Contact Info (or we can append to name)
        subjects: List.from(_selectedFocusAreas), // Focus Areas mapped to subjects
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
      appBar: AppBar(title: const Text("Book Coach")),
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
                    // Coach Summary
                    Row(
                      children: [
                        CircleAvatar(backgroundImage: NetworkImage(widget.coach.avatarUrl), radius: 30),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.coach.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            Text("₱${widget.coach.pricePerHour.toStringAsFixed(0)} / session", style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w600)),
                          ],
                        )
                      ],
                    ),
                    const Divider(height: 32),

                    // Client Details
                    const Text("Client Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: "Your Name", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                      validator: (v) => v?.isNotEmpty == true ? null : "Required",
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _contactController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: "Contact Number", border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone)),
                      validator: (v) => v?.isNotEmpty == true ? null : "Required",
                    ),
                    const SizedBox(height: 24),

                    // Focus Areas
                    const Text("Focus Areas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Text("Select areas you want to work on:", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _availableFocusAreas.map((area) {
                        final isSelected = _selectedFocusAreas.contains(area);
                        return ChoiceChip(
                          label: Text(area),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedFocusAreas.add(area);
                              } else {
                                _selectedFocusAreas.remove(area);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Dates
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Select Dates", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        TextButton.icon(
                          onPressed: () => _selectDate(context),
                          icon: const Icon(Icons.calendar_today),
                          label: const Text("Add Date"),
                        ),
                      ],
                    ),
                    if (_selectedDates.isEmpty)
                      const Text("No dates selected", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))
                    else
                      Wrap(
                        spacing: 8,
                        children: _selectedDates.map((date) => Chip(
                          label: Text("${date.month}/${date.day}/${date.year}"),
                          onDeleted: () => _removeDate(date),
                          deleteIcon: const Icon(Icons.close, size: 18),
                        )).toList(),
                      ),
                    const SizedBox(height: 24),

                    // Payment
                    const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _paymentMethod,
                      items: _paymentMethods.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                      onChanged: (v) => setState(() => _paymentMethod = v!),
                      decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.payment)),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _promoController,
                      decoration: const InputDecoration(labelText: "Promo Code (Optional)", border: OutlineInputBorder(), prefixIcon: Icon(Icons.discount)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Bar
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
                      onPressed: _confirmBooking,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        minimumSize: const Size(0, 45),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Confirm Booking", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

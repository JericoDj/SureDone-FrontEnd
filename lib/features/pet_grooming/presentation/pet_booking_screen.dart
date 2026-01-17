import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/pet_grooming/domain/pet_models.dart';
import 'package:suredone/core/services/booking_service.dart';
import 'package:suredone/features/activity/domain/activity_item.dart';

class PetBookingScreen extends StatefulWidget {
  final PetGroomer groomer;

  const PetBookingScreen({super.key, required this.groomer});

  @override
  State<PetBookingScreen> createState() => _PetBookingScreenState();
}

class _PetBookingScreenState extends State<PetBookingScreen> {
  final _formKey = GlobalKey<FormState>();

  // Pet Info
  final _furNameController = TextEditingController();
  String? _selectedPetType;
  final _weightController = TextEditingController();
  final _promoController = TextEditingController();

  // Service Selection
  final List<PetService> _selectedServices = [];

  // Date Selection
  DateTime? _selectedDate;

  // Pricing
  double get _basePrice => _selectedServices.fold(0, (sum, s) => sum + s.price);
  
  double get _weightExtra {
    final weight = double.tryParse(_weightController.text) ?? 0;
    // Price per 5kg -> +100 per 5kg block. Formula: floor(weight / 5) * 100
    return (weight / 5).floor() * 100.0;
  }

  double get _totalPrice => _basePrice + _weightExtra;

  @override
  void initState() {
    super.initState();
    // Pre-select Haircut if available as a default
    final haircut = widget.groomer.services.where((s) => s.name == 'Haircut').firstOrNull;
    if (haircut != null) {
      _selectedServices.add(haircut);
    }
  }

  @override
  void dispose() {
    _furNameController.dispose();
    _weightController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  void _onServiceSelected(bool selected, PetService service) {
    setState(() {
      if (selected) {
        // Mutual Exclusion Logic
        if (service.name == 'Creative Groom') {
          _selectedServices.removeWhere((s) => s.name == 'Haircut');
        } else if (service.name == 'Haircut') {
          _selectedServices.removeWhere((s) => s.name == 'Creative Groom');
        }
        _selectedServices.add(service);
      } else {
        _selectedServices.remove(service);
      }
    });
  }

  void _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = now.add(const Duration(days: 1));
    final lastDate = now.add(const Duration(days: 90));

    final picked = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _confirmBooking() {
    if (_formKey.currentState!.validate()) {
       if (_selectedServices.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select at least one service.")));
        return;
      }
      if (_selectedDate == null) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a date.")));
        return;
      }

      final booking = ActivityItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: "Grooming with ${widget.groomer.name}",
        providerName: widget.groomer.name,
        date: "${_selectedDate!.month}/${_selectedDate!.day}",
        price: "₱${_totalPrice.toStringAsFixed(0)}",
        status: ActivityStatus.requested,
        imageUrl: widget.groomer.avatarUrl,
        studentName: _furNameController.text, // Mapping fur name
        gradeLevel: _selectedPetType ?? "Pet", // Mapping pet type
        subjects: _selectedServices.map((s) => s.name).toList(), // Mapping services
        paymentMethod: "Cash", // Default
      );

      BookingService().addBooking(booking);
      
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Booking Requested! Check Activity tab.")));
      context.go('/activity'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Grooming")),
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
                    // Groomer Info
                    Row(
                      children: [
                        CircleAvatar(backgroundImage: NetworkImage(widget.groomer.avatarUrl), radius: 24),
                        const SizedBox(width: 12),
                        Text("Booking with ${widget.groomer.name}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const Divider(height: 32),

                    // Pet Info
                    const Text("Pet Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _furNameController,
                      decoration: const InputDecoration(labelText: "Fur Name", border: OutlineInputBorder(), prefixIcon: Icon(Icons.pets)),
                      validator: (v) => v?.isNotEmpty == true ? null : "Required",
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedPetType,
                            items: widget.groomer.supportedPetTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                            onChanged: (v) => setState(() => _selectedPetType = v),
                            decoration: const InputDecoration(labelText: "Pet Type", border: OutlineInputBorder()),
                            validator: (v) => v != null ? null : "Required",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: "Weight (kg)", border: OutlineInputBorder(), suffixText: "kg"),
                            onChanged: (_) => setState(() {}), // Trigger rebuild for price calc
                            validator: (v) => v?.isNotEmpty == true ? null : "Required",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Services
                    const Text("Select Services", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    ...widget.groomer.services.map((service) {
                      final isSelected = _selectedServices.any((s) => s.name == service.name);
                      
                      // Check if disabled by exclusion
                      bool isDisabled = false;
                      if (service.name == 'Haircut' && _selectedServices.any((s) => s.name == 'Creative Groom')) isDisabled = true;
                      if (service.name == 'Creative Groom' && _selectedServices.any((s) => s.name == 'Haircut')) isDisabled = true;

                      return CheckboxListTile(
                        title: Text(service.name),
                        subtitle: Text("₱${service.price.toStringAsFixed(0)}"),
                        value: isSelected,
                        onChanged: isDisabled ? null : (v) => _onServiceSelected(v ?? false, service),
                        activeColor: Theme.of(context).primaryColor,
                      );
                    }),
                    const SizedBox(height: 24),

                    // Date
                    const Text("Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_selectedDate == null ? "Select Date" : "${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}"),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Promo Code
                    TextFormField(
                      controller: _promoController,
                      decoration: const InputDecoration(labelText: "Promo Code (Optional)", border: OutlineInputBorder(), prefixIcon: Icon(Icons.discount)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Price Breakdown & Confirm
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
                      const Text("Base Price"),
                      Text("₱${_basePrice.toStringAsFixed(0)}"),
                    ],
                  ),
                  if (_weightExtra > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Weight Surcharge (+${_weightController.text}kg)"),
                        Text("₱${_weightExtra.toStringAsFixed(0)}", style: const TextStyle(color: Colors.orange)),
                      ],
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Price:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("₱${_totalPrice.toStringAsFixed(0)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Theme.of(context).primaryColor)),
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

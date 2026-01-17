import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/cleaning/domain/cleaning_models.dart';
import 'package:suredone/core/services/booking_service.dart';
import 'package:suredone/features/activity/domain/activity_item.dart';

class CleaningBookingScreen extends StatefulWidget {
  final Cleaner cleaner;

  const CleaningBookingScreen({super.key, required this.cleaner});

  @override
  State<CleaningBookingScreen> createState() => _CleaningBookingScreenState();
}

class _CleaningBookingScreenState extends State<CleaningBookingScreen> {
  final _formKey = GlobalKey<FormState>();

  // Unit Details
  UnitType _selectedUnit = UnitType.oneBR;
  final _addressController = TextEditingController();

  // Service Selection
  final List<CleaningService> _selectedServices = [];
  bool _bringSupplies = false;

  // Schedule
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Promo
  final _promoController = TextEditingController();
  double _promoDiscount = 0;

  // Pricing Logic
  double get _suppliesFee => _bringSupplies ? 150.0 : 0.0;
  
  double get _basePrice {
     // Multiplier applied to ALL services in this version (simplification) 
     // or we could selective apply only to 'Cleaning' type services.
     // For now: apply to all as bigger units = more laundry/ironing etc usually.
     double subtotal = 0;
     for (var s in _selectedServices) {
       subtotal += s.price;
     }
     return subtotal * _selectedUnit.multiplier;
  }

  double get _totalPrice => _basePrice + _suppliesFee - _promoDiscount;

  @override
  void initState() {
    super.initState();
    // Pre-select General Cleaning if available
    final general = widget.cleaner.services.where((s) => s.name == 'General Cleaning').firstOrNull;
    if (general != null) {
      _selectedServices.add(general);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  void _onServiceSelected(bool selected, CleaningService service) {
    setState(() {
      if (selected) {
        // Mutual Exclusion: Deep vs General
        if (service.name == 'Deep Cleaning') {
          _selectedServices.removeWhere((s) => s.name == 'General Cleaning');
        } else if (service.name == 'General Cleaning') {
          _selectedServices.removeWhere((s) => s.name == 'Deep Cleaning');
        }
        _selectedServices.add(service);
      } else {
        _selectedServices.remove(service);
      }
    });
  }

  void _applyPromo() {
     // Mock Promo Logic
     if (_promoController.text.toUpperCase() == 'FIRST100') {
       setState(() {
         _promoDiscount = 100;
       });
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Promo Applied: ₱100 OFF")));
     } else {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid Promo Code")));
       setState(() {
         _promoDiscount = 0;
       });
     }
  }

  void _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _confirmBooking() {
    if (_formKey.currentState!.validate()) {
       if (_selectedServices.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select at least one service")));
        return;
      }
      if (_selectedDate == null || _selectedTime == null) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select date and time")));
        return;
      }

      // Format Date/Time
      final dateStr = "${_selectedDate!.month}/${_selectedDate!.day}";
      final timeStr = _selectedTime!.format(context);

      final booking = ActivityItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: "Home Cleaning (${_selectedUnit.label})",
        providerName: widget.cleaner.name,
        date: "$dateStr at $timeStr",
        price: "₱${_totalPrice.toStringAsFixed(0)}",
        status: ActivityStatus.requested,
        imageUrl: widget.cleaner.avatarUrl,
        studentName: "Unit: ${_selectedUnit.label}", // Mapping unit info
        gradeLevel: _addressController.text, // Mapping address
        subjects: _selectedServices.map((s) => s.name).toList(), // Services
        paymentMethod: "Cash",
      );

      BookingService().addBooking(booking);
      
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Booking Confirmed!")));
      context.go('/activity'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Cleaning")),
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
                    // Cleaner Info
                     Row(
                      children: [
                        CircleAvatar(backgroundImage: NetworkImage(widget.cleaner.avatarUrl), radius: 24),
                        const SizedBox(width: 12),
                        Text("Service by ${widget.cleaner.name}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const Divider(height: 32),

                    // Unit Details
                    const Text("Unit Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                     DropdownButtonFormField<UnitType>(
                      value: _selectedUnit,
                      items: UnitType.values.map((t) => DropdownMenuItem(
                        value: t, 
                        child: Text("${t.label} (x${t.multiplier})")
                      )).toList(),
                      onChanged: (v) => setState(() => _selectedUnit = v!),
                      decoration: const InputDecoration(labelText: "Unit Type", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                       controller: _addressController,
                       decoration: const InputDecoration(labelText: "Address", border: OutlineInputBorder(), prefixIcon: Icon(Icons.home)),
                       validator: (v) => v?.isNotEmpty == true ? null : "Required",
                    ),
                    const SizedBox(height: 24),

                    // Services
                    const Text("Select Services", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                     ...widget.cleaner.services.map((service) {
                      final isSelected = _selectedServices.any((s) => s.name == service.name);
                      
                      bool isDisabled = false;
                      if (service.name == 'General Cleaning' && _selectedServices.any((s) => s.name == 'Deep Cleaning')) isDisabled = true;
                      if (service.name == 'Deep Cleaning' && _selectedServices.any((s) => s.name == 'General Cleaning')) isDisabled = true;

                      return CheckboxListTile(
                        title: Text(service.name),
                        subtitle: Text("₱${service.price.toStringAsFixed(0)} ${service.isPerRoom ? '/ room' : ''}"),
                        value: isSelected,
                        onChanged: isDisabled ? null : (v) => _onServiceSelected(v ?? false, service),
                        activeColor: Colors.teal,
                      );
                    }),
                    
                    // Supplies Toggle
                    SwitchListTile(
                      title: const Text("I need cleaning supplies"),
                      subtitle: const Text("Add +₱150 for materials"),
                      value: _bringSupplies,
                      activeTrackColor: Colors.teal,
                      inactiveThumbColor: Colors.grey,
                      onChanged: (v) => setState(() => _bringSupplies = v),
                    ),
                    const SizedBox(height: 24),

                    // Date & Time
                     const Text("Schedule", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                              child: Text(_selectedDate == null ? "Select Date" : "${_selectedDate!.month}/${_selectedDate!.day}", style: const TextStyle(fontSize: 16)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                         Expanded(
                          child: InkWell(
                            onTap: () => _selectTime(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                              child: Text(_selectedTime == null ? "Select Time" : _selectedTime!.format(context), style: const TextStyle(fontSize: 16)),
                            ),
                          ),
                        ),
                      ],
                    ),
                     const SizedBox(height: 24),

                    // Promo
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _promoController,
                            decoration: const InputDecoration(labelText: "Promo Code", border: OutlineInputBorder(), prefixIcon: Icon(Icons.discount)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 56, // Match input field height
                          width: 100,
                          child: ElevatedButton(
                            onPressed: _applyPromo,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            child: const Text("Apply"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

           // Breakdown & Confirm
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
                      const Text("Service Total (w/ Multiplier)"),
                      Text("₱${_basePrice.toStringAsFixed(0)}"),
                    ],
                  ),
                  if (_bringSupplies)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Supplies Fee"),
                          const Text("₱150"),
                        ],
                      ),
                    ),
                   if (_promoDiscount > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Promo Discount", style: TextStyle(color: Colors.orange)),
                          Text("-₱${_promoDiscount.toStringAsFixed(0)}", style: const TextStyle(color: Colors.orange)),
                        ],
                      ),
                    ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Grand Total:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("₱${_totalPrice.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.teal)),
                    ],
                  ),
                   const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _confirmBooking,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
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

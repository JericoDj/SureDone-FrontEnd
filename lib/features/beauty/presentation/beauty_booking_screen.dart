import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/beauty/domain/beauty_models.dart';
import 'package:suredone/features/activity/domain/activity_item.dart';
import 'package:suredone/core/services/booking_service.dart';

class BeautyBookingScreen extends StatefulWidget {
  final BeautyProfessional provider;

  const BeautyBookingScreen({super.key, required this.provider});

  @override
  State<BeautyBookingScreen> createState() => _BeautyBookingScreenState();
}

class _BeautyBookingScreenState extends State<BeautyBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Selections
  final Map<BeautyService, ServiceVariant?> _selectedServices = {}; // Service -> Selected Variant (null if no variants)
  bool _isHomeService = false;
  
  // DateTime
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  
  // Address (if home service)
  final _addressController = TextEditingController();
  
  // Promo
  final _promoController = TextEditingController();
  bool _isPromoApplied = false; // Just to track state, logic simplified
  
  @override
  void initState() {
    super.initState();
    // Pre-select first service usually? No, let user pick.
  }
  
  @override
  void dispose() {
    _addressController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  double get _subtotal {
    double total = 0;
    _selectedServices.forEach((service, variant) {
      if (variant != null) {
        total += variant.price;
      } else {
        total += service.basePrice;
      }
    });
    return total;
  }
  
  double get _travelFee => _isHomeService ? widget.provider.homeServiceFee : 0.0;
  
  double get _total => _subtotal + _travelFee; // Add promo logic later if needed
  
  void _toggleService(BeautyService service, bool selected) {
    setState(() {
      if (selected) {
        // If has variants, select first by default
        _selectedServices[service] = service.variants.isNotEmpty ? service.variants.first : null;
      } else {
        _selectedServices.remove(service);
      }
    });
  }
  
  void _changeVariant(BeautyService service, ServiceVariant? variant) {
    setState(() {
      _selectedServices[service] = variant;
    });
  }

  void _confirmBooking() {
    if (_formKey.currentState!.validate()) {
       if (_selectedServices.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select at least one service")));
        return;
      }
      if (_isHomeService && _addressController.text.isEmpty) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter address for home service")));
        return;
      }
      if (_selectedDate == null || _selectedTime == null) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select date and time")));
        return;
      }

      final dateStr = "${_selectedDate!.month}/${_selectedDate!.day}";
      final timeStr = _selectedTime!.format(context);
      
      // Build Subject List with variants
      List<String> subjects = [];
      _selectedServices.forEach((s, v) {
        if (v != null) {
          subjects.add("${s.name} (${v.name})");
        } else {
          subjects.add(s.name);
        }
      });
      
      if (_isHomeService) {
        subjects.add("Home Service (+₱${widget.provider.homeServiceFee.toStringAsFixed(0)})");
      }

      final booking = ActivityItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: "Beauty Appointment",
        providerName: widget.provider.businessName.isNotEmpty ? widget.provider.businessName : widget.provider.name,
        date: "$dateStr at $timeStr",
        price: "₱${_total.toStringAsFixed(0)}",
        status: ActivityStatus.requested,
        imageUrl: widget.provider.avatarUrl,
        studentName: _isHomeService ? "Home Service" : "In-Salon",
        gradeLevel: _isHomeService ? _addressController.text : widget.provider.location,
        subjects: subjects,
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
      appBar: AppBar(title: const Text("Book Appointment")),
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
                    // Location Toggle
                    if (widget.provider.isHomeServiceAvailable)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.purple.withValues(alpha: 0.05),
                        ),
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: const Text("Home Service Request"),
                              subtitle: Text("Add +₱${widget.provider.homeServiceFee.toStringAsFixed(0)} travel fee"),
                              value: _isHomeService,
                              activeColor: Colors.purple,
                              onChanged: (v) => setState(() => _isHomeService = v),
                            ),
                            if (_isHomeService)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: TextFormField(
                                  controller: _addressController,
                                  decoration: const InputDecoration(labelText: "Service Address", prefixIcon: Icon(Icons.location_on)),
                                ),
                              ),
                          ],
                        ),
                      )
                    else 
                       const Card(
                         child: Padding(
                           padding: EdgeInsets.all(12),
                           child: Row(children: [Icon(Icons.store), SizedBox(width: 8), Text("In-Salon Service Only")]),
                         ),
                       ),
                    
                    const SizedBox(height: 24),
                    const Text("Select Services", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 8),
                    
                    ...widget.provider.services.map((service) {
                      final isSelected = _selectedServices.containsKey(service);
                      final hasVariants = service.variants.isNotEmpty;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey[200]!)),
                        child: Column(
                          children: [
                            CheckboxListTile(
                              title: Text(service.name),
                              subtitle: Text("Starts at ₱${service.basePrice.toStringAsFixed(0)}"),
                              value: isSelected,
                              activeColor: Colors.purple,
                              onChanged: (v) => _toggleService(service, v ?? false),
                            ),
                            if (isSelected && hasVariants)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: DropdownButtonFormField<ServiceVariant>(
                                  value: _selectedServices[service],
                                  decoration: const InputDecoration(labelText: "Select Variant / Length", border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                                  items: service.variants.map((v) => DropdownMenuItem(
                                    value: v,
                                    child: Text("${v.name} (+₱${v.price})"), // Actually price is total in our model, or we can treat as add-on. Logic above treats as replacement price.
                                    // Let's check model: ServiceVariant(name, price). I treat it as absolute price in `_subtotal`.
                                    // So Text should be "${v.name} - ₱${v.price}"
                                  )).toList(),
                                  onChanged: (v) => _changeVariant(service, v),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    
                    const SizedBox(height: 24),
                    const Text("Schedule", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),
                     Row(
                      children: [
                        Expanded(child: OutlinedButton(onPressed: () async {
                           final now = DateTime.now();
                           final d = await showDatePicker(context: context, initialDate: now, firstDate: now, lastDate: now.add(const Duration(days: 30)));
                           if(d!=null) setState(() => _selectedDate = d);
                        }, child: Text(_selectedDate == null ? "Select Date" : "${_selectedDate!.month}/${_selectedDate!.day}"))),
                        const SizedBox(width: 12),
                        Expanded(child: OutlinedButton(onPressed: () async {
                           final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                           if(t!=null) setState(() => _selectedTime = t);
                        }, child: Text(_selectedTime == null ? "Select Time" : _selectedTime!.format(context)))),
                      ],
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset:const Offset(0, -2))]),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Subtotal"), Text("₱${_subtotal.toStringAsFixed(0)}")]),
                  if (_isHomeService)
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Travel Fee"), Text("₱${_travelFee.toStringAsFixed(0)}")]),
                  const Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), 
                    Text("₱${_total.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.purple))
                  ]),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _confirmBooking,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                      child: const Text("Confirm Booking", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/repairs/domain/repair_models.dart';
import 'package:suredone/features/activity/domain/activity_item.dart';
import 'package:suredone/core/services/booking_service.dart';

class RepairBookingScreen extends StatefulWidget {
  final RepairProfessional provider;

  const RepairBookingScreen({super.key, required this.provider});

  @override
  State<RepairBookingScreen> createState() => _RepairBookingScreenState();
}

class _RepairBookingScreenState extends State<RepairBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<RepairService> _selectedServices = [];
  
  bool _isEmergency = false;
  final _problemController = TextEditingController();
  final _applianceInfoController = TextEditingController(); // Combines Brand/Model
  final _addressController = TextEditingController();
  final _promoController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _problemController.dispose();
    _applianceInfoController.dispose();
    _addressController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  void _toggleService(RepairService service, bool selected) {
    setState(() {
      if(selected) {
        _selectedServices.add(service);
      } else {
        _selectedServices.remove(service);
      }
    });
  }

  double get _servicesTotal => _selectedServices.fold(0, (sum, s) => sum + s.basePrice);
  double get _emergencyFee => _isEmergency ? widget.provider.emergencyFee : 0.0;
  double get _diagnosticFee => widget.provider.diagnosticFee;
  double get _total => _servicesTotal + _diagnosticFee + _emergencyFee;
  
  void _confirmBooking() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select date and time")));
        return;
      }
      
      final dateStr = "${_selectedDate!.month}/${_selectedDate!.day}";
      final timeStr = _selectedTime!.format(context);
      
      // Build details for Activity payload
      List<String> subjects = _selectedServices.map((s) => s.name).toList();
      subjects.add("Diagnostic Fee (+₱${_diagnosticFee.toStringAsFixed(0)})");
      if (_isEmergency) subjects.add("Emergency Rush (+₱${_emergencyFee.toStringAsFixed(0)})");
      
      final booking = ActivityItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _selectedServices.isNotEmpty ? _selectedServices.first.category.label + " Repair" : "Diagnostic Check",
        providerName: widget.provider.businessName.isNotEmpty ? widget.provider.businessName : widget.provider.name,
        date: "$dateStr at $timeStr",
        price: "₱${_total.toStringAsFixed(0)}",
        status: ActivityStatus.requested,
        imageUrl: widget.provider.avatarUrl,
        studentName: _problemController.text, // Mapping problem to studentName for visibility in list
        gradeLevel: _addressController.text, // Address
        subjects: subjects,
        paymentMethod: "Cash",
      );
      
      BookingService().addBooking(booking);
      
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Booking Request Sent!")));
      context.go('/activity'); 
    }
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(title: const Text("Request Service")),
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
                    // Context Inputs
                    const Text("Issue Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _problemController,
                      decoration: const InputDecoration(
                        labelText: "Describe the problem",
                        hintText: "e.g. AC unit not cooling, Leaking pipe",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      validator: (v) => v!.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _applianceInfoController,
                      decoration: const InputDecoration(
                        labelText: "Appliance Brand & Model (if applicable)",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.info_outline),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    const Text("Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: "Service Address", border: OutlineInputBorder(), prefixIcon: Icon(Icons.location_on)),
                      validator: (v) => v!.isEmpty ? "Required" : null,
                    ),

                    const SizedBox(height: 24),
                    const Text("Select Services", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Text("Diagnostic fee is automatically applied.", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 8),
                    ...widget.provider.services.map((s) => CheckboxListTile(
                      title: Text(s.name),
                      subtitle: Text("₱${s.basePrice.toStringAsFixed(0)}"),
                      value: _selectedServices.contains(s),
                      activeColor: Colors.blueGrey,
                      onChanged: (v) => _toggleService(s, v ?? false),
                    )),
                    
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.orange.withValues(alpha: 0.5))),
                      child: SwitchListTile(
                        title: const Text("Emergency / Rush Service"),
                        subtitle: Text("Need it ASAP? (+₱${widget.provider.emergencyFee.toStringAsFixed(0)})"),
                        value: _isEmergency,
                        activeColor: Colors.orange,
                        onChanged: (v) => setState(() => _isEmergency = v),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    const Text("Schedule", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
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
          
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset:const Offset(0, -2))]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Diagnostic Fee"), Text("₱${_diagnosticFee.toStringAsFixed(0)}")]),
                  if (_servicesTotal > 0)
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Services"), Text("₱${_servicesTotal.toStringAsFixed(0)}")]),
                  if (_isEmergency)
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Emergency Fee", style: TextStyle(color: Colors.orange)), Text("₱${_emergencyFee.toStringAsFixed(0)}", style: const TextStyle(color: Colors.orange))]),
                  const Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text("Total Estimate", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), 
                    Text("₱${_total.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey))
                  ]),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _confirmBooking,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                      child: const Text("Request Booking", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

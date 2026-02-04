import 'package:flutter/material.dart';

/// Returned back to CheckoutSheet after user taps Save.
class DeliveryMethodResult {
  final bool isPickup;

  // Pickup
  final bool pickupNow;
  final DateTime? pickupDate;
  final TimeOfDay? pickupTime;

  // Delivery
  final String houseAddress;
  final String city;
  final String streetNumber;
  final String unit;
  final String instructions;

  const DeliveryMethodResult({
    required this.isPickup,
    required this.pickupNow,
    required this.pickupDate,
    required this.pickupTime,
    required this.houseAddress,
    required this.city,
    required this.streetNumber,
    required this.unit,
    required this.instructions,
  });

  String get shortLabel {
    if (isPickup) {
      if (pickupNow) return "Pick up (now)";
      return "Pick up (scheduled)";
    }
    return "Delivery";
  }
}

/// Put this file here (based on your tree):
/// lib/features/delivery/delivery_method_screen.dart
class DeliveryMethodScreen extends StatefulWidget {
  /// Optional: pass previously selected result so user can edit it.
  final DeliveryMethodResult? initial;

  const DeliveryMethodScreen({super.key, this.initial});

  @override
  State<DeliveryMethodScreen> createState() => _DeliveryMethodScreenState();
}

class _DeliveryMethodScreenState extends State<DeliveryMethodScreen> {
  // Mode
  bool isPickup = true;

  // Pickup
  bool pickupNow = true;
  DateTime? pickupDate;
  TimeOfDay? pickupTime = const TimeOfDay(hour: 8, minute: 0);

  // Delivery controllers
  final houseCtl = TextEditingController();
  final cityCtl = TextEditingController();
  final streetCtl = TextEditingController();
  final unitCtl = TextEditingController();
  final instructionsCtl = TextEditingController();

  @override
  void initState() {
    super.initState();

    final init = widget.initial;
    if (init != null) {
      isPickup = init.isPickup;

      pickupNow = init.pickupNow;
      pickupDate = init.pickupDate;
      pickupTime = init.pickupTime;

      houseCtl.text = init.houseAddress;
      cityCtl.text = init.city;
      streetCtl.text = init.streetNumber;
      unitCtl.text = init.unit;
      instructionsCtl.text = init.instructions;
    }
  }

  @override
  void dispose() {
    houseCtl.dispose();
    cityCtl.dispose();
    streetCtl.dispose();
    unitCtl.dispose();
    instructionsCtl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: pickupDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) setState(() => pickupDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: pickupTime ?? const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) setState(() => pickupTime = picked);
  }

  String _formatDate(DateTime? d) {
    if (d == null) return "Choose date";
    return "${d.day}/${d.month}/${d.year}";
  }

  String _formatTime(TimeOfDay? t) {
    if (t == null) return "Choose time";
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final ap = t.period == DayPeriod.am ? "AM" : "PM";
    return "$h:$m$ap";
  }

  bool get _pickupValid {
    if (!isPickup) return true;
    if (pickupNow) return true;
    return pickupDate != null && pickupTime != null;
  }

  bool get _deliveryValid {
    if (isPickup) return true;
    return houseCtl.text.trim().isNotEmpty &&
        cityCtl.text.trim().isNotEmpty &&
        streetCtl.text.trim().isNotEmpty;
  }

  void _save() {
    if (!_pickupValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please choose pickup date & time.")),
      );
      return;
    }

    if (!_deliveryValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill required delivery fields.")),
      );
      return;
    }

    final result = DeliveryMethodResult(
      isPickup: isPickup,
      pickupNow: isPickup ? pickupNow : false,
      pickupDate: isPickup && !pickupNow ? pickupDate : null,
      pickupTime: isPickup && !pickupNow ? pickupTime : null,
      houseAddress: isPickup ? "" : houseCtl.text.trim(),
      city: isPickup ? "" : cityCtl.text.trim(),
      streetNumber: isPickup ? "" : streetCtl.text.trim(),
      unit: isPickup ? "" : unitCtl.text.trim(),
      instructions: isPickup ? "" : instructionsCtl.text.trim(),
    );

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFFF1DF);
    const ink = Color(0xFF1F120A);
    const border = Color(0xFF2A150A);
    const muted = Color(0xFF9B8F86);
    const fieldFill = Color(0xFFFFF7ED);

    final saveEnabled = isPickup ? _pickupValid : _deliveryValid;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ink),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Delivery Method",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: ink,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 10),
              const Text(
                "CHOOSE DELIVERY METHOD",
                style: TextStyle(
                  letterSpacing: 0.5,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: muted,
                ),
              ),
              const SizedBox(height: 14),

              // Toggle
              Row(
                children: [
                  Expanded(
                    child: _ModeButton(
                      label: "Pick up",
                      selected: isPickup,
                      onTap: () => setState(() => isPickup = true),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _ModeButton(
                      label: "Delivery",
                      selected: !isPickup,
                      onTap: () => setState(() => isPickup = false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Expanded(
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: isPickup
                        ? _PickupSection(
                            key: const ValueKey("pickup"),
                            pickupNow: pickupNow,
                            onToggleNow: () {
                              setState(() {
                                pickupNow = !pickupNow;
                                if (!pickupNow) {
                                  pickupDate ??= DateTime.now();
                                  pickupTime ??= const TimeOfDay(hour: 8, minute: 0);
                                }
                              });
                            },
                            dateText: _formatDate(pickupDate),
                            timeText: _formatTime(pickupTime),
                            enabled: !pickupNow,
                            onPickDate: _pickDate,
                            onPickTime: _pickTime,
                          )
                        : _DeliverySection(
                            key: const ValueKey("delivery"),
                            houseCtl: houseCtl,
                            cityCtl: cityCtl,
                            streetCtl: streetCtl,
                            unitCtl: unitCtl,
                            instructionsCtl: instructionsCtl,
                            border: border,
                            fill: fieldFill,
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: saveEnabled ? _save : _save, // keep _save so it shows message
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCDBAA5),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: border, width: 0.0),
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const border = Color(0xFF2A150A);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFD9CFC6) : const Color(0xFFFFF1DF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1.2),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: selected ? Colors.white : const Color(0xFF1F120A),
            ),
          ),
        ),
      ),
    );
  }
}

class _PickupSection extends StatelessWidget {
  final bool pickupNow;
  final VoidCallback onToggleNow;

  final String dateText;
  final String timeText;
  final bool enabled;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;

  const _PickupSection({
    super.key,
    required this.pickupNow,
    required this.onToggleNow,
    required this.dateText,
    required this.timeText,
    required this.enabled,
    required this.onPickDate,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF1F120A);
    const border = Color(0xFF2A150A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pickup options",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: ink),
        ),
        const SizedBox(height: 14),

        // Scheduled
        InkWell(
          onTap: enabled ? onPickDate : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border, width: 1.2),
            ),
            child: Row(
              children: [
                Text(
                  dateText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: enabled ? ink : Colors.grey,
                  ),
                ),
                const Spacer(),
                Icon(Icons.calendar_month, color: enabled ? ink : Colors.grey),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        InkWell(
          onTap: enabled ? onPickTime : null,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 190,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFD9CFC6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border, width: 1.2),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Text(
                  timeText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: enabled ? ink : Colors.grey,
                  ),
                ),
                const Spacer(),
                Icon(Icons.unfold_more, color: enabled ? ink : Colors.grey),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),

        const SizedBox(height: 22),

        // Pickup now radio
        Row(
          children: [
            const Text(
              "Pickup now",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: ink),
            ),
            const Spacer(),
            InkWell(
              onTap: onToggleNow,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ink, width: 2),
                ),
                child: pickupNow
                    ? Center(
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ink,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),
        Text(
          pickupNow
              ? "Your order will be ready in 10–12 minutes."
              : "Scheduled pickup selected.",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ink),
        ),
      ],
    );
  }
}

class _DeliverySection extends StatelessWidget {
  final TextEditingController houseCtl;
  final TextEditingController cityCtl;
  final TextEditingController streetCtl;
  final TextEditingController unitCtl;
  final TextEditingController instructionsCtl;

  final Color border;
  final Color fill;

  const _DeliverySection({
    super.key,
    required this.houseCtl,
    required this.cityCtl,
    required this.streetCtl,
    required this.unitCtl,
    required this.instructionsCtl,
    required this.border,
    required this.fill,
  });

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF1F120A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Delivery address",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: ink),
        ),
        const SizedBox(height: 14),

        _Label("House Address *"),
        _Field(controller: houseCtl, hint: "House address", border: border, fill: fill),

        const SizedBox(height: 16),
        _Label("City *"),
        _Field(controller: cityCtl, hint: "City", border: border, fill: fill),

        const SizedBox(height: 16),
        _Label("Street Number/Unit *"),
        Row(
          children: [
            Expanded(
              child: _Field(controller: streetCtl, hint: "Street no.", border: border, fill: fill),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _Field(controller: unitCtl, hint: "Unit", border: border, fill: fill),
            ),
          ],
        ),

        const SizedBox(height: 16),
        _Label("Delivery Instructions"),
        _BigField(controller: instructionsCtl, border: border, fill: fill),

        const SizedBox(height: 10),
        const Text(
          "Example: Gate code, ring the door bell etc.",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: ink,
          ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Color border;
  final Color fill;

  const _Field({
    required this.controller,
    required this.hint,
    required this.border,
    required this.fill,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: fill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border, width: 1.2),
        ),
      ),
    );
  }
}

class _BigField extends StatelessWidget {
  final TextEditingController controller;
  final Color border;
  final Color fill;

  const _BigField({
    required this.controller,
    required this.border,
    required this.fill,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 6,
      maxLines: 8,
      decoration: InputDecoration(
        filled: true,
        fillColor: fill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border, width: 1.2),
        ),
      ),
    );
  }
}

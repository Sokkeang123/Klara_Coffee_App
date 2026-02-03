import 'package:flutter/material.dart';

class DeliveryMethodResult {
  final bool isPickup;

  // Pickup options
  final bool pickupNow;
  final DateTime? pickupDate;
  final TimeOfDay? pickupTime;

  // Delivery options
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
}

class DeliveryMethodScreen extends StatefulWidget {
  const DeliveryMethodScreen({super.key});

  @override
  State<DeliveryMethodScreen> createState() => _DeliveryMethodScreenState();
}

class _DeliveryMethodScreenState extends State<DeliveryMethodScreen> {
  bool isPickup = true;

  // pickup state
  bool pickupNow = true;
  DateTime? pickupDate;
  TimeOfDay? pickupTime = const TimeOfDay(hour: 8, minute: 0);

  // delivery state
  final houseCtl = TextEditingController();
  final cityCtl = TextEditingController();
  final streetCtl = TextEditingController();
  final unitCtl = TextEditingController();
  final instructionsCtl = TextEditingController();

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
    if (picked != null) {
      setState(() => pickupDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: pickupTime ?? const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      setState(() => pickupTime = picked);
    }
  }

  void _save() {
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

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // top bar
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
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
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9B8F86),
                ),
              ),
              const SizedBox(height: 14),

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
                  child: isPickup
                      ? _PickupForm(
                          pickupNow: pickupNow,
                          onPickupNowChanged: (v) =>
                              setState(() => pickupNow = v),
                          pickupDate: pickupDate,
                          pickupTime: pickupTime,
                          onPickDate: _pickDate,
                          onPickTime: _pickTime,
                        )
                      : _DeliveryForm(
                          houseCtl: houseCtl,
                          cityCtl: cityCtl,
                          streetCtl: streetCtl,
                          unitCtl: unitCtl,
                          instructionsCtl: instructionsCtl,
                        ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _save,
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

class _PickupForm extends StatelessWidget {
  final bool pickupNow;
  final ValueChanged<bool> onPickupNowChanged;
  final DateTime? pickupDate;
  final TimeOfDay? pickupTime;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;

  const _PickupForm({
    required this.pickupNow,
    required this.onPickupNowChanged,
    required this.pickupDate,
    required this.pickupTime,
    required this.onPickDate,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF1F120A);
    const border = Color(0xFF2A150A);

    String dateText() {
      if (pickupDate == null) return "Choose date";
      return "${pickupDate!.day}/${pickupDate!.month}/${pickupDate!.year}";
    }

    String timeText() {
      if (pickupTime == null) return "Choose time";
      final h = pickupTime!.hourOfPeriod == 0 ? 12 : pickupTime!.hourOfPeriod;
      final m = pickupTime!.minute.toString().padLeft(2, '0');
      final ap = pickupTime!.period == DayPeriod.am ? "AM" : "PM";
      return "$h:$m$ap";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Scheduled pick up\nChoose date",
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: ink),
        ),
        const SizedBox(height: 16),

        // Date box
        InkWell(
          onTap: pickupNow ? null : onPickDate,
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
                  dateText(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: pickupNow ? Colors.grey : ink,
                  ),
                ),
                const Spacer(),
                Icon(Icons.calendar_month,
                    color: pickupNow ? Colors.grey : ink),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          "Choose time",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: ink),
        ),
        const SizedBox(height: 14),

        InkWell(
          onTap: pickupNow ? null : onPickTime,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 170,
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
                  timeText(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: pickupNow ? Colors.grey : ink,
                  ),
                ),
                const Spacer(),
                Icon(Icons.unfold_more,
                    color: pickupNow ? Colors.grey : ink),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),

        const SizedBox(height: 30),

        Row(
          children: [
            const Text(
              "Pickup now",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink),
            ),
            const Spacer(),
            InkWell(
              onTap: () => onPickupNowChanged(!pickupNow),
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

        const SizedBox(height: 14),

        const Text(
          "Your order will be ready in 10–12 minutes.",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ink),
        ),
      ],
    );
  }
}

class _DeliveryForm extends StatelessWidget {
  final TextEditingController houseCtl;
  final TextEditingController cityCtl;
  final TextEditingController streetCtl;
  final TextEditingController unitCtl;
  final TextEditingController instructionsCtl;

  const _DeliveryForm({
    required this.houseCtl,
    required this.cityCtl,
    required this.streetCtl,
    required this.unitCtl,
    required this.instructionsCtl,
  });

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF1F120A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        _Label("House Address *"),
        _Field(controller: houseCtl, hint: "House address"),

        const SizedBox(height: 16),
        _Label("City *"),
        _Field(controller: cityCtl, hint: "City"),

        const SizedBox(height: 16),
        _Label("Street Number/Unit *"),
        Row(
          children: [
            Expanded(child: _Field(controller: streetCtl, hint: "")),
            const SizedBox(width: 16),
            Expanded(child: _Field(controller: unitCtl, hint: "")),
          ],
        ),

        const SizedBox(height: 16),
        _Label("Delivery Instructions:"),
        _BigField(controller: instructionsCtl),

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

  const _Field({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    const border = Color(0xFF2A150A);
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFFFF7ED),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border, width: 1.2),
        ),
      ),
    );
  }
}

class _BigField extends StatelessWidget {
  final TextEditingController controller;

  const _BigField({required this.controller});

  @override
  Widget build(BuildContext context) {
    const border = Color(0xFF2A150A);
    return TextField(
      controller: controller,
      minLines: 6,
      maxLines: 8,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFFF7ED),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border, width: 1.2),
        ),
      ),
    );
  }
}

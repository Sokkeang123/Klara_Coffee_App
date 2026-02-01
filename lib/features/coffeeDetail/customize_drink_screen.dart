import 'package:flutter/material.dart';

class CustomizeDrinkResult {
  final String milk;
  final bool whippedCream;
  final String syrup;

  const CustomizeDrinkResult({
    required this.milk,
    required this.whippedCream,
    required this.syrup,
  });
}

class CustomizeDrinkScreen extends StatefulWidget {
  final String imagePath;

  const CustomizeDrinkScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<CustomizeDrinkScreen> createState() => _CustomizeDrinkScreenState();
}

class _CustomizeDrinkScreenState extends State<CustomizeDrinkScreen> {
  String milk = "Oat Milk";
  bool whippedCream = true;
  String syrup = "Chocolate";

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF2A150A);
    const bgLight = Color(0xFFF6E6D5);
    const titleColor = Color(0xFFF2DFCC);
    const dividerColor = Color(0xFFD9C4AE);
    const textDark = Color(0xFF1F120A);

    return Scaffold(
      backgroundColor: bgLight,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: const [
                Expanded(flex: 45, child: ColoredBox(color: bgDark)),
                Expanded(flex: 55, child: ColoredBox(color: bgLight)),
              ],
            ),

            Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                  child: Row(
                    children: [
                      _TopIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      const Text(
                        "Klara Kafé L’D",
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      _TopIconButton(
                        icon: Icons.favorite_border_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Big image
                SizedBox(
                  height: 240,
                  child: Center(
                    child: Image.asset(
                      widget.imagePath,
                      height: 230,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.local_cafe,
                        size: 90,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 22, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Milk",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _RadioGroup(
                                value: milk,
                                options: const [
                                  "Oat Milk",
                                  "Whole Milk",
                                  "Almond Milk",
                                ],onChanged: (v) => setState(() => milk = v),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: _RadioGroup(
                                value: milk,
                                options: const [
                                  "Skim Milk",
                                  "Soy Milk",
                                ],
                                onChanged: (v) => setState(() => milk = v),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),
                        Container(height: 1, color: dividerColor),
                        const SizedBox(height: 14),

                        const Text(
                          "Size",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 10),

                        _RadioGroupBool(
                          value: whippedCream,
                          trueLabel: "With whipped cream",
                          falseLabel: "Without whipped cream",
                          onChanged: (v) => setState(() => whippedCream = v),
                        ),

                        const SizedBox(height: 14),
                        Container(height: 1, color: dividerColor),
                        const SizedBox(height: 14),

                        const Text(
                          "Syrup",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _RadioGroup(
                                value: syrup,
                                options: const ["Coconut", "Chocolate"],
                                onChanged: (v) => setState(() => syrup = v),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: _RadioGroup(
                                value: syrup,
                                options: const ["Almond", "Vanilla"],
                                onChanged: (v) => setState(() => syrup = v),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: const Color(0xFFEEDCC8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  widget.imagePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.local_cafe,
                                    color: Colors.brown,
                                  ),
                                ),
                              ),),
                            const SizedBox(width: 14),
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                      CustomizeDrinkResult(
                                        milk: milk,
                                        whippedCream: whippedCream,
                                        syrup: syrup,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFCDBAA5),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}

class _RadioGroup extends StatelessWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _RadioGroup({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((label) {
        final selected = value == label;
        return InkWell(
          onTap: () => onChanged(label),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                _RadioDot(selected: selected),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1F120A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _RadioGroupBool extends StatelessWidget {
  final bool value;
  final String trueLabel;
  final String falseLabel;
  final ValueChanged<bool> onChanged;

  const _RadioGroupBool({
    required this.value,
    required this.trueLabel,
    required this.falseLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => onChanged(true),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [_RadioDot(selected: value == true),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    trueLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1F120A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () => onChanged(false),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                _RadioDot(selected: value == false),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    falseLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1F120A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool selected;

  const _RadioDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF1F120A), width: 2),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1F120A),
                ),
              ),
            )
          : null,
    );
  }
}
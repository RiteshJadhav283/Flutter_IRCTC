import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SavedPassengersScreen extends StatefulWidget {
  const SavedPassengersScreen({super.key});

  @override
  State<SavedPassengersScreen> createState() => _SavedPassengersScreenState();
}

class _SavedPassengersScreenState extends State<SavedPassengersScreen> {
  void _openAddPassengerSheet([SavedPassenger? passenger]) {
    final nameController = TextEditingController(text: passenger?.name ?? '');
    final ageController = TextEditingController(text: passenger != null ? passenger.age.toString() : '');
    final idNoController = TextEditingController(text: passenger?.idCardNumber ?? '');
    String gender = passenger?.gender ?? 'M';
    String berthPref = passenger?.berthPreference ?? 'No Preference';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                passenger == null ? 'Add Master Passenger' : 'Edit Passenger',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Passenger Full Name',
                controller: nameController,
                hintText: 'As per Aadhaar / Voter ID',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Age',
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      hintText: 'e.g. 24',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Gender', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: gender,
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(value: 'M', child: Text('Male')),
                                DropdownMenuItem(value: 'F', child: Text('Female')),
                                DropdownMenuItem(value: 'T', child: Text('Transgender')),
                              ],
                              onChanged: (val) {
                                if (val != null) setSheetState(() => gender = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Aadhaar / ID Card Number',
                controller: idNoController,
                hintText: 'e.g. 1234 5678 9012',
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: passenger == null ? 'Save to Master List' : 'Update Passenger',
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty) {
                    final newPassenger = SavedPassenger(
                      id: passenger?.id ?? 'p_${DateTime.now().millisecondsSinceEpoch}',
                      name: nameController.text.trim(),
                      age: int.tryParse(ageController.text.trim()) ?? 25,
                      gender: gender,
                      berthPreference: berthPref,
                      idCardType: 'Aadhaar Card',
                      idCardNumber: idNoController.text.trim(),
                    );
                    context.read<AuthProvider>().addSavedPassenger(newPassenger);
                    Navigator.pop(ctx);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final passengers = auth.user?.savedPassengers ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Saved Passengers (Master List)', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: passengers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people_outline_rounded, size: 48, color: AppColors.textMuted),
                  const SizedBox(height: 12),
                  const Text('No Saved Passengers Yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  const Text('Save frequent travellers for 1-tap fast Tatkal checkout.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: passengers.length,
              itemBuilder: (context, index) {
                final p = passengers[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          p.gender,
                          style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primaryBlue),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                            const SizedBox(height: 2),
                            Text('${p.age} years • ${p.berthPreference}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            if (p.idCardNumber.isNotEmpty)
                              Text('ID: ${p.idCardNumber}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primaryBlue),
                        onPressed: () => _openAddPassengerSheet(p),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.seatOccupied),
                        onPressed: () => auth.deleteSavedPassenger(p.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.borderLight, width: 1.2)),
        ),
        child: CustomButton(
          text: 'Add New Passenger',
          icon: Icons.add_rounded,
          onPressed: () => _openAddPassengerSheet(),
        ),
      ),
    );
  }
}

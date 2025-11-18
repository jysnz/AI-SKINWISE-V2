import 'package:flutter/material.dart';

// --- GLOBAL CONSTANTS ---
const Color _kPrimaryBlue = Color(0xFF1877F2);
const Color _kFilterBlue = Color(0xFF1976D2);

// --- CLINIC DATA MODEL ---
class ClinicData {
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final double distance;
  final bool acceptingPatients;
  final double consultationFee;

  const ClinicData({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.acceptingPatients,
    required this.consultationFee,
  });

  bool get isFree => consultationFee == 0;
}

class Findclinic extends StatefulWidget {
  const Findclinic({super.key});

  @override
  State<Findclinic> createState() => _FindclinicState();
}

class _FindclinicState extends State<Findclinic> {
  double _distanceValue = 8.0;
  bool _acceptingNewPatients = true;
  bool _partneredClinics = false;

  final List<ClinicData> _clinics = [
    ClinicData(
      name: 'Wellness Clinic',
      specialty: 'Cosmetics Dermatology',
      rating: 4.8,
      reviewCount: 234,
      distance: 1.2,
      acceptingPatients: true,
      consultationFee: 0,
    ),
    ClinicData(
      name: "Clinic's Name",
      specialty: 'Surgical Dermatology',
      rating: 4.8,
      reviewCount: 234,
      distance: 1.2,
      acceptingPatients: true,
      consultationFee: 630.0,
    ),
    ClinicData(
      name: "Clinic's Name",
      specialty: 'Pediatric Dermatology',
      rating: 4.8,
      reviewCount: 234,
      distance: 1.2,
      acceptingPatients: true,
      consultationFee: 700.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Find near Clinic',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Section
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _kFilterBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filters Header
                Row(
                  children: [
                    const Icon(Icons.tune, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Filters',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Distance Slider
                Text(
                  'Distance: ${_distanceValue.toInt()} miles',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white.withOpacity(0.3),
                    thumbColor: Colors.white,
                    overlayColor: Colors.white.withOpacity(0.2),
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: _distanceValue,
                    min: 0,
                    max: 50,
                    onChanged: (value) {
                      setState(() {
                        _distanceValue = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // Checkboxes Row
                Row(
                  children: [
                    // Accepting new patients
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: _acceptingNewPatients,
                              onChanged: (value) {
                                setState(() {
                                  _acceptingNewPatients = value ?? false;
                                });
                              },
                              fillColor: MaterialStateProperty.resolveWith(
                                (states) =>
                                    states.contains(MaterialState.selected)
                                        ? Colors.white
                                        : Colors.transparent,
                              ),
                              checkColor: _kFilterBlue,
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Accepting new patients',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Partnered Clinics
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: _partneredClinics,
                              onChanged: (value) {
                                setState(() {
                                  _partneredClinics = value ?? false;
                                });
                              },
                              fillColor: MaterialStateProperty.resolveWith(
                                (states) =>
                                    states.contains(MaterialState.selected)
                                        ? Colors.white
                                        : Colors.transparent,
                              ),
                              checkColor: _kFilterBlue,
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Partnered Clinics',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Clinics Found Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '${_clinics.length} Clinics Found',
              style: TextStyle(
                color: _kPrimaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Clinics List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _clinics.length,
              itemBuilder: (context, index) {
                return ClinicCard(clinic: _clinics[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- CLINIC CARD WIDGET ---
class ClinicCard extends StatelessWidget {
  final ClinicData clinic;

  const ClinicCard({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Clinic Image Placeholder
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),

              // Clinic Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Clinic Name
                    Text(
                      clinic.name,
                      style: const TextStyle(
                        color: _kPrimaryBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Specialty
                    Text(
                      clinic.specialty,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${clinic.rating} (${clinic.reviewCount} views)',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    // Distance
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.black54,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${clinic.distance} miles away',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    // Consultation Fee
                    Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.green,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          clinic.isFree
                              ? 'Consultation fee: FREE'
                              : '₱${clinic.consultationFee.toStringAsFixed(0)} Consultation fee',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Accepting new patients badge
          if (clinic.acceptingPatients) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: _kPrimaryBlue,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Accepting new patients',
                  style: TextStyle(
                    color: _kPrimaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// --- MAIN ENTRY POINT FOR TESTING ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: _kPrimaryBlue,
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: _kPrimaryBlue),
      ),
      home: const Findclinic(),
    );
  }
}

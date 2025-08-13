import 'package:flutter/material.dart';
import '../widgets/navigation.dart';

class GuestLogsScreen extends StatelessWidget {
  const GuestLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const NavigationWidget(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF8FAFC),
                    Color(0xFFE0E7FF),
                    Color(0xFFC7D2FE),
                  ],
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isWide = constraints.maxWidth > 600;
                  double cardWidth =
                      isWide
                          ? (constraints.maxWidth - 48) / 2
                          : constraints.maxWidth;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6366F1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.dashboard,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Condo Manager',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'Dashboard Overview',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Dashboard Cards
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            _buildStatCard(
                              "Active Guests",
                              "1",
                              "Currently checked in",
                              width: cardWidth,
                            ),
                            _buildStatCard(
                              "Total Logs",
                              "11",
                              "All entries",
                              width: cardWidth,
                            ),
                            _buildStatCard(
                              "Requirements",
                              "7",
                              "Special requests",
                              width: cardWidth,
                            ),
                            _buildStatCard(
                              "Completion Rate",
                              "98%",
                              "Request fulfillment",
                              backgroundColor: const Color(0xFF4A6CF7),
                              textColor: Colors.white,
                              width: cardWidth,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Buttons: Guest Management & Recent Activity
                        Row(
                          children: [
                            Expanded(
                              child: _buildOutlinedButton("Guest Management"),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildOutlinedButton("Recent Activity"),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Search + All Status + Add Log inside a Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildSearchField(),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(flex: 2, child: _buildDropdown()),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 1,
                                    child: _buildAddLogButton(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Stat Card
  Widget _buildStatCard(
    String title,
    String value,
    String subtitle, {
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black,
    double? width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.8)),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  // Outlined Button
  Widget _buildOutlinedButton(String label) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label),
    );
  }

  // Search Field
  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search guests, rooms, or sources...",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  // Dropdown
  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: "All Status",
      items:
          ["All Status", "Checked In", "Checked Out"]
              .map(
                (status) =>
                    DropdownMenuItem(value: status, child: Text(status)),
              )
              .toList(),
      onChanged: (value) {},
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  // Add Log Button
  Widget _buildAddLogButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add),
      label: const Text("Add Log"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/navigation.dart';

class InventoryItem {
  final int id;
  final String name;
  final int quantity;
  final int minQuantity;
  final String unit;
  final String status; // 'good' | 'low' | 'critical'

  const InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.minQuantity,
    required this.unit,
    required this.status,
  });

  InventoryItem copyWith({
    int? id,
    String? name,
    int? quantity,
    int? minQuantity,
    String? unit,
    String? status,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      minQuantity: minQuantity ?? this.minQuantity,
      unit: unit ?? this.unit,
      status: status ?? this.status,
    );
  }
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  // Data lists per category
  List<InventoryItem> cleaningSupplies = [
    const InventoryItem(id: 1, name: 'All-Purpose Cleaner', quantity: 12, minQuantity: 5, unit: 'bottles', status: 'good'),
    const InventoryItem(id: 2, name: 'Toilet Paper', quantity: 3, minQuantity: 8, unit: 'rolls', status: 'low'),
    const InventoryItem(id: 3, name: 'Paper Towels', quantity: 15, minQuantity: 6, unit: 'rolls', status: 'good'),
    const InventoryItem(id: 4, name: 'Disinfectant', quantity: 8, minQuantity: 4, unit: 'bottles', status: 'good'),
    const InventoryItem(id: 5, name: 'Vacuum Bags', quantity: 1, minQuantity: 3, unit: 'pcs', status: 'critical'),
  ];

  List<InventoryItem> washables = [
    const InventoryItem(id: 1, name: 'Bath Towels', quantity: 20, minQuantity: 15, unit: 'pcs', status: 'good'),
    const InventoryItem(id: 2, name: 'Hand Towels', quantity: 8, minQuantity: 12, unit: 'pcs', status: 'low'),
    const InventoryItem(id: 3, name: 'Bed Sheets (Queen)', quantity: 16, minQuantity: 10, unit: 'sets', status: 'good'),
    const InventoryItem(id: 4, name: 'Pillowcases', quantity: 25, minQuantity: 20, unit: 'pcs', status: 'good'),
    const InventoryItem(id: 5, name: 'Blankets', quantity: 5, minQuantity: 8, unit: 'pcs', status: 'low'),
  ];

  List<InventoryItem> toiletries = [
    const InventoryItem(id: 1, name: 'Shampoo', quantity: 8, minQuantity: 5, unit: 'bottles', status: 'good'),
    const InventoryItem(id: 2, name: 'Body Soap', quantity: 12, minQuantity: 8, unit: 'bars', status: 'good'),
    const InventoryItem(id: 3, name: 'Toothbrushes', quantity: 2, minQuantity: 6, unit: 'pcs', status: 'critical'),
    const InventoryItem(id: 4, name: 'Towel Freshener', quantity: 4, minQuantity: 3, unit: 'bottles', status: 'good'),
  ];

  // Dialog inputs
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _qtyCtrl = TextEditingController();
  final TextEditingController _minQtyCtrl = TextEditingController();
  final TextEditingController _unitCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    _minQtyCtrl.dispose();
    _unitCtrl.dispose();
    super.dispose();
  }

  String _statusFrom(int quantity, int minQuantity) {
    if (quantity >= minQuantity) return 'good';
    if (quantity <= (minQuantity * 0.3).floor()) return 'critical';
    return 'low';
  }

  double _progress(int quantity, int minQuantity) {
    if (minQuantity <= 0) return 1.0;
    final v = quantity / minQuantity;
    return v.clamp(0.0, 1.0);
  }

  Color _statusBgColor(String status) {
    switch (status) {
      case 'good':
        return const Color(0xFFD1FAE5); // green-100
      case 'low':
        return const Color(0xFFFEF3C7); // yellow-100
      case 'critical':
        return const Color(0xFFFEE2E2); // red-100
      default:
        return const Color(0xFFF3F4F6); // gray-100
    }
  }

  Color _statusTextColor(String status) {
    switch (status) {
      case 'good':
        return const Color(0xFF065F46); // green-800
      case 'low':
        return const Color(0xFF92400E); // yellow-800
      case 'critical':
        return const Color(0xFF991B1B); // red-800
      default:
        return const Color(0xFF1F2937); // gray-800
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'good':
        return Icons.check_circle;
      case 'low':
        return Icons.warning_amber_rounded;
      case 'critical':
        return Icons.warning_amber_rounded;
      default:
        return Icons.inventory_2;
    }
  }

  int get _totalItems => cleaningSupplies.length + washables.length + toiletries.length;

  int get _lowStockItems => [
        ...cleaningSupplies,
        ...washables,
        ...toiletries,
      ].where((i) => i.status == 'low' || i.status == 'critical').length;

  int get _criticalItems => [
        ...cleaningSupplies,
        ...washables,
        ...toiletries,
      ].where((i) => i.status == 'critical').length;

  int _newIdFor(List<InventoryItem> list) =>
      (list.isEmpty ? 0 : list.map((e) => e.id).reduce((a, b) => a > b ? a : b)) + 1;

  void _showAddItemDialog(String category) {
    _nameCtrl.clear();
    _qtyCtrl.clear();
    _minQtyCtrl.clear();
    _unitCtrl.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New ${_categoryLabel(category)}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _qtyCtrl,
                        decoration: const InputDecoration(labelText: 'Current Quantity'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _minQtyCtrl,
                        decoration: const InputDecoration(labelText: 'Minimum Quantity'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _unitCtrl,
                  decoration: const InputDecoration(labelText: 'Unit (e.g., bottles, rolls, pcs)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameCtrl.text.isEmpty ||
                    _qtyCtrl.text.isEmpty ||
                    _minQtyCtrl.text.isEmpty ||
                    _unitCtrl.text.isEmpty) {
                  return;
                }
                final qty = int.tryParse(_qtyCtrl.text) ?? 0;
                final minQty = int.tryParse(_minQtyCtrl.text) ?? 0;
                final status = _statusFrom(qty, minQty);

                setState(() {
                  if (category == 'cleaning') {
                    cleaningSupplies = [
                      ...cleaningSupplies,
                      InventoryItem(
                        id: _newIdFor(cleaningSupplies),
                        name: _nameCtrl.text,
                        quantity: qty,
                        minQuantity: minQty,
                        unit: _unitCtrl.text,
                        status: status,
                      ),
                    ];
                  } else if (category == 'washables') {
                    washables = [
                      ...washables,
                      InventoryItem(
                        id: _newIdFor(washables),
                        name: _nameCtrl.text,
                        quantity: qty,
                        minQuantity: minQty,
                        unit: _unitCtrl.text,
                        status: status,
                      ),
                    ];
                  } else if (category == 'toiletries') {
                    toiletries = [
                      ...toiletries,
                      InventoryItem(
                        id: _newIdFor(toiletries),
                        name: _nameCtrl.text,
                        quantity: qty,
                        minQuantity: minQty,
                        unit: _unitCtrl.text,
                        status: status,
                      ),
                    ];
                  }
                });

                Navigator.of(context).pop();
              },
              child: const Text('Add Item'),
            ),
          ],
        );
      },
    );
  }

  String _categoryLabel(String category) {
    switch (category) {
      case 'cleaning':
        return 'Cleaning Supply';
      case 'washables':
        return 'Washable Item';
      case 'toiletries':
        return 'Toiletry';
    }
    return 'Item';
  }

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
                    Color(0xFFF5F3FF),
                    Color(0xFFE0E7FF),
                  ],
                ),
              ),
              child: DefaultTabController(
                length: 3,
                child: SingleChildScrollView(
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
                                color: const Color(0xFF7C3AED),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.inventory_2,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Inventory Management',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Track supplies and washables',
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

                      // Summary Cards
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isMd = constraints.maxWidth >= 900;
                          final isLg = constraints.maxWidth >= 1200;
                          int columns = 1;
                          if (isLg) {
                            columns = 4;
                          } else if (isMd) {
                            columns = 4; // mimic md:grid-cols-4
                          }
                          return GridView.count(
                            crossAxisCount: columns,
                            childAspectRatio: 2.6,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            children: [
                              _summaryCard(
                                title: 'Total Items',
                                value: '$_totalItems',
                                subtitle: 'All categories',
                                icon: Icons.inventory_2,
                                iconColor: Colors.blue.shade600,
                              ),
                              _summaryCard(
                                title: 'Low Stock',
                                value: '$_lowStockItems',
                                subtitle: 'Need attention',
                                icon: Icons.warning_amber_rounded,
                                iconColor: Colors.orange.shade600,
                              ),
                              _summaryCard(
                                title: 'Critical',
                                value: '$_criticalItems',
                                subtitle: 'Urgent restock',
                                icon: Icons.report_rounded,
                                iconColor: Colors.red.shade600,
                              ),
                              _summaryGradientCard(
                                title: 'Stock Health',
                value: _totalItems == 0
                  ? '0%'
                  : '${(((_totalItems - _lowStockItems) / _totalItems) * 100).round()}%',
                                subtitle: 'Well stocked',
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 8),

                      // Tabs (shadcn/ui style)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            height: 40,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9), // muted background
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: TabBar(
                              isScrollable: false,
                              dividerColor: Colors.transparent,
                              labelColor: const Color(0xFF0F172A), // foreground
                              unselectedLabelColor: const Color(0xFF64748B), // muted-foreground
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                              unselectedLabelStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                              indicator: BoxDecoration(
                                color: Colors.white, // background
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorPadding: EdgeInsets.zero,
                              labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                              tabs: const [
                                Tab(text: 'Cleaning Supplies'),
                                Tab(text: 'Washables'),
                                Tab(text: 'Toiletries'),
                              ],
                            ),
                          ),
                          _tabContent(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.8),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: iconColor)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(icon, size: 14, color: Colors.black38),
                const SizedBox(width: 6),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.black45)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryGradientCard({
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF22C55E), Color(0xFF059669)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: Colors.white70)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 6),
          Row(
            children: const [
              Icon(Icons.check_circle, size: 14, color: Colors.white70),
              SizedBox(width: 6),
              Text('Well stocked', style: TextStyle(fontSize: 11, color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tabContent() {
    return SizedBox(
      height: 1200, // Enough height to render grid within SingleChildScrollView
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(), // Prevent horizontal scrolling
        children: [
          _categorySection('Cleaning Supplies', 'cleaning', cleaningSupplies, (id) {
            setState(() => cleaningSupplies = cleaningSupplies.where((e) => e.id != id).toList());
          }),
          _categorySection('Washables', 'washables', washables, (id) {
            setState(() => washables = washables.where((e) => e.id != id).toList());
          }),
          _categorySection('Toiletries', 'toiletries', toiletries, (id) {
            setState(() => toiletries = toiletries.where((e) => e.id != id).toList());
          }),
        ],
      ),
    );
  }

  Widget _categorySection(
    String title,
    String categoryKey,
    List<InventoryItem> items,
    void Function(int id) onDelete,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth >= 1200) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth >= 900) {
          crossAxisCount = 2;
        }
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              // Section header with Add button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _showAddItemDialog(categoryKey),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Item'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.1,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _itemCard(item, () => onDelete(item.id));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _itemCard(InventoryItem item, VoidCallback onDelete) {
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.8),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(_statusIcon(item.status), size: 18, color: _statusTextColor(item.status)),
                    const SizedBox(width: 8),
                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  ],
                ),
                IconButton(
                  tooltip: 'Delete',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Stock Level', style: TextStyle(fontSize: 12, color: Colors.black54)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _statusBgColor(item.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(fontSize: 11, color: _statusTextColor(item.status), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Current: ${item.quantity} ${item.unit}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                Text('Min: ${item.minQuantity} ${item.unit}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _progress(item.quantity, item.minQuantity),
                minHeight: 8,
                backgroundColor: Colors.black12,
                valueColor: AlwaysStoppedAnimation<Color>(
                  item.status == 'good'
                      ? const Color(0xFF22C55E)
                      : item.status == 'low'
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFFEF4444),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (item.quantity <= item.minQuantity)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '⚠️ Need to restock: ${item.minQuantity - item.quantity} more ${item.unit}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF9A3412)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

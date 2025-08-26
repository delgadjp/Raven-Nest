import '/constants/app_exports.dart';

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

  String _statusFrom(int quantity, int minQuantity) {
    if (quantity >= minQuantity) return 'good';
    if (quantity <= (minQuantity * 0.3).floor()) return 'critical';
    return 'low';
  }

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
    return GradientBackground(
      colors: const [
        Color(0xFFF8FAFC),
        Color(0xFFF5F3FF),
        Color(0xFFE0E7FF),
      ],
      child: Column(
        children: [
          const NavigationWidget(),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Cards using ResponsiveCardGrid
                      ResponsiveCardGrid(
                        children: [
                          SummaryCard(
                            title: 'Total Items',
                            value: '$_totalItems',
                            subtitle: 'All categories',
                            icon: Icons.inventory_2,
                            iconColor: Colors.blue.shade600,
                          ),
                          SummaryCard(
                            title: 'Low Stock',
                            value: '$_lowStockItems',
                            subtitle: 'Need attention',
                            icon: Icons.warning_amber_rounded,
                            iconColor: Colors.orange.shade600,
                          ),
                          SummaryCard(
                            title: 'Critical',
                            value: '$_criticalItems',
                            subtitle: 'Urgent restock',
                            icon: Icons.report_rounded,
                            iconColor: Colors.red.shade600,
                          ),
                          SummaryGradientCard(
                            title: 'Stock Health',
                            value: _totalItems == 0
                              ? '0%'
                              : '${(((_totalItems - _lowStockItems) / _totalItems) * 100).round()}%',
                            subtitle: 'Well stocked',
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Custom Tab Bar
                      CustomTabBar(
                        tabs: const [
                          'Cleaning Supplies',
                          'Washables',
                          'Toiletries',
                        ],
                      ),
                      _tabContent(),
                    ],
                  ),
                ),
              ),
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
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              // Section header with Add button using SectionHeaderWithAction widget
              SectionHeaderWithAction(
                title: title,
                onActionPressed: () => _showAddItemDialog(categoryKey),
              ),
              const SizedBox(height: 24),

              // Use ResponsiveCardGrid for items
              ResponsiveCardGrid(
                children: items.map((item) => InventoryItemCard(
                  name: item.name,
                  quantity: item.quantity,
                  minQuantity: item.minQuantity,
                  unit: item.unit,
                  status: item.status,
                  onDelete: () => onDelete(item.id),
                )).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

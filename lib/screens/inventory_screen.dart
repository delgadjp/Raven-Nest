import '../constants/app_exports.dart';

class InventoryCategory {
  final String id;
  final String name;
  final List<InventoryItem> items;

  const InventoryCategory({
    required this.id,
    required this.name,
    required this.items,
  });

  InventoryCategory copyWith({
    String? id,
    String? name,
    List<InventoryItem>? items,
  }) {
    return InventoryCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
    );
  }
}

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
  // Data organized by categories
  List<InventoryCategory> categories = [
    InventoryCategory(
      id: 'cleaning',
      name: 'Cleaning Supplies',
      items: [
        const InventoryItem(id: 1, name: 'All-Purpose Cleaner', quantity: 12, minQuantity: 5, unit: 'bottles', status: 'good'),
        const InventoryItem(id: 2, name: 'Toilet Paper', quantity: 3, minQuantity: 8, unit: 'rolls', status: 'low'),
        const InventoryItem(id: 3, name: 'Paper Towels', quantity: 15, minQuantity: 6, unit: 'rolls', status: 'good'),
        const InventoryItem(id: 4, name: 'Disinfectant', quantity: 8, minQuantity: 4, unit: 'bottles', status: 'good'),
        const InventoryItem(id: 5, name: 'Vacuum Bags', quantity: 1, minQuantity: 3, unit: 'pcs', status: 'critical'),
      ],
    ),
    InventoryCategory(
      id: 'washables',
      name: 'Washables',
      items: [
        const InventoryItem(id: 1, name: 'Bath Towels', quantity: 20, minQuantity: 15, unit: 'pcs', status: 'good'),
        const InventoryItem(id: 2, name: 'Hand Towels', quantity: 8, minQuantity: 12, unit: 'pcs', status: 'low'),
        const InventoryItem(id: 3, name: 'Bed Sheets (Queen)', quantity: 16, minQuantity: 10, unit: 'sets', status: 'good'),
        const InventoryItem(id: 4, name: 'Pillowcases', quantity: 25, minQuantity: 20, unit: 'pcs', status: 'good'),
        const InventoryItem(id: 5, name: 'Blankets', quantity: 5, minQuantity: 8, unit: 'pcs', status: 'low'),
      ],
    ),
    InventoryCategory(
      id: 'toiletries',
      name: 'Toiletries',
      items: [
        const InventoryItem(id: 1, name: 'Shampoo', quantity: 8, minQuantity: 5, unit: 'bottles', status: 'good'),
        const InventoryItem(id: 2, name: 'Body Soap', quantity: 12, minQuantity: 8, unit: 'bars', status: 'good'),
        const InventoryItem(id: 3, name: 'Toothbrushes', quantity: 2, minQuantity: 6, unit: 'pcs', status: 'critical'),
        const InventoryItem(id: 4, name: 'Towel Freshener', quantity: 4, minQuantity: 3, unit: 'bottles', status: 'good'),
      ],
    ),
  ];

  // Dialog inputs
  final TextEditingController _categoryNameCtrl = TextEditingController();

  @override
  void dispose() {
    _categoryNameCtrl.dispose();
    super.dispose();
  }

  int get _totalItems => categories.fold(0, (sum, category) => sum + category.items.length);

  int get _lowStockItems => categories
      .expand((category) => category.items)
      .where((item) => item.status == 'low' || item.status == 'critical')
      .length;

  int get _criticalItems => categories
      .expand((category) => category.items)
      .where((item) => item.status == 'critical')
      .length;

  String _statusFrom(int quantity, int minQuantity) {
    if (quantity >= minQuantity) return 'good';
    if (quantity <= (minQuantity * 0.3).floor()) return 'critical';
    return 'low';
  }

  int _newIdFor(List<InventoryItem> list) =>
      (list.isEmpty ? 0 : list.map((e) => e.id).reduce((a, b) => a > b ? a : b)) + 1;

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => GenericFormDialog(
        config: DialogConfigurations.addCategory(
          onAdd: (name) {
            setState(() {
              categories.add(InventoryCategory(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                items: [],
              ));
            });
          },
        ),
      ),
    );
  }

  void _showAddItemDialog(String categoryId) {
    final category = categories.firstWhere((cat) => cat.id == categoryId);

    showDialog(
      context: context,
      builder: (context) => GenericFormDialog(
        config: DialogConfigurations.addItem(
          categoryName: category.name,
          onAdd: (name, quantity, minQuantity, unit) {
            final status = _statusFrom(quantity, minQuantity);
            setState(() {
              final categoryIndex = categories.indexWhere((cat) => cat.id == categoryId);
              if (categoryIndex != -1) {
                final updatedItems = [
                  ...categories[categoryIndex].items,
                  InventoryItem(
                    id: _newIdFor(categories[categoryIndex].items),
                    name: name,
                    quantity: quantity,
                    minQuantity: minQuantity,
                    unit: unit,
                    status: status,
                  ),
                ];
                categories[categoryIndex] = categories[categoryIndex].copyWith(items: updatedItems);
              }
            });
          },
        ),
      ),
    );
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
              length: categories.length,
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

                      // Add Category Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.category_outlined,
                                color: Colors.black87,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Add New Category',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Create a custom category for your inventory',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: _showAddCategoryDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add, size: 18),
                                  SizedBox(width: 4),
                                  Text(
                                    'Add',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Dynamic Tab Bar
                      if (categories.isNotEmpty) ...[
                        CustomTabBar(
                          tabs: categories.map((category) => category.name).toList(),
                        ),
                        _tabContent(),
                      ] else ...[
                        Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 64),
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No categories yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add your first category to get started',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
        children: categories.map((category) => 
          _categorySection(
            category.name, 
            category.id, 
            category.items, 
            (itemId) {
              setState(() {
                final categoryIndex = categories.indexWhere((cat) => cat.id == category.id);
                if (categoryIndex != -1) {
                  final updatedItems = categories[categoryIndex].items
                      .where((item) => item.id != itemId)
                      .toList();
                  categories[categoryIndex] = categories[categoryIndex].copyWith(items: updatedItems);
                }
              });
            },
            () {
              setState(() {
                categories.removeWhere((cat) => cat.id == category.id);
              });
            },
          ),
        ).toList(),
      ),
    );
  }

  Widget _categorySection(
    String title,
    String categoryId,
    List<InventoryItem> items,
    void Function(int id) onDelete,
    VoidCallback? onDeleteCategory,
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
                onActionPressed: () => _showAddItemDialog(categoryId),
                onDelete: onDeleteCategory,
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

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
  final String id;
  final String name;
  final int quantity;
  final int minQuantity;
  final String unit;
  final String status; // 'good' | 'low' | 'critical'
  final String categoryId;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.minQuantity,
    required this.unit,
    required this.status,
    required this.categoryId,
  });

  InventoryItem copyWith({
    String? id,
    String? name,
    int? quantity,
    int? minQuantity,
    String? unit,
    String? status,
    String? categoryId,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      minQuantity: minQuantity ?? this.minQuantity,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<InventoryCategory> categories = [];
  int totalItems = 0;
  int lowStockItems = 0;
  int criticalItems = 0;
  bool isLoading = true;
  String? errorMessage;

  // Dialog inputs
  final TextEditingController _categoryNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInventoryData();
  }

  @override
  void dispose() {
    _categoryNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadInventoryData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Load inventory data concurrently
      final results = await Future.wait([
        InventoryService.getInventoryCategories(),
        InventoryService.getInventoryItems(),
        InventoryService.getInventorySummary(),
      ]);

      final categoriesData = results[0] as List<Map<String, dynamic>>;
      final itemsData = results[1] as List<Map<String, dynamic>>;
      final summaryData = results[2] as Map<String, int>;

      // Group items by category
      final Map<String, List<InventoryItem>> itemsByCategory = {};
      
      for (final item in itemsData) {
        final formattedItem = InventoryService.formatInventoryItemForUI(item);
        final categoryId = formattedItem['category_id'] as String;
        
        if (!itemsByCategory.containsKey(categoryId)) {
          itemsByCategory[categoryId] = [];
        }
        
        itemsByCategory[categoryId]!.add(InventoryItem(
          id: formattedItem['id'],
          name: formattedItem['name'],
          quantity: formattedItem['current_stock'],
          minQuantity: formattedItem['min_stock'],
          unit: formattedItem['unit'],
          status: formattedItem['status'],
          categoryId: categoryId,
        ));
      }

      setState(() {
        categories = categoriesData.map((cat) {
          final formattedCategory = InventoryService.formatInventoryCategoryForUI(cat);
          return InventoryCategory(
            id: formattedCategory['id'],
            name: formattedCategory['name'],
            items: itemsByCategory[formattedCategory['id']] ?? [],
          );
        }).toList();
        
        totalItems = summaryData['totalItems'] ?? 0;
        lowStockItems = summaryData['lowStockItems'] ?? 0;
        criticalItems = summaryData['criticalItems'] ?? 0;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading inventory data: $e';
        isLoading = false;
      });
    }
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => GenericFormDialog(
        config: DialogConfigurations.addCategory(
          onAdd: (name) async {
            final success = await InventoryService.addInventoryCategory(name);
            if (success) {
              _loadInventoryData(); // Reload data
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Category added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to add category'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
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
          onAdd: (name, quantity, minQuantity, unit) async {
            final success = await InventoryService.addInventoryItem(
              categoryId: categoryId,
              name: name,
              unit: unit,
              currentStock: quantity,
              minStock: minQuantity,
            );
            
            if (success) {
              _loadInventoryData(); // Reload data
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Item added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to add item'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return GradientBackground(
        colors: const [
          Color(0xFFF8FAFC),
          Color(0xFFF5F3FF),
          Color(0xFFE0E7FF),
        ],
        child: Column(
          children: [
            const NavigationWidget(),
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading inventory data',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadInventoryData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

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
                            value: '$totalItems',
                            subtitle: 'All categories',
                            icon: Icons.inventory_2,
                            iconColor: Colors.blue.shade600,
                          ),
                          SummaryCard(
                            title: 'Low Stock',
                            value: '$lowStockItems',
                            subtitle: 'Need attention',
                            icon: Icons.warning_amber_rounded,
                            iconColor: Colors.orange.shade600,
                          ),
                          SummaryCard(
                            title: 'Critical',
                            value: '$criticalItems',
                            subtitle: 'Urgent restock',
                            icon: Icons.report_rounded,
                            iconColor: Colors.red.shade600,
                          ),
                          SummaryGradientCard(
                            title: 'Stock Health',
                            value: totalItems == 0
                              ? '0%'
                              : '${(((totalItems - lowStockItems) / totalItems) * 100).round()}%',
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
            (itemId) => _deleteInventoryItem(itemId, category.id),
            () => _deleteInventoryCategory(category.id),
          ),
        ).toList(),
      ),
    );
  }

  Widget _categorySection(
    String title,
    String categoryId,
    List<InventoryItem> items,
    void Function(String id) onDelete,
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
                  onIncrease: () => _changeInventoryItemStock(item.id, categoryId, item.quantity, 1),
                  onDecrease: () => _changeInventoryItemStock(item.id, categoryId, item.quantity, -1),
                )).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteInventoryItem(String itemId, String categoryId) async {
    final success = await InventoryService.deleteInventoryItem(itemId);
    
    if (success) {
      _loadInventoryData(); // Reload data
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete item'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteInventoryCategory(String categoryId) async {
    final success = await InventoryService.deleteInventoryCategory(categoryId);
    
    if (success) {
      _loadInventoryData(); // Reload data
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete category. Make sure it has no items.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _changeInventoryItemStock(
    String itemId,
    String categoryId,
    int currentQuantity,
    int delta,
  ) async {
    final newQuantity = currentQuantity + delta;

    if (newQuantity < 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Stock can't go below zero"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final success = await InventoryService.updateInventoryItemStock(itemId, newQuantity);

    if (success) {
      final updatedCategories = categories.map((category) {
        if (category.id != categoryId) return category;

        final updatedItems = category.items.map((item) {
          if (item.id != itemId) return item;

          return item.copyWith(
            quantity: newQuantity,
            status: InventoryService.getStockStatus(newQuantity, item.minQuantity),
          );
        }).toList();

        return category.copyWith(items: updatedItems);
      }).toList();

      final summary = _calculateSummary(updatedCategories);

      setState(() {
        categories = updatedCategories;
        totalItems = summary['totalItems'] ?? totalItems;
        lowStockItems = summary['lowStockItems'] ?? lowStockItems;
        criticalItems = summary['criticalItems'] ?? criticalItems;
      });

      if (mounted) {
        final action = delta >= 0 ? 'increased' : 'decreased';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Stock $action to $newQuantity'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update stock'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Map<String, int> _calculateSummary(List<InventoryCategory> categories) {
    int total = 0;
    int low = 0;
    int critical = 0;

    for (final category in categories) {
      total += category.items.length;

      for (final item in category.items) {
        if (item.quantity <= item.minQuantity) {
          low++;
          final criticalThreshold = item.minQuantity * 3 ~/ 10;
          if (item.quantity <= criticalThreshold) {
            critical++;
          }
        }
      }
    }

    return {
      'totalItems': total,
      'lowStockItems': low,
      'criticalItems': critical,
    };
  }
}

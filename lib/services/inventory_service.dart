import 'supabase_service.dart';

class InventoryService {
  static final _client = SupabaseService.client;

  // Get all inventory categories
  static Future<List<Map<String, dynamic>>> getInventoryCategories() async {
    try {
      final response = await _client
          .from('inventory_categories')
          .select('*')
          .order('name');
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch inventory categories: $e');
    }
  }

  // Get all inventory items with category information
  static Future<List<Map<String, dynamic>>> getInventoryItems() async {
    try {
      final response = await _client
          .from('inventory_items')
          .select('''
            *,
            category:inventory_categories(
              id,
              name
            )
          ''')
          .order('name');
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch inventory items: $e');
    }
  }

  // Get inventory items by category
  static Future<List<Map<String, dynamic>>> getInventoryItemsByCategory(String categoryId) async {
    try {
      final response = await _client
          .from('inventory_items')
          .select('*')
          .eq('category_id', categoryId)
          .order('name');
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch inventory items for category: $e');
    }
  }

  // Get inventory summary data
  static Future<Map<String, int>> getInventorySummary() async {
    try {
      final items = await getInventoryItems();
      
      int totalItems = items.length;
      int lowStockItems = 0;
      int criticalItems = 0;
      
      for (var item in items) {
        final currentStock = item['current_stock'] as int? ?? 0;
        final minStock = item['min_stock'] as int? ?? 0;
        
        if (currentStock <= minStock) {
          lowStockItems++;
          // Critical if stock is 30% or less of minimum
          if (currentStock <= (minStock * 0.3).floor()) {
            criticalItems++;
          }
        }
      }
      
      return {
        'totalItems': totalItems,
        'lowStockItems': lowStockItems,
        'criticalItems': criticalItems,
      };
    } catch (e) {
      throw Exception('Failed to fetch inventory summary: $e');
    }
  }

  // Add new inventory category
  static Future<bool> addInventoryCategory(String name) async {
    try {
      await _client
          .from('inventory_categories')
          .insert({
            'name': name,
          });
      
      return true;
    } catch (e) {
      print('Error adding inventory category: $e');
      return false;
    }
  }

  // Add new inventory item
  static Future<bool> addInventoryItem({
    required String categoryId,
    required String name,
    required String unit,
    required int currentStock,
    required int minStock,
  }) async {
    try {
      await _client
          .from('inventory_items')
          .insert({
            'category_id': categoryId,
            'name': name,
            'unit': unit,
            'current_stock': currentStock,
            'min_stock': minStock,
          });
      
      return true;
    } catch (e) {
      print('Error adding inventory item: $e');
      return false;
    }
  }

  // Update inventory item stock
  static Future<bool> updateInventoryItemStock(String itemId, int newStock) async {
    try {
      await _client
          .from('inventory_items')
          .update({'current_stock': newStock})
          .eq('id', itemId);
      
      return true;
    } catch (e) {
      print('Error updating inventory item stock: $e');
      return false;
    }
  }

  // Delete inventory item
  static Future<bool> deleteInventoryItem(String itemId) async {
    try {
      await _client
          .from('inventory_items')
          .delete()
          .eq('id', itemId);
      
      return true;
    } catch (e) {
      print('Error deleting inventory item: $e');
      return false;
    }
  }

  // Delete inventory category
  static Future<bool> deleteInventoryCategory(String categoryId) async {
    try {
      // First check if category has items
      final items = await getInventoryItemsByCategory(categoryId);
      if (items.isNotEmpty) {
        throw Exception('Cannot delete category with existing items');
      }
      
      await _client
          .from('inventory_categories')
          .delete()
          .eq('id', categoryId);
      
      return true;
    } catch (e) {
      print('Error deleting inventory category: $e');
      return false;
    }
  }

  // Helper method to determine stock status
  static String getStockStatus(int currentStock, int minStock) {
    if (currentStock >= minStock) return 'good';
    if (currentStock <= (minStock * 0.3).floor()) return 'critical';
    return 'low';
  }

  // Format inventory item for UI
  static Map<String, dynamic> formatInventoryItemForUI(Map<String, dynamic> item) {
    final currentStock = item['current_stock'] as int? ?? 0;
    final minStock = item['min_stock'] as int? ?? 0;
    
    return {
      'id': item['id'],
      'name': item['name'] ?? '',
      'unit': item['unit'] ?? '',
      'current_stock': currentStock,
      'min_stock': minStock,
      'status': getStockStatus(currentStock, minStock),
      'category_id': item['category_id'],
      'category_name': item['category']?['name'] ?? '',
    };
  }

  // Format inventory category for UI
  static Map<String, dynamic> formatInventoryCategoryForUI(Map<String, dynamic> category) {
    return {
      'id': category['id'],
      'name': category['name'] ?? '',
      'created_at': category['created_at'],
    };
  }
}

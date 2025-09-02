import '../../constants/app_exports.dart';

class PlatformTile extends StatelessWidget {
  final String name;
  final String initial;
  final Color color;
  final String status;
  final bool isConnected;
  final VoidCallback? onSync;
  final VoidCallback? onConfig;
  final VoidCallback? onConnect;

  const PlatformTile({
    super.key,
    required this.name,
    required this.initial,
    required this.color,
    required this.status,
    required this.isConnected,
    this.onSync,
    this.onConfig,
    this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isConnected ? color.withOpacity(0.2) : Colors.grey.shade200,
          width: isConnected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.8),
                      color,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        fontSize: 18,
                        letterSpacing: -0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isConnected ? const Color(0xFF10B981) : Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isConnected ? 'Connected' : 'Disconnected',
                          style: TextStyle(
                            fontSize: 13,
                            color: isConnected ? const Color(0xFF059669) : Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildActions() {
    if (isConnected) {
      return Row(
        children: [
          Expanded(
            child: ActionButton(
              text: 'Sync',
              onPressed: onSync,
              isOutlined: false,
              isFullWidth: true,
              backgroundColor: color,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ActionButton(
              text: 'Config',
              onPressed: onConfig,
              isOutlined: true,
              isFullWidth: true,
              textColor: color,
              borderColor: color,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: ActionButton(
          text: 'Connect',
          onPressed: onConnect,
          isOutlined: false,
          isFullWidth: true,
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      );
    }
  }
}

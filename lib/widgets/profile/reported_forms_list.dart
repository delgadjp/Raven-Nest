import '../../core/app_export.dart';

class ReportedFormsList extends StatelessWidget {
  final List<Map<String, String>> allCaseData = [
    {
      'name': 'MISSING: Maria Santos',
      'caseNumber': '12345',
      'dateCreated': '03/15/2024',
      'dateClosed': '03/22/2024',
    },
    {
      'name': 'MISSING: Roberto Cruz',
      'caseNumber': '12346',
      'dateCreated': '03/16/2024',
      'dateClosed': '03/23/2024',
    },
    {
      'name': 'MISSING: Ana Reyes',
      'caseNumber': '12347',
      'dateCreated': '03/17/2024',
      'dateClosed': '03/24/2024',
    },
    {
      'name': 'MISSING: Pedro Lim',
      'caseNumber': '12348',
      'dateCreated': '03/18/2024',
      'dateClosed': '03/25/2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: allCaseData.length,
      itemBuilder: (context, index) {
        final caseData = allCaseData[index];

        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                Container(
                  height: 4,
                  color: Colors.red.shade700,
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              ImageConstant.pic,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  caseData['name']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                _buildInfoRow(Icons.calendar_today, 'Date Created: ${caseData['dateCreated']}'),
                                _buildInfoRow(Icons.event_available, 'Date Case Closed: ${caseData['dateClosed']}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.amber.shade400),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.pending, size: 16, color: Colors.amber.shade900),
                                SizedBox(width: 4),
                                Text(
                                  'Pending',
                                  style: TextStyle(
                                    color: Colors.amber.shade900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade900,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrackCaseScreen(caseData: caseData),
                                ),
                              );
                            },
                            icon: Icon(Icons.track_changes, size: 18),
                            label: Text('Track Case'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
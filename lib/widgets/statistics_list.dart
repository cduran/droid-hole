import 'package:flutter/material.dart';

import 'package:droid_hole/functions/conversions.dart';

class StatisticsList extends StatelessWidget {
  final Map<String, dynamic>? data1;
  final Map<String, dynamic>? data2;
  final String countLabel;

  const StatisticsList({
    Key? key,
    required this.data1,
    required this.data2,
    required this.countLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget _generateList(Map<String, int> values, String label) {
      final topQueriesList = convertFromMapToList(values);
      int totalHits = 0;
      for (var item in topQueriesList) {
        totalHits = totalHits + item['value'].toInt() as int;
      }

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            const SizedBox(height: 20),
            ...topQueriesList.map((item) => Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: width - 170,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['label'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "$countLabel ${item['value'].toInt().toString()}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 90,
                    child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        Container(
                          width: 90,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        Container(
                          width: (((item['value']*100)/totalHits)*90)/100,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )).toList()
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (data1 != null) 
            _generateList(
              data1!['data'], 
              data1!['label']
            ),
          if (data1 != null && data2 != null) ...[
            Container(
              width: double.maxFinite,
              height: 1,
              color: Colors.black12,
            ),
          ],
          if (data2 != null) 
            _generateList(
              data2!['data'], 
              data2!['label']
            ),
        ],
      ),
    );
  }
}
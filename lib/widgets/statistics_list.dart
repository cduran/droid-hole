import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:droid_hole/widgets/custom_pie_chart.dart';
import 'package:droid_hole/widgets/no_data_chart.dart';
import 'package:droid_hole/widgets/pie_chart_legend.dart';

import 'package:droid_hole/providers/filters_provider.dart';
import 'package:droid_hole/providers/app_config_provider.dart';
import 'package:droid_hole/functions/conversions.dart';

class StatisticsList extends StatelessWidget {
  final Map<String, dynamic> data1;
  final Map<String, dynamic> data2;
  final String countLabel;
  final String type;

  const StatisticsList({
    Key? key,
    required this.data1,
    required this.data2,
    required this.countLabel,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);
    final filtersProvider = Provider.of<FiltersProvider>(context);

    final width = MediaQuery.of(context).size.width;

    void navigateFilter(String value) {
      if (type == 'clients') {
        final isContained = filtersProvider.totalClients.where((client) => value.contains(client)).toList();
        if (isContained.isNotEmpty) {
          filtersProvider.setSelectedClients([isContained[0]]);
          appConfigProvider.setSelectedTab(2);
        }
      }
      if (type == 'domains') {
        filtersProvider.setSelectedDomain(value);
        appConfigProvider.setSelectedTab(2);
      }
    }

    Widget listViewMode(List<Map<String, dynamic>> values) {
      int totalHits = 0;
      for (var item in values) {
        totalHits = totalHits + item['value'].toInt() as int;
      }

      return Column(
        children: [
          ...values.map((item) => Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => navigateFilter(item['label']),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width - 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['label'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            style: const TextStyle(
                              fontSize: 15
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
                              color: Theme.of(context).dividerColor,
                              borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                          Container(
                            width: (((item['value']*100)/totalHits)*90)/100,
                            height: (((item['value']*100)/totalHits)*90)/100 < 3
                              ? ((((item['value']*100)/totalHits)*90)/100)*3
                              : 10,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(
                                topRight: const Radius.circular(10),
                                bottomRight: const Radius.circular(10),
                                topLeft: (((item['value']*100)/totalHits)*90)/100 > 7
                                  ? const Radius.circular(10) 
                                  : const Radius.circular(0),
                                bottomLeft: (((item['value']*100)/totalHits)*90)/100 > 7
                                  ? const Radius.circular(10) 
                                  : const Radius.circular(0),
                              )
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )).toList()
        ],
      );
    }

    Widget pieChertViewMode(List<Map<String, dynamic>> values) {
      Map<String, double> items = {};
      Map<String, int> legend = {};
      for (var item in values) {
        items = {
          ...items,
          item['label']: item['value'].toDouble()
        };
        legend = {
          ...legend,
          item['label']: item['value'].toInt()
        };
      }
      return Column(
        children: [
          const SizedBox(height: 10),
          CustomPieChart(
            data: items
          ),
          const SizedBox(height: 20),
          PieChartLegend(
            data: legend,
            onValueTap: (value) => navigateFilter(value),
          ),
          const SizedBox(height: 10),
        ],
      );
    }

    Widget generateList(Map<String, int> values, String label) {
      final topQueriesList = convertFromMapToList(values);
      
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.black12,
              )
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          appConfigProvider.statisticsVisualizationMode == 0
            ? listViewMode(topQueriesList)
            : pieChertViewMode(topQueriesList)
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          data1['data'] != null 
            ? generateList(
                data1['data'], 
                data1['label']
              )
            : NoDataChart(
              topLabel: data1['label']
            ),
          if (data1['data'] != null && data2['data'] != null) ...[
            Container(
              width: double.maxFinite,
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ],
          data2['data'] != null
            ? generateList(
                data2['data'], 
                data2['label']
              )
            : NoDataChart(
              topLabel: data2['label']
            ),
        ],
      ),
    );
  }
}
import 'package:advance_math/advance_math.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:raw_gnss/gnss_status_model.dart';
import 'package:raw_gnss/raw_gnss.dart';
import 'package:skyplot/skyplot.dart';

class SkyPlotGNSS extends StatefulWidget {
  SkyPlotGNSS({
    super.key,
    required this.rawGnss,
    required this.hasPermissions,
    SkyPlotOptions? options,
  }) : options = options ?? SkyPlotOptions();

  final RawGnss rawGnss;
  final bool hasPermissions;
  final SkyPlotOptions? options;

  @override
  State<SkyPlotGNSS> createState() => _SkyPlotGNSSState();
}

class _SkyPlotGNSSState extends State<SkyPlotGNSS> {
  List<SkyData> convertStatusToSkyData(List<Status> statuses) {
    return statuses.map((status) {
      String? category;

      switch (status.constellationType) {
        case 1:
          category = "GPS";
          break;
        case 2:
          category = "IRNSS";
          break;
        case 3:
          category = "GLONASS";
          break;
        case 4:
          category = "QZSS";
          break;
        case 5:
          category = "BeiDou";
          break;
        case 6:
          category = "GALILEO";
          break;
        default:
          category = "Unknown";
          break;
      }

      return SkyData(
        azimuthDegrees: status.azimuthDegrees,
        category: category,
        elevationDegrees: status.elevationDegrees,
        id: status.svid?.toString(),
        usedInFix: status.usedInFix,
      );
    }).toList();
  }

  (String, Flag) getConstellation(int constellationType) {
    double flagSize = 50.0;
    switch (constellationType) {
      case 1:
        return ("GPS", Flag(Flags.united_states_of_america, size: flagSize));
      case 2:
        return ("IRNSS", Flag(Flags.india, size: flagSize));
      case 3:
        return ("GLONASS", Flag(Flags.russia, size: flagSize));
      case 4:
        return ("QZSS", Flag(Flags.japan, size: flagSize));
      case 5:
        return ("BeiDou", Flag(Flags.china, size: flagSize));
      case 6:
        return ("GALILEO", Flag(Flags.european_union, size: flagSize));

      default:
        return ("Unknown", Flag(Flags.ghana, size: flagSize));
    }
  }

  Map<String, Widget> createConstellationMap() {
    var constellationTypes = [1, 2, 3, 4, 5, 6, 0];

    return {
      for (var item in constellationTypes)
        getConstellation(item).$1: getConstellation(item).$2
    };
  }

  @override
  Widget build(BuildContext context) {
    var deviceOrientation = MediaQuery.of(context).orientation;

    return SizedBox(
      height: 460,
      width: deviceOrientation == Orientation.portrait ? double.infinity : 400,
      child: Card(
        elevation: 2.0,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: widget.hasPermissions
            ? StreamBuilder<GnssStatusModel>(
                stream: widget.rawGnss.gnssStatusEvents,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return _loadingSpinner();
                  } else {
                    var skyData =
                        convertStatusToSkyData(snapshot.data!.status!);

                    return Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Expanded(
                            child: SkyPlot(
                              skyData: skyData,
                              options: widget.options!,
                              categories: createConstellationMap(),
                            ),
                          ),
                          Container(
                            height: 60,
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(8),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color!),
                            ),
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    ...[1, 2, 3, 4, 5, 6, 0].map((index) {
                                      var (name, flag) =
                                          getConstellation(index);
                                      return SizedBox(
                                        width: 80,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SkyObject(
                                                        skyData: skyData.firstWhere(
                                                            (element) =>
                                                                element
                                                                    .category ==
                                                                index
                                                                    .toString(),
                                                            orElse: () =>
                                                                SkyData(
                                                                  // Provide default values for SkyData
                                                                  azimuthDegrees:
                                                                      0.0,
                                                                  category: index
                                                                      .toString(),
                                                                  elevationDegrees:
                                                                      0.0,
                                                                  id: "Unknown",
                                                                  usedInFix:
                                                                      true,
                                                                )),
                                                        options:
                                                            widget.options!,
                                                        size: 15.0,
                                                        child: flag,
                                                      ),
                                                      const SizedBox(
                                                          width: 8.0),
                                                      Text(index
                                                          .toString()) // Count
                                                    ],
                                                  ),
                                                  const SizedBox(height: 3.0),
                                                  Text(name),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).insertBetween(const SizedBox(
                                        child: VerticalDivider())),
                                  ],
                                )),
                          )
                        ],
                      ),
                    );
                  }
                })
            : _loadingSpinner(),
      ),
    );
  }

  Widget _loadingSpinner() => const Center(child: CircularProgressIndicator());
}

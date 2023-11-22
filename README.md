# SkyPlot Flutter Package

SkyPlot is a versatile Flutter library crafted to visualize positional data in a dynamic sky plot interface. It's not just limited to GNSS satellite positions but can also be adapted for various other applications like radar maps, device availability scanning, and more. Its flexibility makes it suitable for a wide range of use cases.

## Features

- **Multi-Purpose Visualization**: Ideal for displaying positional data in 2D plots, from satellites to local devices.
- **Customizable Interface**: Tailor the appearance to fit the needs of your application, with options for colors, icons, and more.
- **Adaptive and Responsive**: Seamlessly adapts to different screen sizes and orientations.
- **Interactive and Informative**: Provides interactive elements to engage users and display detailed information.

## Getting Started

Add SkyPlot to your Flutter project by including it in your dependencies:

```yaml
dependencies:
  skyplot: any
```

Import SkyPlot in your Dart code:

```dart
import 'package:skyplot/skyplot.dart';
```

## Usage

Create a SkyPlot widget by providing it with data and configuration:

```dart
SkyPlot(
  skyData: yourDataList,
  categories: yourCategoryMap,
  options: SkyPlotOptions(),
)
```

### SkyData

`SkyData` is a versatile data structure that represents each item in the plot:

```dart
SkyData(
  azimuthDegrees: 100,
  elevationDegrees: 50,
  category: 'CategoryName',
  id: 'UniqueID',
  usedInFix: true, // or false depending on the context
)
```

### Customization

Configure the appearance and behavior of your sky plot:

```dart
SkyPlotOptions(
  baseRadiusInFix: 8.0,
  baseRadiusNotInFix: 6.0,
  azimuthDivisions: 30,
  // ... other customizable options ...
)
```

## Example Applications

- **Satellite Tracking**: Visualize satellites in orbit.
- **Radar Mapping**: Display radar sweeps and detected objects.
- **Device Scanning**: Show available devices in a certain range.

## Contributing

Your contributions to improve or extend SkyPlot are highly appreciated. Please refer to our contributing guidelines for more information.

## Author

Charles Gameti: [gameticharles@GitHub][github_cg].

[github_cg]: https://github.com/gameticharles

## License

This library is provided under the
[Apache License - Version 2.0][apache_license].

[apache_license]: https://www.apache.org/licenses/LICENSE-2.0.txt

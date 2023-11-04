class Utils {
  ///https://github.com/brutalzinn/app-laser-cat/blob/dev/app/lib/utils.dart
  ///Remap like Arduino MAP method to equality with plan cartesian and servo motor angule from 0 to 180.
  static double remapper(num value, num fromLow, num fromHigh, num toLow, num toHigh) {
    return (value - fromLow) * (toHigh - toLow) / (fromHigh - fromLow) + toLow;
  }
}

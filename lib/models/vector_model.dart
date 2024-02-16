/// ## [VectorModel]
/// A vector model that has the same interface as [Vector3],
///
/// but is used by [GyroProvider] on its own.
///
/// ---
///
/// The toString method is represented to 17 decimal places,
/// but the actual data is stored to the maximum accuracy provided by the device.
class VectorModel {
  /// Vector along the x-axis of type double
  final double x;

  /// Vector along the y-axis of type double
  final double y;

  /// Vector along the z-axis of type double
  final double z;

  /// ## [VectorModel]
  /// A vector model that has the same interface as [Vector3],
  ///
  /// but is used by [GyroProvider] on its own.
  ///
  /// ---
  ///
  /// The toString method is represented to 17 decimal places,
  /// but the actual data is stored to the maximum accuracy provided by the device.
  VectorModel(this.x, this.y, this.z);

  @override
  String toString() =>
      '[Vector3] x: ${x.toStringAsFixed(17).padLeft(20, ' ')}, y: ${y.toStringAsFixed(17).padLeft(20, ' ')}, z: ${z.toStringAsFixed(17).padLeft(20, ' ')}';

  @override
  // ignore: hash_and_equals
  bool operator ==(covariant VectorModel other) {
    if (x != other.x) return false;
    if (y != other.y) return false;
    if (z != other.z) return false;
    return true;
  }
}

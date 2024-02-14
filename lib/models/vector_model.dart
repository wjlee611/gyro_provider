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
  final double x;
  final double y;
  final double z;

  VectorModel(this.x, this.y, this.z);

  @override
  String toString() =>
      '[Vector3] x: ${x.toStringAsFixed(17).padLeft(20, ' ')}, y: ${y.toStringAsFixed(17).padLeft(20, ' ')}, z: ${z.toStringAsFixed(17).padLeft(20, ' ')}';
}

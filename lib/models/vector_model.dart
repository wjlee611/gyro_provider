class VectorModel {
  final double x;
  final double y;
  final double z;

  VectorModel(this.x, this.y, this.z);

  @override
  String toString() =>
      '[Vector3] x: ${x.toStringAsFixed(17).padLeft(20, ' ')}, y: ${y.toStringAsFixed(17).padLeft(20, ' ')}, z: ${z.toStringAsFixed(17).padLeft(20, ' ')}';
}

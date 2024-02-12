import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:gyro_provider/models/vector_model.dart';

typedef MultiStreamWidgetBuilder<T> = Widget Function(
  BuildContext context,
  List<VectorModel> snapshots,
);

class MultiStreamBuilder extends StatefulWidget {
  final List<Stream<VectorModel>> streams;
  final MultiStreamWidgetBuilder builder;

  const MultiStreamBuilder({
    super.key,
    required this.streams,
    required this.builder,
  });

  @override
  State<MultiStreamBuilder> createState() => _MultiStreamBuilderState();
}

class _MultiStreamBuilderState extends State<MultiStreamBuilder> {
  final List<StreamSubscription<VectorModel>> _subscriptions = [];
  final List<VectorModel> _snapshots = [];

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(MultiStreamBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.streams != widget.streams) {
      _unsubscribe();
      _subscribe();
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    for (int idx = 0; idx < widget.streams.length; idx++) {
      _snapshots.add(VectorModel(0, 0, 0));
      final subscription = widget.streams[idx].listen(
        (VectorModel data) {
          setState(() {
            _snapshots[idx] = data;
          });
        },
        onError: (Object error, StackTrace stackTrace) {
          setState(() {});
        },
        onDone: () {
          setState(() {});
        },
      );
      _subscriptions.add(subscription);
    }
  }

  void _unsubscribe() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    _subscriptions.clear();
    _snapshots.clear();
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        _snapshots,
      );
}

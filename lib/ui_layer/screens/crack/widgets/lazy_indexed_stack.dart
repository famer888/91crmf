import 'package:flutter/material.dart';

class LazyIndexedStack extends StatefulWidget {
  final int index;
  final List<WidgetBuilder> builders;

  const LazyIndexedStack({
    super.key,
    required this.index,
    required this.builders,
  });

  @override
  State<LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  late final List<Widget?> _children;

  @override
  void initState() {
    super.initState();
    _children = List<Widget?>.filled(widget.builders.length, null);
    _buildChild(widget.index);
  }

  @override
  void didUpdateWidget(covariant LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _buildChild(widget.index);
  }

  void _buildChild(int index) {
    if (_children[index] == null) {
      _children[index] = widget.builders[index](context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.index,
      children: List.generate(
        _children.length,
        (i) => _children[i] ?? const SizedBox.shrink(),
      ),
    );
  }
}

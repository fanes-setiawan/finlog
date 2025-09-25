import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputQty extends StatefulWidget {
  final void Function(int newQty) onQtyChanged;
  final void Function() onAdd;
  final void Function() onRemove;
  final TextEditingController controller;
  final double? width;
  const InputQty({
    super.key,
    required this.onQtyChanged,
    required this.onAdd,
    required this.onRemove,
    required this.controller,
    this.width,
  });

  @override
  State<InputQty> createState() => _InputQtyState();
}

class _InputQtyState extends State<InputQty> {
  Timer? _timer;
  Timer? _timerOnTap;
  DateTime? _pressStartTime;
  Duration _currentInterval = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onTextChanged(String value) {
    final newQty = int.tryParse(value) ?? 0;
    widget.onQtyChanged(newQty);
  }

  void _startLongPress(
    void Function() onTap, {
    void Function()? resetter,
  }) {
    _pressStartTime = DateTime.now();
    _timer?.cancel();
    _timerOnTap?.cancel();

    _timerOnTap = Timer.periodic(_currentInterval, (timer) {
      onTap();
    });

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      // onTap(); // Call the long press function
      // Calculate how long the button has been pressed
      final elapsed = DateTime.now().difference(_pressStartTime!).inMilliseconds;
      debugPrint('🔥 input_qty:54 ~ elapsed: $elapsed');
      // Update interval based on press duration
      Duration newInterval;
      if (elapsed < 1000) {
        newInterval = const Duration(milliseconds: 200); // Initial: 500ms
      } else if (elapsed < 2000) {
        newInterval = const Duration(milliseconds: 100); // After 1s: 300ms
      } else if (elapsed < 3000) {
        newInterval = const Duration(milliseconds: 75); // After 2s: 150ms
      } else {
        if (resetter != null) {
          resetter();
          _stopLongPress();
          return;
        } else {
          newInterval = const Duration(milliseconds: 50);
        }
      }
      // Only restart timer if interval has changed
      if (newInterval != _currentInterval) {
        _currentInterval = newInterval;
        debugPrint('🔥 input_qty:72 ~ newInterval: $newInterval');
        _timerOnTap?.cancel();
        _timerOnTap = Timer.periodic(_currentInterval, (t) {
          onTap();
        });
      }
    });
  }

  void _stopLongPress() {
    _timer?.cancel();
    _timerOnTap?.cancel();
    _timer = null;
    _pressStartTime = null;
    _currentInterval = const Duration(milliseconds: 500);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: widget.width ?? 250.r,
          height: 40.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Tombol Kurang
              GestureDetector(
                // onLongPress: () {
                //   widget.controller.clear();
                //   widget.onQtyChanged(0);
                // },
                onLongPressStart: (details) {
                  _startLongPress(
                    () {
                      widget.onRemove();
                    },
                    resetter: () {
                      widget.controller.clear();
                      widget.onQtyChanged(0);
                    },
                  );
                },
                onLongPressEnd: (_) => _stopLongPress(),
                child: IconButton(
                  icon: const Icon(Icons.remove, size: 20),
                  onPressed: widget.onRemove,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              // Field Input
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 10.r, top: 5.r),
                    isCollapsed: true,
                  ),
                  onChanged: _onTextChanged,
                ),
              ),
              // Tombol Tambah
              GestureDetector(
                onLongPressStart: (details) {
                  _startLongPress(() {
                    widget.onAdd();
                  });
                },
                onLongPressEnd: (_) => _stopLongPress(),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: widget.onAdd,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

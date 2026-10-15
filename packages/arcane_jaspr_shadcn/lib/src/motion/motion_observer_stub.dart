class MotionObserver {
  MotionObserver(void Function(bool) onChanged);

  bool get canAnimate => false;

  void dispose() {}
}

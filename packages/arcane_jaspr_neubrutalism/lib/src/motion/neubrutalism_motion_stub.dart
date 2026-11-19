class NeubrutalismMotionObserver {
  NeubrutalismMotionObserver(void Function(bool) onChanged);

  bool get canAnimate => false;

  void dispose() {}
}

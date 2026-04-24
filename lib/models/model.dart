class Equation {
  final double w0;
  final double epsilon;
  final double alpha;
  final double beta;

  Equation({
    required this.w0,
    required this.epsilon,
    this.alpha = 0,
    this.beta = 0,
  });
}

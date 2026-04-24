// ================= RK4 =================
import 'package:lppm/models/model.dart';

class NumericalSolver {
  final Equation eq;

  NumericalSolver(this.eq);

  List<List<double>> solve(double A, int steps, double dt) {
    double x = A;
    double v = 0;
    double t = 0;

    List<List<double>> data = [];

    for (int i = 0; i < steps; i++) {
      double f(double x) =>
          -eq.w0 * eq.w0 * x -
          eq.epsilon * eq.alpha * x * x -
          eq.epsilon * eq.beta * x * x * x;

      double k1x = v;
      double k1v = f(x);

      double k2x = v + 0.5 * dt * k1v;
      double k2v = f(x + 0.5 * dt * k1x);

      double k3x = v + 0.5 * dt * k2v;
      double k3v = f(x + 0.5 * dt * k2x);

      double k4x = v + dt * k3v;
      double k4v = f(x + dt * k3x);

      x += dt / 6 * (k1x + 2 * k2x + 2 * k3x + k4x);
      v += dt / 6 * (k1v + 2 * k2v + 2 * k3v + k4v);

      data.add([t, x]);
      t += dt;
    }

    return data;
  }
}

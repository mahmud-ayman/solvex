import 'dart:math';

import 'package:lppm/models/model.dart';

class LPPMSolver {
  final Equation eq;
  final double A;

  LPPMSolver(this.eq, this.A);

  double get w0safe => eq.w0 < 0.1 ? 0.1 : eq.w0;

  double omegaCorrection() {
    if (eq.alpha != 0 && eq.beta == 0) return 0;
    if (eq.beta != 0) return (3 * eq.beta * A * A) / (8 * w0safe);
    return 0;
  }

  double approx(double t) {
    double w = w0safe + eq.epsilon * omegaCorrection();
    double x0 = A * cos(w * t);
    double correction = 0;

    if (eq.alpha != 0) {
      correction +=
          eq.epsilon *
          (-A * A / (2 * w0safe * w0safe) +
              (A * A / (6 * w0safe * w0safe)) * cos(2 * w * t));
    }

    if (eq.beta != 0) {
      correction +=
          eq.epsilon *
          ((A * A * A) /
              (32 * w0safe * w0safe) *
              (cos(3 * w * t) - cos(w * t)));
    }

    return x0 + correction;
  }

  // String lppmEquationLatex() {
  //   double w = w0safe + eq.epsilon * omegaCorrection();
  //   String eqStr = "${A.toStringAsFixed(2)}\\cos(${w.toStringAsFixed(2)} t)";

  //   if (eq.alpha != 0) {
  //     eqStr +=
  //         " + \\varepsilon \\left(-${(A * A / (2 * w0safe * w0safe)).toStringAsFixed(2)} + ${(A * A / (6 * w0safe * w0safe)).toStringAsFixed(2)}\\cos(${(2 * w).toStringAsFixed(2)} t)\\right)";
  //   }

  //   if (eq.beta != 0) {
  //     eqStr +=
  //         " + \\varepsilon \\left(${(A * A * A / (32 * w0safe * w0safe)).toStringAsFixed(2)}(\\cos(${(3 * w).toStringAsFixed(2)} t) - \\cos(${w.toStringAsFixed(2)} t))\\right)";
  //   }

  //   return eqStr;
  // }

  String lppmEquationLatex() {
    double w = w0safe + eq.epsilon * omegaCorrection();
    String eqStr =
        "${Fraction.fromDecimal(A)}\\cos(${Fraction.fromDecimal(w)} t)";

    if (eq.alpha != 0) {
      eqStr +=
          " + \\varepsilon \\left(-${Fraction.fromDecimal(A * A / (2 * w0safe * w0safe))} + ${Fraction.fromDecimal(A * A / (6 * w0safe * w0safe))}\\cos(${Fraction.fromDecimal(2 * w)} t)\\right)";
    }

    if (eq.beta != 0) {
      eqStr +=
          " + \\varepsilon \\left(${Fraction.fromDecimal(A * A * A / (32 * w0safe * w0safe))}(\\cos(${Fraction.fromDecimal(3 * w)} t) - \\cos(${Fraction.fromDecimal(w)} t))\\right)";
    }

    return eqStr;
  }
}

class Fraction {
  int numerator;
  int denominator;

  Fraction(this.numerator, this.denominator);

  @override
  String toString() => "$numerator/$denominator";

  static Fraction fromDecimal(double value, {double tolerance = 1e-6}) {
    if (value == 0) return Fraction(0, 1);
    bool negative = value < 0;
    value = value.abs();

    int n = 1;
    int d = 1;
    double closest = n / d;
    double minDiff = (closest - value).abs();

    for (int denom = 1; denom <= 1000; denom++) {
      int numer = (value * denom).round();
      double diff = (value - numer / denom).abs();
      if (diff < minDiff) {
        minDiff = diff;
        n = numer;
        d = denom;
      }
      if (diff < tolerance) break;
    }

    if (negative) n = -n;
    return Fraction(n, d);
  }
}

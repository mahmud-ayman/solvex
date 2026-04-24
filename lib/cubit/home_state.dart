import 'package:fl_chart/fl_chart.dart';
import 'package:lppm/equations/time_delay_theta_extractor.dart';
import 'solver_type.dart';

class HomeState {
  final SolverType currentSolver;

  // -----------------------------
  // LPPM
  // -----------------------------
  final double w0;
  final double eps;
  final double A;
  final double alpha;
  final double beta;

  final String equationLatex;
  final List<FlSpot> num;
  final List<FlSpot> approx;

  // -----------------------------
  // Time Delay coefficients
  // a y¨ + b y + c y² + d y³ + e y(t-τ) + f y²(t-τ) = 0
  // -----------------------------
  final double coeffA;
  final double coeffB;
  final double coeffC;
  final double coeffD;
  final double coeffE;
  final double coeffF;

  final String timeDelayEquationLatex;
  final String thetaLatex;
  final String thetaNote;

  final bool isLoading;

  const HomeState({
    required this.currentSolver,
    required this.w0,
    required this.eps,
    required this.A,
    required this.alpha,
    required this.beta,
    required this.equationLatex,
    required this.num,
    required this.approx,
    required this.coeffA,
    required this.coeffB,
    required this.coeffC,
    required this.coeffD,
    required this.coeffE,
    required this.coeffF,
    required this.timeDelayEquationLatex,
    required this.thetaLatex,
    required this.thetaNote,
    required this.isLoading,
  });

  factory HomeState.initial() {
    return HomeState(
      currentSolver: SolverType.lppm,
      w0: 1.0,
      eps: 0.1,
      A: 1.0,
      alpha: 1.0,
      beta: 0.0,
      equationLatex: '',
      num: const [],
      approx: const [],
      coeffA: 1.0,
      coeffB: 0.0,
      coeffC: 0.0,
      coeffD: 1.0,
      coeffE: 0.0,
      coeffF: 1.0,
      timeDelayEquationLatex: TimeDelayThetaExtractor.buildEquationLatex(
        a: 1.0,
        b: 0.0,
        c: 0.0,
        d: 1.0,
        e: 0.0,
        f: 1.0,
      ),
      thetaLatex: '',
      thetaNote: '',
      isLoading: false,
    );
  }

  HomeState copyWith({
    SolverType? currentSolver,
    double? w0,
    double? eps,
    double? A,
    double? alpha,
    double? beta,
    String? equationLatex,
    List<FlSpot>? num,
    List<FlSpot>? approx,
    double? coeffA,
    double? coeffB,
    double? coeffC,
    double? coeffD,
    double? coeffE,
    double? coeffF,
    String? timeDelayEquationLatex,
    String? thetaLatex,
    String? thetaNote,
    bool? isLoading,
  }) {
    return HomeState(
      currentSolver: currentSolver ?? this.currentSolver,
      w0: w0 ?? this.w0,
      eps: eps ?? this.eps,
      A: A ?? this.A,
      alpha: alpha ?? this.alpha,
      beta: beta ?? this.beta,
      equationLatex: equationLatex ?? this.equationLatex,
      num: num ?? this.num,
      approx: approx ?? this.approx,
      coeffA: coeffA ?? this.coeffA,
      coeffB: coeffB ?? this.coeffB,
      coeffC: coeffC ?? this.coeffC,
      coeffD: coeffD ?? this.coeffD,
      coeffE: coeffE ?? this.coeffE,
      coeffF: coeffF ?? this.coeffF,
      timeDelayEquationLatex:
          timeDelayEquationLatex ?? this.timeDelayEquationLatex,
      thetaLatex: thetaLatex ?? this.thetaLatex,
      thetaNote: thetaNote ?? this.thetaNote,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

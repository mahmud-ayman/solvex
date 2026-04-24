import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:lppm/cubit/home_state.dart';
import 'package:lppm/cubit/solver_type.dart';
import 'package:lppm/equations/lppm.dart';
import 'package:lppm/equations/pk4.dart';
import 'package:lppm/equations/time_delay_theta_extractor.dart';
import 'package:lppm/models/model.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  String get title {
    switch (state.currentSolver) {
      case SolverType.lppm:
        return "LPPM Solver";
      case SolverType.timeDelay:
        return "Time Delay - Theta";
    }
  }

  void changeSolver(SolverType solver) {
    emit(state.copyWith(currentSolver: solver));

    if (solver == SolverType.lppm) {
      simulateLppm();
    } else {
      updateTimeDelayEquationPreview();
    }
  }

  // =========================
  // LPPM
  // =========================

  void setW0(double value) {
    emit(state.copyWith(w0: value));
    simulateLppm();
  }

  void setEps(double value) {
    emit(state.copyWith(eps: value.clamp(0.0, 0.49)));
    simulateLppm();
  }

  void setA(double value) {
    emit(state.copyWith(A: value));
    simulateLppm();
  }

  void setAlpha(double value) {
    emit(state.copyWith(alpha: value));
    simulateLppm();
  }

  void setBeta(double value) {
    emit(state.copyWith(beta: value));
    simulateLppm();
  }

  void simulateLppm() {
    emit(state.copyWith(isLoading: true));

    final eq = Equation(
      w0: state.w0,
      epsilon: state.eps,
      alpha: state.alpha,
      beta: state.beta,
    );

    final numSolver = NumericalSolver(eq);
    final dtSafe = eq.w0 < 0.5 ? 0.05 : 0.02;
    final data = numSolver.solve(state.A, 800, dtSafe);

    final lppm = LPPMSolver(eq, state.A);

    final List<FlSpot> newNum = [];
    final List<FlSpot> newApprox = [];

    for (final d in data) {
      final t = d[0];
      final y = d[1];

      newNum.add(FlSpot(t, y));
      newApprox.add(FlSpot(t, lppm.approx(t)));
    }

    emit(
      state.copyWith(
        equationLatex: lppm.lppmEquationLatex(),
        num: newNum,
        approx: newApprox,
        isLoading: false,
      ),
    );
  }

  // =========================
  // Time Delay
  // =========================

  double _parseNumber(String value, double fallback) {
    if (value.trim().isEmpty) return 0.0;
    return double.tryParse(value) ?? fallback;
  }

  void setCoeffA(String value) {
    emit(
      state.copyWith(
        coeffA: _parseNumber(value, state.coeffA),
        thetaLatex: '',
        thetaNote: '',
      ),
    );
    updateTimeDelayEquationPreview();
  }

  void setCoeffB(String value) {
    emit(
      state.copyWith(
        coeffB: _parseNumber(value, state.coeffB),
        thetaLatex: '',
        thetaNote: '',
      ),
    );
    updateTimeDelayEquationPreview();
  }

  void setCoeffC(String value) {
    emit(
      state.copyWith(
        coeffC: _parseNumber(value, state.coeffC),
        thetaLatex: '',
        thetaNote: '',
      ),
    );
    updateTimeDelayEquationPreview();
  }

  void setCoeffD(String value) {
    emit(
      state.copyWith(
        coeffD: _parseNumber(value, state.coeffD),
        thetaLatex: '',
        thetaNote: '',
      ),
    );
    updateTimeDelayEquationPreview();
  }

  void setCoeffE(String value) {
    emit(
      state.copyWith(
        coeffE: _parseNumber(value, state.coeffE),
        thetaLatex: '',
        thetaNote: '',
      ),
    );
    updateTimeDelayEquationPreview();
  }

  void setCoeffF(String value) {
    emit(
      state.copyWith(
        coeffF: _parseNumber(value, state.coeffF),
        thetaLatex: '',
        thetaNote: '',
      ),
    );
    updateTimeDelayEquationPreview();
  }

  void usePaperExample() {
    emit(
      state.copyWith(
        coeffA: 1.0,
        coeffB: 0.0,
        coeffC: 0.0,
        coeffD: 1.0,
        coeffE: 0.0,
        coeffF: 1.0,
        thetaLatex: '',
        thetaNote: '',
      ),
    );
    updateTimeDelayEquationPreview();
  }

  void clearTimeDelayInputs() {
    emit(
      state.copyWith(
        coeffA: 0.0,
        coeffB: 0.0,
        coeffC: 0.0,
        coeffD: 0.0,
        coeffE: 0.0,
        coeffF: 0.0,
        thetaLatex: '',
        thetaNote: '',
      ),
    );
    updateTimeDelayEquationPreview();
  }

  void updateTimeDelayEquationPreview() {
    final equation = TimeDelayThetaExtractor.buildEquationLatex(
      a: state.coeffA,
      b: state.coeffB,
      c: state.coeffC,
      d: state.coeffD,
      e: state.coeffE,
      f: state.coeffF,
    );

    emit(state.copyWith(timeDelayEquationLatex: equation));
  }

  void extractTheta() {
    final result = TimeDelayThetaExtractor.extract(
      a: state.coeffA,
      b: state.coeffB,
      c: state.coeffC,
      d: state.coeffD,
      e: state.coeffE,
      f: state.coeffF,
    );

    emit(
      state.copyWith(
        timeDelayEquationLatex: result.equationLatex,
        thetaLatex: result.thetaLatex,
        thetaNote: result.note,
      ),
    );
  }
}

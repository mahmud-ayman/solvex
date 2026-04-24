class TimeDelayThetaResult {
  final String equationLatex;
  final String thetaLatex;
  final String note;

  const TimeDelayThetaResult({
    required this.equationLatex,
    required this.thetaLatex,
    required this.note,
  });
}

class TimeDelayThetaExtractor {
  static bool _isZero(double x) => x.abs() < 1e-12;

  static bool _isOne(double x) => (x - 1.0).abs() < 1e-12;

  static bool _isMinusOne(double x) => (x + 1.0).abs() < 1e-12;

  static String _formatNumber(double x) {
    if (x == x.roundToDouble()) {
      return x.toInt().toString();
    }
    return x.toStringAsFixed(2);
  }

  static String _coefficientLatex(double c, {bool omitOne = true}) {
    if (_isOne(c) && omitOne) return "";
    if (_isMinusOne(c) && omitOne) return "-";
    return _formatNumber(c);
  }

  static String _buildTerm(double coeff, String termLatex) {
    if (_isZero(coeff)) return "";

    final coeffText = _coefficientLatex(coeff);
    if (coeffText.isEmpty) return termLatex;
    if (coeffText == "-") return "-$termLatex";
    return "$coeffText$termLatex";
  }

  static String buildEquationLatex({
    required double a,
    required double b,
    required double c,
    required double d,
    required double e,
    required double f,
  }) {
    final List<String> rawTerms = [
      _buildTerm(a, r"\ddot{y}"),
      _buildTerm(b, "y"),
      _buildTerm(c, r"y^2"),
      _buildTerm(d, r"y^3"),
      _buildTerm(e, r"y(t-\tau)"),
      _buildTerm(f, r"y^2(t-\tau)"),
    ].where((t) => t.isNotEmpty).toList();

    if (rawTerms.isEmpty) {
      return r"0 = 0";
    }

    String equation = rawTerms.first;
    for (int i = 1; i < rawTerms.length; i++) {
      final t = rawTerms[i];
      if (t.startsWith('-')) {
        equation += " - ${t.substring(1)}";
      } else {
        equation += " + $t";
      }
    }

    return "$equation = 0";
  }

  static TimeDelayThetaResult extract({
    required double a,
    required double b,
    required double c,
    required double d,
    required double e,
    required double f,
  }) {
    final equation = buildEquationLatex(a: a, b: b, c: c, d: d, e: e, f: f);

    final hasDelay = !_isZero(e) || !_isZero(f);

    if (!hasDelay) {
      return TimeDelayThetaResult(
        equationLatex: equation,
        thetaLatex: r"\text{No delay term found}",
        note: "المعادلة لا تحتوي على حد مؤخر، لذلك لا يمكن استخراج θ.",
      );
    }

    // الحالة الخاصة المطابقة للورقة:
    // y¨ + y³ + y²(t-τ) = 0
    if (_isOne(a) &&
        _isZero(b) &&
        _isZero(c) &&
        _isOne(d) &&
        _isZero(e) &&
        _isOne(f)) {
      return TimeDelayThetaResult(
        equationLatex: equation,
        thetaLatex: r"\theta = \frac{\sqrt{3}}{2} A \tau",
        note:
            "في هذه الحالة الخاصة، التطبيق يستخرج θ = (√3/2) A τ بناءً على اشتقاق خاص بالمعادلة.",
      );
    }

    return TimeDelayThetaResult(
      equationLatex: equation,
      thetaLatex: r"\theta = \Omega \tau",
      note:
          "في الحالة العامة التطبيق يعرض θ = Ωτ رمزيًا، لأن Ω تعتمد على اشتقاق خاص بالمعادلة.",
    );
  }
}

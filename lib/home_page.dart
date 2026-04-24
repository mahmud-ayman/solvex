import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart' as fm;

import 'package:lppm/cubit/home_cubit.dart';
import 'package:lppm/cubit/home_state.dart';
import 'package:lppm/cubit/solver_type.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..simulateLppm(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();

        return Scaffold(
          backgroundColor: Color(0xffF9F6EE),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 209, 209, 209),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            shadowColor: const Color.fromARGB(255, 0, 0, 0),
            title: Text(cubit.title),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                const DrawerHeader(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsetsGeometry.all(60),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),

                    color: Color.fromARGB(255, 134, 135, 136),
                  ),
                  child: Text(
                    "Choose Solver",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.show_chart),
                  title: const Text("LPPM"),
                  onTap: () {
                    cubit.changeSolver(SolverType.lppm);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text("Time Delay"),
                  onTap: () {
                    cubit.changeSolver(SolverType.timeDelay);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: state.currentSolver == SolverType.lppm
                ? _buildLppmBody(context, state, cubit)
                : _buildTimeDelayBody(context, state, cubit),
          ),
        );
      },
    );
  }

  // =========================
  // LPPM UI
  // =========================

  Widget _buildLppmBody(
    BuildContext context,
    HomeState state,
    HomeCubit cubit,
  ) {
    final numericalText = state.num.isNotEmpty
        ? "Last Numerical: t=${state.num.last.x.toStringAsFixed(2)}, y=${state.num.last.y.toStringAsFixed(4)}"
        : "Last Numerical: -";

    final approxText = state.approx.isNotEmpty
        ? "Last Approximate: t=${state.approx.last.x.toStringAsFixed(2)}, y=${state.approx.last.y.toStringAsFixed(4)}"
        : "Last Approximate: -";

    return Column(
      children: [
        _slider(
          label: "ω0",
          value: state.w0,
          min: 0.5,
          max: 8.0,
          onChanged: cubit.setW0,
        ),
        _slider(
          label: "ε",
          value: state.eps,
          min: 0.0,
          max: 0.49,
          onChanged: cubit.setEps,
        ),
        _slider(
          label: "A",
          value: state.A,
          min: 0.1,
          max: 2.0,
          onChanged: cubit.setA,
        ),
        _slider(
          label: "α (x²)",
          value: state.alpha,
          min: 0.0,
          max: 2.0,
          onChanged: cubit.setAlpha,
        ),
        _slider(
          label: "β (x³)",
          value: state.beta,
          min: 0.0,
          max: 2.0,
          onChanged: cubit.setBeta,
        ),
        const SizedBox(height: 10),
        Text(
          numericalText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          approxText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 8),
        if (state.equationLatex.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: fm.Math.tex(
              state.equationLatex,
              textStyle: const TextStyle(fontSize: 16, color: Colors.green),
            ),
          ),
        const SizedBox(height: 10),
        if (state.isLoading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: state.num.isNotEmpty ? state.num.last.x : 16,
                minY: -3,
                maxY: 3,
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: state.num,
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 2,
                    dotData: FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: state.approx,
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 2,
                    dashArray: [5, 5],
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // =========================
  // Time Delay UI
  // =========================

  Widget _buildTimeDelayBody(
    BuildContext context,
    HomeState state,
    HomeCubit cubit,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Enter the coefficients for the equation",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "General form: a y¨ + b y + c y² + d y³ + e y(t-τ) + f y²(t-τ) = 0",
            style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 89, 89, 89),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: cubit.usePaperExample,
                  child: const Text("Use Paper Example"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: cubit.clearTimeDelayInputs,
                  child: const Text("Clear"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _coefficientField(
            label: "a coefficient of y¨",
            initialValue: state.coeffA,
            onChanged: cubit.setCoeffA,
          ),
          _coefficientField(
            label: "b coefficient of y",
            initialValue: state.coeffB,
            onChanged: cubit.setCoeffB,
          ),
          _coefficientField(
            label: "c coefficient of y²",
            initialValue: state.coeffC,
            onChanged: cubit.setCoeffC,
          ),
          _coefficientField(
            label: "d coefficient of y³",
            initialValue: state.coeffD,
            onChanged: cubit.setCoeffD,
          ),
          _coefficientField(
            label: "e coefficient of y(t-τ)",
            initialValue: state.coeffE,
            onChanged: cubit.setCoeffE,
          ),
          _coefficientField(
            label: "f coefficient of y²(t-τ)",
            initialValue: state.coeffF,
            onChanged: cubit.setCoeffF,
          ),

          const SizedBox(height: 24),

          const Text(
            "Generated equation",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: fm.Math.tex(
                state.timeDelayEquationLatex,
                textStyle: const TextStyle(fontSize: 20, color: Colors.blue),
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: cubit.extractTheta,
              child: const Text("Extract θ"),
            ),
          ),

          const SizedBox(height: 24),

          if (state.thetaLatex.isNotEmpty) ...[
            const Text(
              "Result",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: fm.Math.tex(
                  state.thetaLatex,
                  textStyle: const TextStyle(
                    fontSize: 24,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  // =========================
  // Reusable Widgets
  // =========================

  Widget _slider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Text("$label = ${value.toStringAsFixed(2)}"),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }

  Widget _coefficientField({
    required String label,
    required double initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(221, 255, 0, 0),
        ),
        initialValue: initialValue.toString(),
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        decoration: InputDecoration(
          labelStyle: const TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 60, 60, 60),
          ),
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_stat_widget/stat_card.dart';
import 'package:flutter/material.dart';

List<double> revenues = [
  18000,
  22000,
  26000,
  21000,
  26000,
  29000,
];


class OrdersSummaryCard extends StatelessWidget {
  final ClientModel client;

  const OrdersSummaryCard({
    super.key,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    return StatCard(
      child: Stack(
        children: [


          Positioned(
            right: 0,
            bottom: 4,
            child:             SizedBox(
              width: 160,
              height: 75,
              child: _SparkLine(values: revenues),
            ),

          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT CONTENT
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  const Text(
                    'Orders',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Avg. Value  ₹${_avgOrderValue(client)}/mo',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Total Revenue',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,

                children: [Text(
                  '${client.deliveredOrdersCount ?? 0} / ${client.totalOrders ?? 0}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                  // const SizedBox(height: 16),

                  // RIGHT GRAPH (sparkline placeholder)

                ],
              )

            ],
          ),
        ],
      ),
    );
  }

  String _avgOrderValue(ClientModel c) {
    if ((c.totalOrders ?? 0) == 0) return '0';
    return (c.outstandingAmount / (c.totalOrders ?? 1))
        .toStringAsFixed(0);
  }
}


class _SparkLine extends StatelessWidget {
  final List<double> values;

  const _SparkLine({
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    if (values.length < 2) {
      return const SizedBox(); // not enough data
    }

    return CustomPaint(
      size: const Size(90, 50),
      painter: _SmoothSparkLinePainter(values),
    );
  }
}



class _SmoothSparkLinePainter extends CustomPainter {
  final List<double> values;

  _SmoothSparkLinePainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF3B82F6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = const Color(0xFF3B82F6).withOpacity(0.14)
      ..style = PaintingStyle.fill;

    final minVal = values.reduce((a, b) => a < b ? a : b);
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final range = (maxVal - minVal).abs() < 1 ? 1 : maxVal - minVal;

    // Normalize points
    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = size.width * (i / (values.length - 1));
      final y = size.height *
          (1 - (values[i] - minVal) / range); // invert Y
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);

    // Smooth cubic interpolation
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];

      final controlPointX = (p0.dx + p1.dx) / 2;

      path.cubicTo(
        controlPointX, p0.dy,
        controlPointX, p1.dy,
        p1.dx, p1.dy,
      );
    }

    // Area fill
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SmoothSparkLinePainter oldDelegate) {
    return oldDelegate.values != values;
  }
}





// class _SmoothSparkLinePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final linePaint = Paint()
//       ..color = const Color(0xFF3B82F6)
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..strokeJoin = StrokeJoin.round;
//
//     final fillPaint = Paint()
//       ..color = const Color(0xFF3B82F6).withOpacity(0.14)
//       ..style = PaintingStyle.fill;
//
//     final path = Path();
//
//     // Start point
//     path.moveTo(0, size.height * 0.75);
//
//     // Cubic Bézier segments
//     path.cubicTo(
//       size.width * 0.15, size.height * 0.65,
//       size.width * 0.25, size.height * 0.45,
//       size.width * 0.35, size.height * 0.5,
//     );
//
//     path.cubicTo(
//       size.width * 0.45, size.height * 0.55,
//       size.width * 0.55, size.height * 0.35,
//       size.width * 0.65, size.height * 0.4,
//     );
//
//     path.cubicTo(
//       size.width * 0.75, size.height * 0.45,
//       size.width * 0.85, size.height * 0.25,
//       size.width, size.height * 0.3,
//     );
//
//     // Area fill path
//     final fillPath = Path.from(path)
//       ..lineTo(size.width, size.height)
//       ..lineTo(0, size.height)
//       ..close();
//
//     canvas.drawPath(fillPath, fillPaint);
//     canvas.drawPath(path, linePaint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }



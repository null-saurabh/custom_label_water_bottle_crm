import 'package:flutter/material.dart';
import 'today_due_card/today_due_card.dart';
import 'due_next_week_card/due_next_week_card.dart';

class DueCardsSlider extends StatefulWidget {
  const DueCardsSlider({super.key});

  @override
  State<DueCardsSlider> createState() => _DueCardsSliderState();
}

class _DueCardsSliderState extends State<DueCardsSlider> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 400, // adjust if cards are taller
          child: PageView(
            controller: _controller,
            onPageChanged: (i) {
              setState(() => _index = i);
            },
            children: const [
              DueDeliveriesTodayCard(),
              DueNextWeekCard(),
            ],
          ),
        ),

        const SizedBox(height: 10),

        _DotsIndicator(
          count: 2,
          activeIndex: _index,
        ),
      ],
    );
  }
}


class _DotsIndicator extends StatelessWidget {
  final int count;
  final int activeIndex;

  const _DotsIndicator({
    required this.count,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == activeIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 10 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF4C6FFF)
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

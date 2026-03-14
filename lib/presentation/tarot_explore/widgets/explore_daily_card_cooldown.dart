part of '../pages/tarot_explore_page.dart';

class ExploreDailyCardWithCooldown extends StatefulWidget {
  const ExploreDailyCardWithCooldown({super.key});

  @override
  State<ExploreDailyCardWithCooldown> createState() => _ExploreDailyCardWithCooldownState();
}

class _ExploreDailyCardWithCooldownState extends State<ExploreDailyCardWithCooldown> {
  late final ValueNotifier<Duration> remaining;
  late Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    remaining = ValueNotifier<Duration>(Duration.zero);
    countdownTimer = null;
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    remaining.dispose();
    super.dispose();
  }

  void startCountdown(Duration duration) {
    countdownTimer?.cancel();
    remaining.value = duration;
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final next = remaining.value - const Duration(seconds: 1);
      if (next.isNegative) {
        remaining.value = Duration.zero;
        countdownTimer?.cancel();
      } else {
        remaining.value = next;
      }
    });
  }

  DateTime? getLastSavedAt(TarotState state) {
    final cards = state.dailyCardsOrEmpty.asList();
    if (cards.isEmpty) return null;
    return cards.first.savedAt;
  }

  bool isOnCooldown(DateTime lastSavedAt) {
    final now = DateTime.now();
    final cooldownEnd = lastSavedAt.add(const Duration(hours: 24));
    return now.isBefore(cooldownEnd);
  }

  Duration getRemainingDuration(DateTime lastSavedAt) {
    final now = DateTime.now();
    final cooldownEnd = lastSavedAt.add(const Duration(hours: 24));
    final diff = cooldownEnd.difference(now);
    return diff.isNegative ? Duration.zero : diff;
  }

  String formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TarotBloc, TarotState>(
      listenWhen: (previous, current) => getLastSavedAt(previous) != getLastSavedAt(current),
      listener: (context, state) {
        final lastSavedAt = getLastSavedAt(state);
        if (lastSavedAt != null && isOnCooldown(lastSavedAt)) {
          startCountdown(getRemainingDuration(lastSavedAt));
        } else {
          countdownTimer?.cancel();
          remaining.value = Duration.zero;
        }
      },
      buildWhen: (previous, current) => getLastSavedAt(previous) != getLastSavedAt(current),
      builder: (context, state) {
        final lastSavedAt = getLastSavedAt(state);
        final onCooldown = lastSavedAt != null && isOnCooldown(lastSavedAt);

        if (onCooldown && countdownTimer == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              startCountdown(getRemainingDuration(lastSavedAt));
            }
          });
        }

        return ValueListenableBuilder<Duration>(
          valueListenable: remaining,
          builder: (context, remainingValue, _) {
            return ExploreFeatureCard(
              title: LocaleKeys.exploreDailyCard.tr(),
              imagePath: TarotAppAssets.askQuestion.path,
              onTap: () => context.push(AppRoutes.tarotReveal),
              isDisabled: false,
              countdownText: onCooldown ? formatDuration(remainingValue) : null,
            );
          },
        );
      },
    );
  }
}

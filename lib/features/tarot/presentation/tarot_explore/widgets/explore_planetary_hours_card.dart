part of '../pages/tarot_explore_page.dart';

/// Live "current planetary hour" card pinned to the top of the explore page.
/// Reuses the city saved by the planetary hours page (or the registration
/// profile) and recomputes the schedule on-device; shows a teaser until a
/// city is known.
class ExplorePlanetaryHoursCard extends StatefulWidget {
  const ExplorePlanetaryHoursCard({super.key});

  @override
  State<ExplorePlanetaryHoursCard> createState() =>
      _ExplorePlanetaryHoursCardState();
}

class _ExplorePlanetaryHoursCardState extends State<ExplorePlanetaryHoursCard> {
  PlanetaryLocationModel? _location;
  PlanetaryHourSchedule? _schedule;
  DateTime _now = DateTime.now();
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    await _reloadLocation();
    if (!mounted) return;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  Future<void> _reloadLocation() async {
    var saved = await PlanetaryLocationService.load();
    if (!mounted) return;
    if (saved == null) {
      saved = _resolveFromProfile();
      if (saved != null) unawaited(PlanetaryLocationService.save(saved));
    }
    setState(() => _location = saved);
    _recalculate();
  }

  /// Fast path only: coordinates embedded in the profile location string.
  /// Legacy plain-name records are resolved when the full page is opened.
  PlanetaryLocationModel? _resolveFromProfile() {
    final authState = context.read<AuthCubit>().state;
    if (!authState.isAuthenticated) return null;
    final user = authState.userOrCrash as TarotUser;
    final info = UserLocationCodec.decode(user.location);
    if (info.name.isEmpty || !info.hasCoordinates) return null;
    return PlanetaryLocationModel(
      name: info.name,
      latitude: info.latitude!,
      longitude: info.longitude!,
      zoneName: info.zoneName,
    );
  }

  void _onTick() {
    if (!mounted) return;
    setState(() => _now = DateTime.now());
    final sched = _schedule;
    if (sched != null && !_now.isBefore(sched.hours.last.end)) _recalculate();
  }

  void _recalculate() {
    final loc = _location;
    if (loc == null) {
      _schedule = null;
      return;
    }
    final current = DateTime.now();
    var sched = PlanetaryHourCalculator.calculate(
      date: current,
      latitude: loc.latitude,
      longitude: loc.longitude,
      zoneName: loc.zoneName,
    );
    // Before today's sunrise the running hours belong to yesterday's cycle.
    if (current.isBefore(sched.hours.first.start)) {
      sched = PlanetaryHourCalculator.calculate(
        date: current.subtract(const Duration(days: 1)),
        latitude: loc.latitude,
        longitude: loc.longitude,
        zoneName: loc.zoneName,
      );
    }
    _schedule = sched;
  }

  Future<void> _openPage() async {
    await context.push(AppRoutes.planetaryHours);
    if (mounted) await _reloadLocation();
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatCountdown(Duration duration) {
    final clamped = duration.isNegative ? Duration.zero : duration;
    final hours = clamped.inHours;
    final minutes = clamped.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = clamped.inSeconds.remainder(60).toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final schedule = _schedule;
    final hour = schedule?.currentHour(_now);

    return ScalingContainer(
      onTap: () => unawaited(_openPage()),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.gradientStart, colors.gradientEnd],
          ),
          borderRadius: Sp.large.radiusR,
          border: Border.all(color: colors.border, width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: Sp.large.radiusR,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _CosmicBackgroundPainter()),
              ),
              Padding(
                padding: Sp.medium.padAllR,
                child:
                    hour == null
                        ? const _TeaserContent()
                        : _LiveContent(
                          hour: hour,
                          now: _now,
                          formatTime: _formatTime,
                          formatCountdown: _formatCountdown,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LiveContent extends StatelessWidget {
  const _LiveContent({
    required this.hour,
    required this.now,
    required this.formatTime,
    required this.formatCountdown,
  });

  final PlanetaryHour hour;
  final DateTime now;
  final String Function(DateTime) formatTime;
  final String Function(Duration) formatCountdown;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final remaining = hour.end.difference(now);

    return Row(
      children: [
        _RulerGlyphAvatar(ruler: hour.ruler),
        Sp.small.widthBox,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.planetary_page_hour_of.tr(
                  args: [hour.ruler.localizedName],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: m15w600(context).copyWith(color: colors.textOnPrimary),
              ),
              Sp.tiny.heightBox,
              Text(
                hour.ruler.localizedMeaning,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: m11w400(context).copyWith(
                  color: colors.textOnPrimary.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
        Sp.small.widthBox,
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Sp.small.w,
                vertical: Sp.tiny.h,
              ),
              decoration: BoxDecoration(
                color: colors.buttonOnGradient,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                LocaleKeys.planetary_page_remaining.tr(
                  args: [formatCountdown(remaining)],
                ),
                style: m12w600(context).copyWith(
                  color: colors.textOnPrimary,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
            ),
            Sp.tiny.heightBox,
            Text(
              '${formatTime(hour.start)} – ${formatTime(hour.end)}',
              style: m10w500(context).copyWith(
                color: colors.textOnPrimary.withValues(alpha: 0.7),
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TeaserContent extends StatelessWidget {
  const _TeaserContent();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        const _RulerGlyphAvatar(ruler: PlanetaryRuler.moon),
        Sp.small.widthBox,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.planetary_page_title.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: m15w600(context).copyWith(color: colors.textOnPrimary),
              ),
              Sp.tiny.heightBox,
              Text(
                LocaleKeys.planetary_page_empty_title.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: m11w400(context).copyWith(
                  color: colors.textOnPrimary.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right_rounded, color: colors.textOnPrimary),
      ],
    );
  }
}

class _RulerGlyphAvatar extends StatelessWidget {
  const _RulerGlyphAvatar({required this.ruler});

  final PlanetaryRuler ruler;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.textOnPrimary.withValues(alpha: 0.16),
        border: Border.all(
          color: colors.textOnPrimary.withValues(alpha: 0.35),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        ruler.glyph,
        style: TextStyle(
          fontSize: 22.sp,
          height: 1,
          color: colors.textOnPrimary,
        ),
      ),
    );
  }
}

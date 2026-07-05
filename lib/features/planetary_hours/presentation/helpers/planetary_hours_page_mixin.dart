part of '../pages/planetary_hours_page.dart';

mixin PlanetaryHoursPageMixin on State<PlanetaryHoursPage> {
  late ValueNotifier<PlanetaryLocationModel?> location;
  late ValueNotifier<PlanetaryHourSchedule?> schedule;
  late ValueNotifier<DateTime> now;
  late ValueNotifier<int> currentHourIndex;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    location = ValueNotifier<PlanetaryLocationModel?>(null);
    schedule = ValueNotifier<PlanetaryHourSchedule?>(null);
    now = ValueNotifier<DateTime>(DateTime.now());
    currentHourIndex = ValueNotifier<int>(-1);
    unawaited(_init());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    location.dispose();
    schedule.dispose();
    now.dispose();
    currentHourIndex.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await BirthTimezoneResolver.preload();
    var saved = await PlanetaryLocationService.load();
    if (!mounted) return;
    saved ??= await _resolveFromProfile();
    if (!mounted) return;
    if (saved != null) {
      location.value = saved;
      _recalculate();
    }
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  /// Reuses the city picked at registration so the user is not asked again.
  /// New records embed coordinates in the location string; legacy plain-name
  /// records are resolved against the bundled city dataset and upgraded.
  Future<PlanetaryLocationModel?> _resolveFromProfile() async {
    final user = context.read<AuthCubit>().state.userOrCrash as TarotUser;
    final info = UserLocationCodec.decode(user.location);
    if (info.name.isEmpty) return null;

    if (info.hasCoordinates) {
      final model = PlanetaryLocationModel(
        name: info.name,
        latitude: info.latitude!,
        longitude: info.longitude!,
        zoneName: info.zoneName,
      );
      await PlanetaryLocationService.save(model);
      return model;
    }

    final model = await _lookupByName(info.name);
    if (model == null) return null;
    await PlanetaryLocationService.save(model);
    if (mounted) unawaited(_persistToProfile(model));
    return model;
  }

  Future<PlanetaryLocationModel?> _lookupByName(String name) async {
    final target = _normalizePlaceName(name);
    if (target.isEmpty) return null;

    PlanetaryLocationModel? fromEntry({
      required String entryName,
      required String countryCode,
      required String? latitude,
      required String? longitude,
    }) {
      if (_normalizePlaceName(entryName) != target) return null;
      final lat = double.tryParse(latitude ?? '');
      final lon = double.tryParse(longitude ?? '');
      if (lat == null || lon == null) return null;
      return PlanetaryLocationModel(
        name: name,
        latitude: lat,
        longitude: lon,
        zoneName: BirthTimezoneResolver.zoneName(
          countryIsoCode: countryCode,
          longitude: lon,
        ),
      );
    }

    final cities = await csc.getAllCities();
    for (final city in cities) {
      final model = fromEntry(
        entryName: city.name,
        countryCode: city.countryCode,
        latitude: city.latitude,
        longitude: city.longitude,
      );
      if (model != null) return model;
    }
    final states = await csc.getAllStates();
    for (final state in states) {
      final model = fromEntry(
        entryName: state.name,
        countryCode: state.countryCode,
        latitude: state.latitude,
        longitude: state.longitude,
      );
      if (model != null) return model;
    }
    return null;
  }

  String _normalizePlaceName(String value) {
    return value
        .replaceFirst(
          RegExp(
            r'\s+(Province|Region|District|State|Governorate|Prefecture|County|Department|Municipality)$',
            caseSensitive: false,
          ),
          '',
        )
        .trim()
        .toLowerCase();
  }

  Future<void> _persistToProfile(PlanetaryLocationModel model) async {
    final authCubit = context.read<AuthCubit>();
    final user = authCubit.state.userOrCrash as TarotUser;
    if (user.relationshipStatus == null || user.careerStatus == null) return;
    final properties = TarotUserProperties(
      zodiac: user.zodiac,
      relationshipStatus: user.relationshipStatus!,
      careerStatus: user.careerStatus!,
      name: user.name ?? '',
      birthDate: user.birthDate ?? DateTime.now(),
      location: UserLocationCodec.encode(
        name: model.name,
        latitude: model.latitude,
        longitude: model.longitude,
        zoneName: model.zoneName,
      ),
      moonSign: user.moonSign,
      risingSign: user.risingSign,
    );
    await authCubit.updateUser(properties: properties);
  }

  void _onTick() {
    now.value = DateTime.now();
    final sched = schedule.value;
    if (sched == null) return;
    if (!now.value.isBefore(sched.hours.last.end)) {
      _recalculate();
      return;
    }
    final index = sched.currentHour(now.value).index;
    if (index != currentHourIndex.value) currentHourIndex.value = index;
  }

  void _recalculate() {
    final loc = location.value;
    if (loc == null) return;
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
    schedule.value = sched;
    currentHourIndex.value = sched.currentHour(current).index;
  }

  Future<void> pickCity() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Sp.xlarge)),
      ),
      builder: (_) => CityPickerSheet(onCitySelected: _onCitySelected),
    );
  }

  void _onCitySelected(String name, double lat, double lon, String? zoneName) {
    final loc = PlanetaryLocationModel(
      name: name,
      latitude: lat,
      longitude: lon,
      zoneName: zoneName,
    );
    location.value = loc;
    unawaited(PlanetaryLocationService.save(loc));
    unawaited(_persistToProfile(loc));
    _recalculate();
  }

  String formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String formatCountdown(Duration duration) {
    final clamped = duration.isNegative ? Duration.zero : duration;
    final hours = clamped.inHours;
    final minutes = clamped.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = clamped.inSeconds.remainder(60).toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }
}

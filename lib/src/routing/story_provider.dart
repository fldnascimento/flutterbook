import 'package:flutter/material.dart';

import '../navigation/models/organizers.dart';
import 'controls.dart';

class StoryProvider extends ChangeNotifier implements ControlsInterface {
  StoryProvider({
    ComponentState? currentStory,
  }) : _currentStory = currentStory;

  factory StoryProvider.fromPath(String? path, List<ComponentState> stories) {
    final storyPath = path?.replaceFirst('/stories/', '') ?? '';
    ComponentState? story;
    for (final element in stories) {
      if (element.path == storyPath) story = element;
    }
    return StoryProvider(currentStory: story);
  }

  ComponentState? _currentStory;

  ComponentState? get currentStory => _currentStory;

  void updateStory(ComponentState? story) {
    _currentStory = story;
    notifyListeners();
  }

  final Map<String, Control> _controls = <String, Control>{};
  static const String kDefaultNoDescMessage = 'No description.';
  bool _disposed = false;

  @override
  bool boolean({
    required String label,
    Widget? valueDefault,
    bool initial = false,
    String description = kDefaultNoDescMessage,
  }) =>
      addControl(
        BoolControl(
          label,
          initial,
          initial,
          description,
          valueDefault,
        ),
      );

  @override
  String text({
    required String label,
    Widget? valueDefault,
    String initial = '',
    String description = kDefaultNoDescMessage,
  }) =>
      addControl(StringControl(
        label,
        initial,
        initial,
        description,
        valueDefault,
      ));

  T addControl<T>(Control<T> value) =>
      (_controls.putIfAbsent(value.label, () => value) as Control<T>).value;

  void update<T>(String label, T value) {
    _controls[label]!.value = value;
    notifyListeners();
  }

  T get<T>(String label) => _controls[label]!.value as T;

  List<Control> get all => _controls.values.toList();

  @override
  double number({
    required String label,
    required double initial,
    Widget? valueDefault,
    double max = 1,
    double min = 0,
    String description = kDefaultNoDescMessage,
  }) =>
      addControl(
        NumberControl(
          label,
          initial,
          initial,
          description,
          min,
          max,
          valueDefault,
        ),
      );

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  T list<T>({
    required String label,
    required T initial,
    required List<ListItem<T>> list,
    required T value,
    Widget? valueDefault,
    String description = kDefaultNoDescMessage,
  }) {
    return addControl(
      ListControl<T>(
        label,
        value,
        initial,
        description,
        list,
        valueDefault,
      ),
    );
  }
}

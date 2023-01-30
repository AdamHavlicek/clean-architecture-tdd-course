import 'package:redux_epics/redux_epics.dart';

abstract class _RequiredActionTransform<State> {
  Stream<dynamic> mapAction(Stream<dynamic> actions, EpicStore<State> store);
}

/// Change of default [EpicClass] behavior
/// with filtering of any emitted null action
///
/// Extends this class and implement [mapAction]
///
/// If updating existing class implementation of [EpicClass],
/// simply change to extending [EpicFilteredClass] and rename
/// [call] to [mapAction]
abstract class EpicFilteredClass<State> extends EpicClass<State>
    implements _RequiredActionTransform<State> {
  @override
  Stream call(Stream actions, EpicStore<State> store) {
    // This will filter any unhandled action emit in Epics
    return mapAction(actions, store).where((event) => event != null);
  }
}

/// Mixin with same functionality as [EpicFilteredClass]
mixin EpicFilteredMixin<State> on EpicClass<State> {
  @override
  Stream call(Stream actions, EpicStore<State> store) {
    return super.call(actions, store).where((event) => event != null);
  }
}

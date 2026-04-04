// ignore: one_member_abstracts

// ignore: one_member_abstracts
abstract class BindingsInterface<T> {
  T dependencies();
}

/// [Bindings] should be extended or implemented.
/// When using `GetMaterialApp`, all `GetPage`s and navigation
/// methods (like Get.to()) have a `binding` property that takes an
/// instance of Bindings to manage the
/// dependencies() (via Get.put()) for the Route you are opening.
// ignore: one_member_abstracts
@Deprecated('Use Binding instead')
abstract class Bindings extends BindingsInterface<void> {
  @override
  void dependencies();
}

typedef BindingBuilderCallback = void Function();

typedef T InstanceCreator<T>();

class DependencyInjector {
  DependencyInjector._();
  static final _singleton = DependencyInjector._();

  factory DependencyInjector() => _singleton;

  final _instanceMap = Map<Type, _InstanceGeneretator<Object>>();

  //register
  void register<T extends Object>(
    InstanceCreator<T> instance,{
      bool isSingleton = true,
    }) => 
    _instanceMap[T] = _InstanceGeneretator(instance, isSingleton);
  
  //get

  T get<T extends Object>(){
    final instance = _instanceMap[T]?.getInstance();
    if (instance != null && instance is T) return instance;
    throw Exception('[ERROR] => Instance ${T.toString()} not found');
  }

  call<T extends Object>() => get<T>();

}

class _InstanceGeneretator<T> {
  T? _instance;
  bool _isFirstGet = false;

  final InstanceCreator<T> _InstanceCreator;
  _InstanceGeneretator(this._InstanceCreator, bool isSingleton)
    : _isFirstGet = isSingleton;
  T? getInstance() {
    if (_isFirstGet) {
      _instance = _InstanceCreator();
      _isFirstGet = false;
    }
    
    return _instance != null ? _instance : _InstanceCreator();
  }
}

abstract class Dao<T> {

  Future<bool> create(T vlaue);
  Future<T?> findOne(T value);
  Future<List<T>> findAll();
  Future<bool> update(T value);
  Future<bool> delete(int id);

}
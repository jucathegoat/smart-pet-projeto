abstract class GenericService<T> {

 Future<T?>  findOne(T value);
  Future<List<T>>findAll();
  Future<bool> save(T value);
  Future<bool> delete(int id);
}
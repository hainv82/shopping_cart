abstract class UseCase<T> {
  const UseCase();

  Future<T> execute();
}

abstract class Resource {
  const Resource(this.path);

  final String path;

  static Resource test(String path) => _BaseResource(path);
}

class _BaseResource extends Resource {
  const _BaseResource(String path) : super(path);
}

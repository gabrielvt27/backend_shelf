abstract class RemoteDataBase {
  Future<List<Map<String, Map<String, dynamic>>>> query(
    String queryText, {
    Map<String, String> variables = const {},
  });
}

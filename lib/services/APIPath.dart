class APIPath {
  static String path_list(String uid, String listId) =>
      'users/$uid/lists/$listId';

  static String path_lists(String uid) => 'users/$uid/lists';

  static String task({String uid, String taskId}) => 'users/$uid/tasks/$taskId';

  static String tasks({String uid}) => 'users/$uid/tasks';
}

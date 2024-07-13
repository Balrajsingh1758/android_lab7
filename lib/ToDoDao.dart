import 'package:floor/floor.dart';
import 'ToDoItem.dart';

@dao
abstract class ToDoDao {
  @Query('SELECT * FROM ToDoItem')
  Future<List<ToDoItem>> findAllToDos();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertToDoItem(ToDoItem item);

  @delete
  Future<void> deleteToDoItem(ToDoItem item);
}
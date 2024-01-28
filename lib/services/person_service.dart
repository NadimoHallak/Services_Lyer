import 'package:generac/data_state.dart';
import 'package:generac/model.dart';
import 'package:generac/model/person_model.dart';

class UserService {
  getUser() => GeneracService<UserModel>()
      .getData(baseUrl: 'https://jsonplaceholder.typicode.com/users/1');
}

import 'package:backend_flutterando/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:backend_flutterando/src/features/user/datasources/user_datasource.dart';
import 'package:backend_flutterando/src/features/user/errors/user_exception.dart';
import 'package:backend_flutterando/src/features/user/models/user_model.dart';
import 'package:backend_flutterando/src/features/user/models/userparams_model.dart';

class UserRepository {
  final UserDataSource userDataSource;
  final BCryptService bcrypt;

  UserRepository(this.userDataSource, this.bcrypt);

  Future<List<UserModel>> getAllUsers() async {
    final users = await userDataSource.getAllUsers();

    return users.map((user) => UserModel.fromMap(user!)).toList();
  }

  Future<UserModel> getUserById(id) async {
    final user = await userDataSource.getUserById(id);

    if (user == null) {
      throw UserException(403, "Nenhum usuário encontrado para o ID $id");
    }

    return UserModel.fromMap(user);
  }

  Future<UserModel> createUser(UserParamsModel userParamsModel) async {
    userParamsModel.password = bcrypt.generateHash(
      userParamsModel.password.toString(),
    );

    final user = await userDataSource.createUser(userParamsModel.toMap());

    if (user == null) {
      throw UserException(403, "Não foi possível criar o usuário");
    }

    return UserModel.fromMap(user);
  }

  Future<UserModel> updateUser(UserParamsModel userParamsModel) async {
    final user = await userDataSource.createUser(userParamsModel.toMap());

    if (user == null) {
      throw UserException(403, "Não foi possível atualizar o usuário");
    }

    return UserModel.fromMap(user);
  }

  Future deleteUser(id) async {
    await userDataSource.deleteUser(id);
  }
}

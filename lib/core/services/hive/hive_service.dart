import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rentease/core/constants/hive_table_constants.dart';
import 'package:rentease/features/auth/data/models/auth_hive_model.dart';

class HiveSercice {
  //database init
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();

    final path = '${directory.path}/${HiveTableConstants.dbName}';
    Hive.init(path);
    _registerAdapter();
  }

  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstants.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
  }

  Future<void> openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstants.authTable);
  }

  //close Boxes
  Future<void> close() async {
    await Hive.close();
  }

  //==============Auth Queries ================
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstants.authTable);

  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
    return model;
  }
  //login User
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users = _authBox.values.where(
      (user) => user.email == email && user.password == password,
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }
   // logout
  Future<void> logoutUser() async {}

    //get current user
  AuthHiveModel? getCurrentUser(String authId) {
    return _authBox.get(authId);
  }
    //is email exists
  bool isEmailExists(String email) {
    final users = _authBox.values.where((user) => user.email == email);
    return users.isNotEmpty;
  }
}

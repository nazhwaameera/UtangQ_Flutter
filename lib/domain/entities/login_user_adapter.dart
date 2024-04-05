import 'package:hive/hive.dart';
import 'package:utangq_app/domain/entities/login_user.dart';

class LoginUserAdapter extends TypeAdapter<LoginUser> {
  @override
  final int typeId = 0; // Unique id for the adapter

  @override
  LoginUser read(BinaryReader reader) {
    // Implement deserialization logic
    return LoginUser(
      userId: reader.readInt(),
      username: reader.readString(),
      token: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, LoginUser obj) {
    // Implement serialization logic
    writer.writeInt(obj.userId); // Provide a default value if userId is null
    writer.writeString(obj.username); // Provide a default value if username is null
    writer.writeString(obj.token); // Provide a default value if token is null
  }
}

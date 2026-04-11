abstract class Usecases<Type, Param> {
  Future<Type> call({Param param});
}

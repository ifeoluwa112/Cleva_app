import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_app/app/app_locator.dart';
import 'package:test_app/core/core.dart';

part 'user_event.dart';
part 'user_state.dart';
part 'user_bloc.freezed.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    UserRepository? userRepository,
  })  : _userRepository = userRepository ?? locator<UserRepository>(),
        super(const _Initial()) {
    on<_GetUsers>(_onGetUsers);
  }

  // User Repository
  final UserRepository _userRepository;

  /// Get users by calling [getUsers] in the [_userRepository]
  /// It emits the [_Loading] state before calling the function
  /// It emits the [_Loaded] state and pass in the response which is the list
  /// of users into it
  /// It emits the [_Error] state when it fails on [UserException]
  Future<void> _onGetUsers(
    _GetUsers event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(_Loading());
      final users = await _userRepository.getUsers();
      emit(_Loaded(user: users));
    } on UserException catch (e) {
      emit(_Error(error: e.message));
    }
  }
}

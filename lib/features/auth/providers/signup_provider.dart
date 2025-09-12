import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_repository_provider.dart';


class SignupState {
  final bool fetching;
  final bool creating;
  final Map<String, dynamic>? employeeData;
  final String? error;
  final bool accountCreated;

  SignupState({
    this.fetching = false,
    this.creating = false,
    this.employeeData,
    this.error,
    this.accountCreated = false,
  });

  SignupState copyWith({
    bool? fetching,
    bool? creating,
    Map<String, dynamic>? employeeData,
    String? error,
    bool? accountCreated,
  }) {
    return SignupState(
      fetching: fetching ?? this.fetching,
      creating: creating ?? this.creating,
      employeeData: employeeData ?? this.employeeData,
      error: error,
      accountCreated: accountCreated ?? this.accountCreated,
    );
  }
}

class SignupNotifier extends StateNotifier<SignupState> {
  final Ref ref;
  SignupNotifier(this.ref) : super(SignupState());
  Future<void> fetchEmployee(String staffId) async {
    state = state.copyWith(fetching: true, error: null);
    try {
      final repo = ref.read(authRepositoryProvider);
      final data = await repo.fetchEmployeeDetails(staffId);
      state = state.copyWith(fetching: false, employeeData: data);
    } catch (e) {
      state = state.copyWith(fetching: false, error: e.toString());
    }
  }

  Future<void> createAccount({
    required String email,
    required String bvn,
  }) async {
    if (state.employeeData == null) return;

    // Merge fetched data + editable fields
    final payload = {
      "first_name": state.employeeData!['firstname'],
      "last_name": state.employeeData!['lastname'],
      "phone": state.employeeData!['phone'],
      "bvn": bvn,
      "employee_id": state.employeeData!['employee_number'],
    };

    if (email.isNotEmpty) {
      payload["email"] = email;
    }

    // state = state.copyWith(creating: true, error: null);
    // try {
    //   final repo = ref.read(authRepositoryProvider);
    //   await repo.createAccount(payload);
    //   state = state.copyWith(creating: false, accountCreated: true);
    // } catch (e) {
    //   state = state.copyWith(creating: false, error: e.toString());
    // }

    state = state.copyWith(creating: true, error: null);
    try {
    final repo = ref.read(authRepositoryProvider);
    await repo.createAccount(payload);
    state = state.copyWith(creating: false, accountCreated: true);
  } catch (e) {
    String errorMessage = e.toString();

    // Detect duplicate phone/email from the error string
    if (errorMessage.contains('Duplicate entry')) {
      if (errorMessage.contains('phone')) {
        errorMessage = "This phone number is already registered. Please login instead.";
      } else if (errorMessage.contains('email')) {
        errorMessage = "This email is already registered. Please login instead.";
      } else {
        errorMessage = "An account with this information already exists.";
      }
    }

    state = state.copyWith(creating: false, error: errorMessage);
  }
  }
}


final signupProvider = StateNotifierProvider<SignupNotifier, SignupState>((
  ref,
) {
  return SignupNotifier(ref);
});

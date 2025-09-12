// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'auth_repository_provider.dart';


// class SignupState {
//   final bool fetching;
//   final bool creating;
//   final Map<String, dynamic>? employeeData;
//   final String? error;
//   final bool accountCreated;

//   SignupState({
//     this.fetching = false,
//     this.creating = false,
//     this.employeeData,
//     this.error,
//     this.accountCreated = false,
//   });

//   SignupState copyWith({
//     bool? fetching,
//     bool? creating,
//     Map<String, dynamic>? employeeData,
//     String? error,
//     bool? accountCreated,
//   }) {
//     return SignupState(
//       fetching: fetching ?? this.fetching,
//       creating: creating ?? this.creating,
//       employeeData: employeeData ?? this.employeeData,
//       error: error,
//       accountCreated: accountCreated ?? this.accountCreated,
//     );
//   }
// }

// class SignupNotifier extends StateNotifier<SignupState> {
//   final Ref ref;
//   SignupNotifier(this.ref) : super(SignupState());
//   Future<void> fetchEmployee(String staffId) async {
//     state = state.copyWith(fetching: true, error: null);
//     try {
//       final repo = ref.read(authRepositoryProvider);
//       final data = await repo.fetchEmployeeDetails(staffId);
//       state = state.copyWith(fetching: false, employeeData: data);
//     } catch (e) {
//       state = state.copyWith(fetching: false, error: e.toString());
//     }
//   }



// Future<void> createAccount({
//   required String email,
//   required String bvn,
// }) async {
//   if (state.employeeData == null) return;

//   final payload = {
//     "first_name": state.employeeData!['firstname'],
//     "last_name": state.employeeData!['lastname'],
//     "phone": state.employeeData!['phone'],
//     "bvn": bvn,
//     "employee_id": state.employeeData!['employee_number'],
//   };

//   if (email.isNotEmpty) payload["email"] = email;

//   state = state.copyWith(creating: true, error: null);

//   try {
//     final repo = ref.read(authRepositoryProvider);
//     final result = await repo.createAccount(payload);

//     // ✅ Check backend status
//     if (result["status"] == "success") {
//       state = state.copyWith(creating: false, accountCreated: true);
//     } else {
//       // backend returned error but HTTP was still 200
//       final message = result["message"] ?? "Unknown error occurred.";
//       state = state.copyWith(
//         creating: false,
//         error: _mapErrorToFriendlyMessage(message.toString()),
//       );
//     }
//   } catch (e) {
//     String errorMessage = "Something went wrong. Please try again.";

//     if (e is DioException) {
//       final data = e.response?.data;
//       if (data is Map<String, dynamic>) {
//         if (data["message"] is String) {
//           errorMessage = _mapErrorToFriendlyMessage(data["message"]);
//         } else if (data["message"] is List) {
//           errorMessage = (data["message"] as List).join(", ");
//         }
//       }
//     } else {
//       errorMessage = e.toString();
//     }

//     state = state.copyWith(creating: false, error: errorMessage);
//   }
// }


// String _mapErrorToFriendlyMessage(String message) {
//   if (message.contains("employee_id")) {
//     return "An account with this employee ID already exists. Please login instead.";
//   } else if (message.contains("phone")) {
//     return "This phone number is already registered. Please login instead.";
//   } else if (message.contains("email")) {
//     return "This email is already registered. Please login instead.";
//   }
//   return message;
// }


// }


// final signupProvider = StateNotifierProvider<SignupNotifier, SignupState>((
//   ref,
// ) {
//   return SignupNotifier(ref);
// });





// signup_provider.dart
import 'package:dio/dio.dart';
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

  // Helper: parse message from backend wrapper or DioException.response.data
  String _parseMessageFromResponse(dynamic responseData) {
    if (responseData == null) return "Something went wrong";
    if (responseData is String) return responseData;
    if (responseData is Map<String, dynamic>) {
      final msg = responseData['message'];
      if (msg is String) return msg;
      if (msg is List) return msg.join(", ");
    }
    return responseData.toString();
  }

  String _mapErrorToFriendlyMessage(String message) {
    final m = message.toLowerCase();
    if (m.contains("employee_id") || m.contains("employee id")) {
      return "An account with this employee ID already exists. Please login instead.";
    } else if (m.contains("phone")) {
      return "This phone number is already registered. Please login instead.";
    } else if (m.contains("email")) {
      return "This email is already registered. Please login instead.";
    } else if (m.contains("employee not found") || m.contains("not found")) {
      return "Employee not found. Check Staff ID and try again.";
    }
    return message;
  }

  Future<void> fetchEmployee(String staffId) async {
    state = state.copyWith(fetching: true, error: null);
    try {
      final repo = ref.read(authRepositoryProvider);
      final responseWrapper = await repo.fetchEmployeeDetails(staffId);

      // If backend uses wrapper { status: 'success'|'error', data: {...}, message: ... }
      if (responseWrapper['status'] is String &&
          responseWrapper['status'].toString().toLowerCase() != 'success') {
        final message = _parseMessageFromResponse(responseWrapper);
        state = state.copyWith(
          fetching: false,
          error: _mapErrorToFriendlyMessage(message),
        );
        return;
      }

      // success case: extract inner data
      final data = responseWrapper['data'];
      if (data is Map<String, dynamic>) {
        state = state.copyWith(fetching: false, employeeData: data);
      } else {
        // unexpected shape
        state = state.copyWith(
          fetching: false,
          error: "Unexpected response from server when fetching employee.",
        );
      }
    } on DioException catch (e) {
      // backend returned non-2xx (e.response?.data likely contains wrapper)
      final responseData = e.response?.data;
      final parsed = _parseMessageFromResponse(responseData);
      state = state.copyWith(
        fetching: false,
        error: _mapErrorToFriendlyMessage(parsed),
      );
    } catch (e) {
      state = state.copyWith(fetching: false, error: e.toString());
    }
  }

  Future<void> createAccount({
    required String? email,
    required String bvn,
  }) async {
    if (state.employeeData == null) return;

    final payload = {
      "first_name": state.employeeData!['firstname'],
      "last_name": state.employeeData!['lastname'],
      "phone": state.employeeData!['phone'],
      "bvn": bvn,
      "employee_id": state.employeeData!['employee_number'],
    };

    if (email != null && email.isNotEmpty) payload["email"] = email;

    state = state.copyWith(creating: true, error: null);

    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.createAccount(payload);

      // If backend uses wrapper with status
      if (result['status'] is String &&
          result['status'].toString().toLowerCase() == 'success') {
        state = state.copyWith(creating: false, accountCreated: true);
        return;
      }

      // Backend returned 2xx but wrapper indicates error or unknown shape
      final message = _parseMessageFromResponse(result);
      state = state.copyWith(
        creating: false,
        error: _mapErrorToFriendlyMessage(message),
      );
    } on DioException catch (e) {
      final responseData = e.response?.data;
      final parsed = _parseMessageFromResponse(responseData);
      state = state.copyWith(
        creating: false,
        error: _mapErrorToFriendlyMessage(parsed),
      );
    } catch (e) {
      state = state.copyWith(creating: false, error: e.toString());
    }
  }
}

final signupProvider = StateNotifierProvider<SignupNotifier, SignupState>((ref) {
  return SignupNotifier(ref);
});

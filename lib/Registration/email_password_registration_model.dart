import 'package:flutter/foundation.dart';
import 'package:todo_app/SignIn/validator.dart';
import 'package:todo_app/components/strings.dart';
import 'package:todo_app/services/auth_service.dart';

enum EmailPasswordRegisterFormType { signIn, register }

class EmailPasswordRegisterModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailPasswordRegisterModel({
    @required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailPasswordRegisterFormType.register,
    this.isLoading = false,
    this.submitted = false,
  });

  final AuthService auth;

  String email;
  String password;
  EmailPasswordRegisterFormType formType;
  bool isLoading;
  bool submitted;

  Future<bool> submit() async {
    try {
      updateWith(submitted: true);
      if (!canSubmit) {
        return false;
      }
      updateWith(isLoading: true);
      switch (formType) {
        case EmailPasswordRegisterFormType.register:
          await auth.createUserWithEmailAndPassword(email, password);
          break;
        case EmailPasswordRegisterFormType.signIn:
          await auth.signInWithEmailAndPassword(email, password);
          break;
      }
      return true;
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateFormType(EmailPasswordRegisterFormType formType) {
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateWith({
    String email,
    String password,
    EmailPasswordRegisterFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  String get passwordLabelText {
    if (formType == EmailPasswordRegisterFormType.register) {
      return Strings.password8CharactersLabel;
    }
    return Strings.passwordLabel;
  }

  // Getters
  String get primaryButtonText {
    return <EmailPasswordRegisterFormType, String>{
      EmailPasswordRegisterFormType.register: Strings.createAnAccount,
      EmailPasswordRegisterFormType.signIn: 'Sign In',
    }[formType];
  }


  String get secondaryButtonText {
    return <EmailPasswordRegisterFormType, String>{
      EmailPasswordRegisterFormType.register: Strings.haveAnAccount,
      EmailPasswordRegisterFormType.signIn: Strings.needAnAccount,
    }[formType];
  }

  EmailPasswordRegisterFormType get secondaryActionFormType {
    return <EmailPasswordRegisterFormType, EmailPasswordRegisterFormType>{
      EmailPasswordRegisterFormType.register: EmailPasswordRegisterFormType.signIn,
      EmailPasswordRegisterFormType.signIn: EmailPasswordRegisterFormType.register,
    }[formType];
  }

  String get errorAlertTitle {
    return <EmailPasswordRegisterFormType, String>{
      EmailPasswordRegisterFormType.register: Strings.registrationFailed,
      EmailPasswordRegisterFormType.signIn: Strings.signInFailed,
    }[formType];
  }

  String get title {
    return <EmailPasswordRegisterFormType, String>{
      EmailPasswordRegisterFormType.register: Strings.register,
      EmailPasswordRegisterFormType.signIn: Strings.signIn,
    }[formType];
  }

  bool get canSubmitEmail {
    return emailSubmitValidator.isValid(email);
  }

  bool get canSubmitPassword {
    if (formType == EmailPasswordRegisterFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  bool get canSubmit {
    final bool canSubmitFields =
    formType != EmailPasswordRegisterFormType.register ||
        formType != EmailPasswordRegisterFormType.signIn
        ? canSubmitEmail
        : canSubmitEmail && canSubmitPassword;
    return canSubmitFields && !isLoading;
  }

  String get emailErrorText {
    final bool showErrorText = submitted && !canSubmitEmail;
    final String errorText = email.isEmpty
        ? Strings.invalidEmailEmpty
        : Strings.invalidEmailErrorText;
    return showErrorText ? errorText : null;
  }

  String get passwordErrorText {
    final bool showErrorText = submitted && !canSubmitPassword;
    final String errorText = password.isEmpty
        ? Strings.invalidPasswordEmpty
        : Strings.invalidPasswordTooShort;
    return showErrorText ? errorText : null;
  }

  @override
  String toString() {
    return 'email: $email, password: $password, formType: $formType, isLoading: $isLoading, submitted: $submitted';
  }
}

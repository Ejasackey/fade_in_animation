import 'package:asydaworks_web/blocs/auth_fields_selector_cubit/auth_fields_selector_cubit.dart';
import 'package:asydaworks_web/shared/fade_in_animation.dart';
import 'package:asydaworks_web/shared/shared.dart';
import 'package:asydaworks_web/style.dart';
import 'package:fade_in_animation/fade_in_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginAuthFields extends StatelessWidget {
  LoginAuthFields({super.key});

  static bool isMobile = false;
  late AuthFieldsSelectorCubit _fieldsSelectorCubit;

  @override
  Widget build(BuildContext context) {
    _fieldsSelectorCubit = context.read<AuthFieldsSelectorCubit>();
    return BlocBuilder<AuthFieldsSelectorCubit, AuthFieldState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInAnimation( // Note, there's no delay index on this because the default is 0
              key: GlobalKey(),
              direction: AnimationDirection.rightward,
              reverse: state == AuthFieldState.loginOff,
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 40),
            FadeInAnimation(
              key: GlobalKey(),
              delayIndex: 1,
              direction: AnimationDirection.rightward,
              reverse: state == AuthFieldState.loginOff,
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () {},
                  icon: Icon(Icons.place),
                  label: Text(
                    'Continue with Google',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            FadeInAnimation(
              key: GlobalKey(),
              delayIndex: 2,
              direction: AnimationDirection.rightward,
              reverse: state == AuthFieldState.loginOff,
              child: textField(hint: 'Email'),
            ),
            SizedBox(height: 18),
            FadeInAnimation(
              key: GlobalKey(),
              delayIndex: 3,
              direction: AnimationDirection.rightward,
              reverse: state == AuthFieldState.loginOff,
              child: textField(hint: "Password"),
            ),
            SizedBox(height: 5),
            FadeInAnimation(
              key: GlobalKey(),
              delayIndex: 4,
              direction: AnimationDirection.rightward,
              reverse: state == AuthFieldState.loginOff,
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _fieldsSelectorCubit.navToChangePassword(),
                  child: Text(
                    "Forgot password",
                    style: TextStyle(
                        fontSize: 12,
                        color: white,
                        fontVariations: [FontVariation.weight(300)]),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            FadeInAnimation(
              key: GlobalKey(),
              delayIndex: 5,
              direction: AnimationDirection.rightward,
              reverse: state == AuthFieldState.loginOff,
              child: actionButton(label: 'Login', onPressed: () {}),
            ),
            SizedBox(height: 20),
            FadeInAnimation(
              key: GlobalKey(),
              delayIndex: 6,
              direction: AnimationDirection.rightward,
              reverse: state == AuthFieldState.loginOff,
              child: TextButton(
                onPressed: () => _fieldsSelectorCubit.navToSignUp(),
                child: Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    children: [
                      TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                              fontVariations: [FontVariation.weight(600)],
                              color: primaryColor))
                    ],
                  ),
                  style: TextStyle(
                      color: white,
                      fontVariations: [FontVariation.weight(300)]),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

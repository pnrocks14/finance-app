import 'dart:async';

import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import 'lock_controller.dart';

const int _pinLength = 4;

/// Unlock screen: PIN pad, plus the fingerprint key when it's turned on.
class UnlockScreen extends ConsumerStatefulWidget {
  const UnlockScreen({super.key});

  @override
  ConsumerState<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends ConsumerState<UnlockScreen> {
  String _entered = '';
  String? _message;
  bool _error = false;
  bool _busy = false;
  bool _biometric = false;
  DateTime? _lockedUntil;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    unawaited(_offerBiometric());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _offerBiometric() async {
    final controller = ref.read(lockControllerProvider.notifier);
    final offered = await controller.biometricOffered();
    if (!mounted) return;
    setState(() => _biometric = offered);
    if (offered) await controller.unlockWithBiometric();
  }

  Future<void> _onDigit(int d) async {
    if (_busy || _lockedUntil != null || _entered.length >= _pinLength) return;
    setState(() {
      _entered += '$d';
      _error = false;
    });
    if (_entered.length == _pinLength) await _submit();
  }

  Future<void> _submit() async {
    setState(() => _busy = true);
    final result = await ref
        .read(lockControllerProvider.notifier)
        .unlockWithPin(_entered);
    if (!mounted) return;
    switch (result) {
      case PinAccepted():
        return;
      case PinRejected(:final attemptsBeforeLockout):
        unawaited(HapticFeedback.heavyImpact());
        setState(() {
          _error = true;
          _message = attemptsBeforeLockout == 1
              ? "That's not it. One more try before a short pause."
              : "That's not it. Try again.";
        });
      case PinLockedOut(:final until):
        _startLockout(until);
    }
    setState(() {
      _entered = '';
      _busy = false;
    });
  }

  void _startLockout(DateTime until) {
    _lockedUntil = until;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final left = until.difference(DateTime.now());
      setState(() {
        if (left.isNegative) {
          _lockedUntil = null;
          _message = null;
          _ticker?.cancel();
        } else {
          _message = 'Too many tries. Try again in ${left.inSeconds + 1}s.';
        }
      });
    });
    setState(() {
      _error = true;
      _message = 'Too many tries. Taking a short pause.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return _PinScaffold(
      title: 'Welcome back',
      subtitle: 'Enter your PIN to open your finances.',
      entered: _entered.length,
      error: _error,
      message: _message,
      pad: PinPad(
        enabled: _lockedUntil == null && !_busy,
        onDigit: _onDigit,
        onBackspace: () => setState(() {
          if (_entered.isNotEmpty) {
            _entered = _entered.substring(0, _entered.length - 1);
          }
        }),
        onBiometric: _biometric
            ? () => ref
                  .read(lockControllerProvider.notifier)
                  .unlockWithBiometric()
            : null,
      ),
    );
  }
}

/// First launch: choose a PIN, confirm it, then choose whether to use
/// fingerprint unlock.
class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

enum _SetupStep { choose, confirm, biometric }

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  _SetupStep _step = _SetupStep.choose;
  String _first = '';
  String _entered = '';
  String? _message;
  bool _error = false;

  Future<void> _onDigit(int d) async {
    if (_entered.length >= _pinLength) return;
    setState(() {
      _entered += '$d';
      _error = false;
    });
    if (_entered.length < _pinLength) return;

    if (_step == _SetupStep.choose) {
      setState(() {
        _first = _entered;
        _entered = '';
        _message = null;
        _step = _SetupStep.confirm;
      });
    } else if (_entered == _first) {
      final canUseBiometric = await ref
          .read(biometricAuthProvider)
          .isAvailable();
      if (!mounted) return;
      if (canUseBiometric) {
        setState(() => _step = _SetupStep.biometric);
      } else {
        await ref
            .read(lockControllerProvider.notifier)
            .setUpPin(_first, enableBiometric: false);
      }
    } else {
      unawaited(HapticFeedback.heavyImpact());
      setState(() {
        _error = true;
        _message = "Those didn't match. Let's start again.";
        _entered = '';
        _first = '';
        _step = _SetupStep.choose;
      });
    }
  }

  Future<void> _finish(bool biometric) => ref
      .read(lockControllerProvider.notifier)
      .setUpPin(_first, enableBiometric: biometric);

  @override
  Widget build(BuildContext context) {
    if (_step == _SetupStep.biometric) {
      return _BiometricChoice(onChoose: _finish);
    }
    final choosing = _step == _SetupStep.choose;
    return _PinScaffold(
      title: choosing ? 'Pick a 4-digit PIN' : 'Type it once more',
      subtitle: choosing
          ? 'Your money stays on this phone. The PIN keeps it yours.'
          : 'Just to be sure.',
      entered: _entered.length,
      error: _error,
      message: _message,
      pad: PinPad(
        onDigit: _onDigit,
        onBackspace: () => setState(() {
          if (_entered.isNotEmpty) {
            _entered = _entered.substring(0, _entered.length - 1);
          }
        }),
      ),
    );
  }
}

class _BiometricChoice extends StatelessWidget {
  const _BiometricChoice({required this.onChoose});

  final Future<void> Function(bool) onChoose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Space.screen),
          child: Column(
            children: [
              const Spacer(),
              Icon(Icons.fingerprint_rounded, size: 96, color: c.primary),
              const SizedBox(height: Space.xl),
              Text(
                'Unlock with your fingerprint?',
                style: theme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Space.s),
              Text(
                'Quicker than typing your PIN. You can change this later.',
                style: theme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              PillButton(
                label: 'Yes, use fingerprint',
                expand: true,
                onPressed: () => onChoose(true),
              ),
              const SizedBox(height: Space.s),
              PillButton(
                label: 'Not now',
                kind: PillButtonKind.quiet,
                expand: true,
                onPressed: () => onChoose(false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinScaffold extends StatelessWidget {
  const _PinScaffold({
    required this.title,
    required this.subtitle,
    required this.entered,
    required this.error,
    required this.message,
    required this.pad,
  });

  final String title;
  final String subtitle;
  final int entered;
  final bool error;
  final String? message;
  final Widget pad;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(Space.screen),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: Space.xxl),
                        const CoinsIllustration(size: 96),
                        const SizedBox(height: Space.xl),
                        Text(
                          title,
                          style: theme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: Space.s),
                        Text(
                          subtitle,
                          style: theme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: Space.xl),
                        PinDots(
                          filled: entered,
                          length: _pinLength,
                          error: error,
                        ),
                        const SizedBox(height: Space.m),
                        SizedBox(
                          height: 40,
                          child: message == null
                              ? null
                              : Text(
                                  message!,
                                  style: theme.bodyMedium?.copyWith(
                                    color: error ? c.over : null,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: Space.l),
                      child: pad,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

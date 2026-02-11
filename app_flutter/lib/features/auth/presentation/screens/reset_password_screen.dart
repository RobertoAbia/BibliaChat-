import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/route_constants.dart';
import '../providers/auth_provider.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Escuchar éxito para navegar a Login
    ref.listen<AuthNotifierState>(authNotifierProvider, (previous, next) {
      if (next.success) {
        _onPasswordChanged();
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.opaque,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Icono
                  Center(child: _buildIcon()),

                  const SizedBox(height: 32),

                  // Título
                  Center(
                    child: Text(
                      'Nueva contraseña',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtítulo
                  Center(
                    child: Text(
                      'Ingresa tu nueva contraseña para recuperar el acceso a tu cuenta',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Campo Nueva Contraseña
                  _buildPasswordField(),

                  const SizedBox(height: 20),

                  // Campo Confirmar Contraseña
                  _buildConfirmPasswordField(),

                  const SizedBox(height: 8),

                  // Mensaje de error
                  if (authState.errorMessage != null)
                    _buildErrorMessage(authState.errorMessage!),

                  const SizedBox(height: 32),

                  // Botón Cambiar Contraseña
                  _buildChangePasswordButton(authState.isLoading),
                ],
              ),
            ),
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.surfaceDark,
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.2),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Icon(
        Icons.lock_reset,
        size: 50,
        color: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.next,
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: InputDecoration(
        labelText: 'Nueva contraseña',
        labelStyle: const TextStyle(color: AppTheme.textSecondary),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: AppTheme.textSecondary,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: AppTheme.textSecondary,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        filled: true,
        fillColor: AppTheme.surfaceDark,
        helperText: 'Mínimo 6 caracteres',
        helperStyle: const TextStyle(color: AppTheme.textTertiary),
      ),
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingresa una contraseña';
        }
        if (value.length < 6) {
          return 'Mínimo 6 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      focusNode: _confirmPasswordFocusNode,
      obscureText: _obscureConfirmPassword,
      textInputAction: TextInputAction.done,
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: InputDecoration(
        labelText: 'Confirmar contraseña',
        labelStyle: const TextStyle(color: AppTheme.textSecondary),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: AppTheme.textSecondary,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color: AppTheme.textSecondary,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
        filled: true,
        fillColor: AppTheme.surfaceDark,
      ),
      onFieldSubmitted: (_) => _onSubmit(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Confirma tu contraseña';
        }
        if (value != _passwordController.text) {
          return 'Las contraseñas no coinciden';
        }
        return null;
      },
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.errorColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppTheme.errorColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppTheme.errorColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangePasswordButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : _onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: AppTheme.textOnPrimary,
          disabledBackgroundColor: AppTheme.primaryColor.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.textOnPrimary,
                ),
              )
            : const Text(
                'Cambiar contraseña',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    ref.read(authNotifierProvider.notifier).reset();

    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    await ref.read(authNotifierProvider.notifier).updatePassword(
          _passwordController.text,
        );
  }

  Future<void> _onPasswordChanged() async {
    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Contraseña cambiada correctamente'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    // Cerrar sesión y navegar a Login para que confirme con nueva contraseña
    await ref.read(authNotifierProvider.notifier).signOut();

    if (mounted) {
      context.go(RouteConstants.login);
    }
  }
}

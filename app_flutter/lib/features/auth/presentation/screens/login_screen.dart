import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/route_constants.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Escuchar éxito para navegar
    ref.listen<AuthNotifierState>(authNotifierProvider, (previous, next) {
      if (next.success) {
        context.go(RouteConstants.home);
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.opaque,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 48, // 24 padding top + 24 bottom
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back button (alineado a la izquierda)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () => context.pop(),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppTheme.textPrimary,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.all(12),
                              ),
                            ),
                          ),

                          // Contenido central
                          Column(
                            children: [
                              const SizedBox(height: 8),

                              // Logo
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/images/splash_logo.png',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Título
                              Text(
                                'Bienvenido de vuelta',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      color: AppTheme.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),

                              const SizedBox(height: 8),

                              // Subtítulo
                              Text(
                                'Inicia sesión para recuperar tus\nconversaciones y progreso',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 28),

                              // Campo Email
                              _buildEmailField(),

                              const SizedBox(height: 16),

                              // Campo Password
                              _buildPasswordField(),

                              const SizedBox(height: 4),

                              // Olvidé contraseña
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _onForgotPassword,
                                  child: const Text(
                                    '¿Olvidaste tu contraseña?',
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),

                              // Mensaje de error
                              if (authState.errorMessage != null)
                                _buildErrorMessage(authState.errorMessage!),
                            ],
                          ),

                          // Botones abajo
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: Column(
                              children: [
                                // Botón Login
                                _buildLoginButton(authState.isLoading),

                                const SizedBox(height: 20),

                                // Divider
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: const Color(0xFFD0D8E4),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        'o',
                                        style: TextStyle(
                                          color: AppTheme.textTertiary,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: const Color(0xFFD0D8E4),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // Botón Empezar de nuevo
                                _buildStartFreshButton(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: const TextStyle(color: AppTheme.textSecondary),
        prefixIcon: const Icon(
          Icons.email_outlined,
          color: AppTheme.textSecondary,
        ),
        filled: true,
        fillColor: AppTheme.surfaceDark,
      ),
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingresa tu email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: InputDecoration(
        labelText: 'Contraseña',
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
      ),
      onFieldSubmitted: (_) => _onLogin(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingresa tu contraseña';
        }
        return null;
      },
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
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

  Widget _buildLoginButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : _onLogin,
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
                'Iniciar sesión',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildStartFreshButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _onStartFresh,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.textSecondary,
          side: BorderSide(
            color: AppTheme.surfaceLight.withOpacity(0.5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Crear cuenta',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _onLogin() async {
    ref.read(authNotifierProvider.notifier).reset();

    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    await ref.read(authNotifierProvider.notifier).signInWithEmail(
          _emailController.text,
          _passwordController.text,
        );
  }

  void _onForgotPassword() {
    // TODO: Implementar pantalla de recuperación de contraseña
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Ingresa tu email primero'),
          backgroundColor: AppTheme.warningColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // Por ahora, enviar email de recuperación directamente
    ref.read(authNotifierProvider.notifier).sendPasswordResetEmail(email).then((success) {
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Email de recuperación enviado'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });
  }

  Future<void> _onStartFresh() async {
    // Crear sesión anónima y ir a onboarding
    final success = await ref.read(authNotifierProvider.notifier).signInAnonymously();
    if (success && mounted) {
      context.go(RouteConstants.onboarding);
    }
  }
}

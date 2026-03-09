import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/route_constants.dart';
import '../providers/auth_provider.dart';

class LinkEmailScreen extends ConsumerStatefulWidget {
  const LinkEmailScreen({super.key});

  @override
  ConsumerState<LinkEmailScreen> createState() => _LinkEmailScreenState();
}

class _LinkEmailScreenState extends ConsumerState<LinkEmailScreen> {
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

    // Escuchar errores y éxito
    ref.listen<AuthNotifierState>(authNotifierProvider, (previous, next) {
      if (next.success) {
        // Navegar a pantalla de verificación con el email como parámetro
        final encodedEmail = Uri.encodeComponent(_emailController.text);
        context.pushReplacement('${RouteConstants.verifyEmail}?email=$encodedEmail');
      }
      // Si el error es "same_password", redirigir a verificación
      if (next.errorCode == 'same_password') {
        final encodedEmail = Uri.encodeComponent(_emailController.text);
        context.pushReplacement('${RouteConstants.verifyEmail}?email=$encodedEmail');
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  IconButton(
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

                  const SizedBox(height: 32),

                  // Icono con glow dorado
                  Center(child: _buildIcon()),

                  const SizedBox(height: 32),

                  // Título
                  Text(
                    'Guarda tu cuenta',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 12),

                  // Subtítulo explicativo
                  Text(
                    'Vincula un email para no perder tus conversaciones, racha y progreso si cambias de dispositivo.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                  ),

                  const SizedBox(height: 40),

                  // Campo Email
                  _buildEmailField(),

                  const SizedBox(height: 20),

                  // Campo Password
                  _buildPasswordField(),

                  const SizedBox(height: 8),

                  // Hint de password
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      'Mínimo 6 caracteres',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textTertiary,
                          ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Mensaje de error
                  if (authState.errorMessage != null)
                    _buildErrorMessage(authState.errorMessage!),

                  const SizedBox(height: 24),

                  // Botón Guardar
                  _buildSaveButton(authState.isLoading),

                  const SizedBox(height: 24),

                  // Info de privacidad
                  Center(
                    child: Text(
                      'Tu email solo se usará para iniciar sesión.\nNo compartimos tu información.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textTertiary,
                          ),
                    ),
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

  Widget _buildIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppTheme.goldGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Icon(
        Icons.shield_outlined,
        size: 50,
        color: AppTheme.textOnPrimary,
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
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Ingresa un email válido';
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
      onFieldSubmitted: (_) => _onSave(),
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

  Widget _buildErrorMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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

  Widget _buildSaveButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : _onSave,
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
                'Guardar mi cuenta',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _onSave() async {
    // Resetear estado previo
    ref.read(authNotifierProvider.notifier).reset();

    // Validar formulario
    if (!_formKey.currentState!.validate()) return;

    // Ocultar teclado
    FocusScope.of(context).unfocus();

    // Intentar vincular email
    await ref.read(authNotifierProvider.notifier).linkEmail(
          _emailController.text,
          _passwordController.text,
        );
  }
}

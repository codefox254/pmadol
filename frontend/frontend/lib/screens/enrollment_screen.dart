// ============================================
// lib/screens/enrollment_screen.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/service_models.dart';
import '../models/enrollment_models.dart';
import '../providers/enrollment_provider.dart';
import '../config/api_config.dart';

class EnrollmentScreen extends StatefulWidget {
  final Service service;

  const EnrollmentScreen({
    required this.service,
    super.key,
  });

  @override
  State<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends State<EnrollmentScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _mpesaController;
  bool _subscribedToNewsletter = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _mpesaController = TextEditingController();

    Future.microtask(() {
      context.read<EnrollmentProvider>().loadPaymentInfo();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _mpesaController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final enrollment = Enrollment(
      serviceId: widget.service.id,
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      mpesaMessage: _mpesaController.text.trim(),
      subscribedToNewsletter: _subscribedToNewsletter,
    );

    context.read<EnrollmentProvider>().submitEnrollment(enrollment).then((success) {
      if (success) {
        _showSuccessDialog();
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF5886BF).withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 48,
                  color: Color(0xFF5886BF),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Enrollment Submitted!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0B131E),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                context.read<EnrollmentProvider>().successMessage ?? 'Your enrollment has been submitted successfully.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF707781),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF5886BF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What happens next:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0B131E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildNextStepText('1. We review your submission'),
                    _buildNextStepText('2. You\'ll receive an approval email'),
                    _buildNextStepText('3. Get access to your enrollment'),
                    _buildNextStepText('4. Receive our latest newsletters'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5886BF),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Back to Services',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextStepText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF404957),
          height: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5886BF),
        elevation: 0,
        title: Text(
          'Enroll in ${widget.service.name}',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<EnrollmentProvider>(
        builder: (context, enrollProvider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 80,
                vertical: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildServiceCard(isMobile),
                  const SizedBox(height: 40),
                  if (enrollProvider.error != null) ...[
                    _buildErrorBanner(enrollProvider.error!, isMobile),
                    const SizedBox(height: 24),
                  ],
                  _buildPaymentInfoCard(enrollProvider, isMobile),
                  const SizedBox(height: 32),
                  _buildEnrollmentForm(enrollProvider, isMobile),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceCard(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Details',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0B131E),
            ),
          ),
          const SizedBox(height: 16),
          _buildServiceRow('Service', widget.service.name),
          const SizedBox(height: 12),
          _buildServiceRow('Duration', widget.service.duration),
          if (widget.service.price != null) ...[
            const SizedBox(height: 12),
            _buildServiceRow(
              'Price',
              'KES ${widget.service.price!.toStringAsFixed(2)}',
            ),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF5886BF).withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.service.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF404957),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF707781),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF0B131E),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner(String error, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: Colors.red.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfoCard(EnrollmentProvider enrollProvider, bool isMobile) {
    if (enrollProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF5886BF)),
      );
    }

    final paymentInfo = enrollProvider.paymentInfo;
    if (paymentInfo == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.withOpacity(0.3)),
        ),
        child: Text(
          'Payment information not available. Please contact support.',
          style: TextStyle(color: Colors.amber.shade700),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Information',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0B131E),
            ),
          ),
          const SizedBox(height: 16),
          _buildPaymentRow('Amount Due', 'KES ${paymentInfo.amount.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF5886BF).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF5886BF).withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Send payment to:',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF707781),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  paymentInfo.mpesaNumber,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5886BF),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  paymentInfo.mpesaName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF707781),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info, size: 18, color: Colors.amber.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'After payment, enter the M-Pesa message in the form below to complete your enrollment.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.amber.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF707781),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF5886BF),
          ),
        ),
      ],
    );
  }

  Widget _buildEnrollmentForm(EnrollmentProvider enrollProvider, bool isMobile) {
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE1E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enrollment Form',
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0B131E),
              ),
            ),
            const SizedBox(height: 24),
            _buildFormField(
              label: 'Full Name *',
              controller: _nameController,
              hint: 'Enter your full name',
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Full name is required';
                if ((value?.length ?? 0) < 3) return 'Name must be at least 3 characters';
                return null;
              },
            ),
            const SizedBox(height: 18),
            _buildFormField(
              label: 'Email Address *',
              controller: _emailController,
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Email is required';
                if (!value!.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 18),
            _buildFormField(
              label: 'Phone Number *',
              controller: _phoneController,
              hint: 'e.g., +254701234567',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Phone number is required';
                if ((value?.length ?? 0) < 10) return 'Enter a valid phone number';
                return null;
              },
            ),
            const SizedBox(height: 18),
            _buildFormField(
              label: 'M-Pesa Message *',
              controller: _mpesaController,
              hint: 'Copy the message received after payment',
              maxLines: 2,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'M-Pesa message is required';
                return null;
              },
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF5886BF).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF5886BF).withOpacity(0.2)),
              ),
              child: CheckboxListTile(
                value: _subscribedToNewsletter,
                onChanged: (val) {
                  setState(() {
                    _subscribedToNewsletter = val ?? true;
                  });
                },
                title: const Text(
                  'Subscribe to our newsletters',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0B131E),
                  ),
                ),
                subtitle: const Text(
                  'Stay updated with our latest news and updates',
                  style: TextStyle(fontSize: 12, color: Color(0xFF707781)),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: const Color(0xFF5886BF),
                checkColor: Colors.white,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: enrollProvider.isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5886BF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBackgroundColor: const Color(0xFF5886BF).withOpacity(0.5),
                ),
                child: enrollProvider.isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Submit Enrollment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EFF7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'By enrolling, you agree to our terms and conditions. We take your privacy seriously.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF404957),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0B131E),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFB0B8C1)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE1E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE1E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF5886BF), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF0B131E),
          ),
        ),
      ],
    );
  }
}

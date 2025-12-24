// ============================================
// lib/widgets/checkout_form.dart
// Comprehensive Checkout Form Widget
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shop_models.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';
import '../config/api_config.dart';

class CheckoutForm extends StatefulWidget {
  final Cart cart;
  final VoidCallback? onOrderCreated;

  const CheckoutForm({
    Key? key,
    required this.cart,
    this.onOrderCreated,
  }) : super(key: key);

  @override
  State<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;
  late TextEditingController _notesController;

  String _paymentMethod = 'cod'; // Pay on delivery (POD)
  String? _resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return '${ApiConfig.baseUrl}$path';
  }
  bool _isSubmitting = false;
  bool _agreeTerms = false;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;

    _nameController = TextEditingController(
      text: user?.fullName ?? '',
    );
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _zipController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section: Delivery Information
              _buildSectionHeader('Delivery Information'),
              const SizedBox(height: 16),

              // Name
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                hint: 'Enter your full name',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Name is required';
                  if ((value?.length ?? 0) < 3)
                    return 'Name must be at least 3 characters';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Phone
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: 'Enter your phone number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Phone is required';
                  if (!RegExp(r'^\d{10,}$').hasMatch(value!))
                    return 'Enter a valid phone number';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Email
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter your email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Email is required';
                  if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value!)) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Address
              _buildTextField(
                controller: _addressController,
                label: 'Street Address',
                hint: 'Enter your street address',
                icon: Icons.location_on_outlined,
                maxLines: 2,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Address is required';
                  if ((value?.length ?? 0) < 5)
                    return 'Address must be at least 5 characters';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // City
              _buildTextField(
                controller: _cityController,
                label: 'City',
                hint: 'Enter your city',
                icon: Icons.location_city_outlined,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'City is required';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // State
              _buildTextField(
                controller: _stateController,
                label: 'State/Province',
                hint: 'Enter your state',
                icon: Icons.map_outlined,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'State is required';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // ZIP Code
              _buildTextField(
                controller: _zipController,
                label: 'ZIP/Postal Code',
                hint: 'Enter your ZIP code',
                icon: Icons.markunread_mailbox_outlined,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'ZIP code is required';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Section: Payment Method
              _buildSectionHeader('Payment Method'),
              const SizedBox(height: 16),
              _buildPaymentMethodOption(
                value: 'cod',
                title: 'Pay on Delivery (POD)',
                description: 'Pay when your order arrives',
              ),
              const SizedBox(height: 20),

              // Section: Additional Notes
              _buildSectionHeader('Additional Notes (Optional)'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _notesController,
                label: 'Special Instructions',
                hint: 'Any special delivery instructions?',
                icon: Icons.note_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Order Summary
              _buildOrderSummary(),
              const SizedBox(height: 20),

              // Terms Agreement
              _buildTermsCheckbox(),
              const SizedBox(height: 24),

              // Submit Button
              Consumer<OrderProvider>(
                builder: (context, orderProvider, _) {
                  return SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _agreeTerms && !_isSubmitting
                          ? _submitOrder
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5886BF),
                        disabledBackgroundColor: const Color(0xFFCED5E0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isSubmitting || orderProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Text(
                              'Place Order',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Error message
              Consumer<OrderProvider>(
                builder: (context, orderProvider, _) {
                  if (orderProvider.error != null) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFCA5A5)),
                      ),
                      child: Text(
                        orderProvider.error!,
                        style: const TextStyle(
                          color: Color(0xFFDC2626),
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F2937),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Color(0xFF9CA3AF)),
        filled: true,
        fillColor: Color(0xFFF9FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF5886BF), width: 2),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPaymentMethodOption({
    required String value,
    required String title,
    required String description,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _paymentMethod == value
              ? const Color(0xFF5886BF)
              : const Color(0xFFE5E7EB),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: _paymentMethod,
        onChanged: (newValue) {
          setState(() => _paymentMethod = newValue ?? 'cod');
        },
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF707781),
          ),
        ),
        activeColor: const Color(0xFF5886BF),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          _summaryRow('Subtotal', 'Rs. ${widget.cart.totalAmount.toStringAsFixed(2)}'),
          if (widget.cart.totalDiscount > 0) ...[
            const SizedBox(height: 8),
            _summaryRow(
              'Discount',
              '-Rs. ${widget.cart.totalDiscount.toStringAsFixed(2)}',
              isDiscount: true,
            ),
          ],
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _summaryRow(
            'Total Amount',
            'Rs. ${widget.cart.discountedAmount.toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: const Color(0xFF707781),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: isDiscount ? const Color(0xFFEF4444) : const Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _agreeTerms,
          onChanged: (value) {
            setState(() => _agreeTerms = value ?? false);
          },
          activeColor: const Color(0xFF5886BF),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() => _agreeTerms = !_agreeTerms);
            },
            child: const Text(
              'I agree to the terms and conditions',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF707781),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate() || !_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields and agree to terms'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final orderProvider = context.read<OrderProvider>();
      final success = await orderProvider.createOrder(
        deliveryName: _nameController.text.trim(),
        deliveryPhone: _phoneController.text.trim(),
        deliveryEmail: _emailController.text.trim(),
        deliveryAddress: _addressController.text.trim(),
        deliveryCity: _cityController.text.trim(),
        deliveryState: _stateController.text.trim(),
        deliveryZip: _zipController.text.trim(),
        paymentMethod: _paymentMethod,
        notes: _notesController.text.trim(),
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order placed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          if (widget.onOrderCreated != null) {
            widget.onOrderCreated!();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(orderProvider.error ?? 'Failed to place order'),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

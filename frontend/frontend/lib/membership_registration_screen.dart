// ============================================
// lib/membership_registration_screen.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/service_models.dart';
import 'services/membership_service.dart';

class MembershipRegistrationScreen extends StatefulWidget {
  const MembershipRegistrationScreen({super.key});

  @override
  State<MembershipRegistrationScreen> createState() =>
      _MembershipRegistrationScreenState();
}

class _MembershipRegistrationScreenState
    extends State<MembershipRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;
  bool _isChildRegistration = false;

  // Form controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentEmailController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  final _mpesaPhoneController = TextEditingController();
  final _transactionIdController = TextEditingController();

  String _selectedMemberType = 'regular';
  MembershipPlan? _selectedPlan;
  List<MembershipPlan> _membershipPlans = [];
  bool _consentGiven = false;
  bool _privacyAccepted = false;
  bool _newsletterSubscription = false;
  ClubMembership? _completedRegistration;

  @override
  void initState() {
    super.initState();
    _loadMembershipPlans();
  }

  Future<void> _loadMembershipPlans() async {
    setState(() => _isLoading = true);
    try {
      final plans = await MembershipService.getMembershipPlans();
      final defaultPlan = await MembershipService.getDefaultPlan();
      setState(() {
        _membershipPlans = plans;
        _selectedPlan = defaultPlan ?? (plans.isNotEmpty ? plans.first : null);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading plans: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    _parentNameController.dispose();
    _parentEmailController.dispose();
    _parentPhoneController.dispose();
    _mpesaPhoneController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Join Panari Chess Club',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _completedRegistration != null
                  ? _buildSuccessView()
                  : _buildRegistrationForm(),
            ),
    );
  }

  Widget _buildRegistrationForm() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 40),
          _buildStepIndicator(),
          const SizedBox(height: 32),
          Form(
            key: _formKey,
            child: _buildCurrentStepContent(),
          ),
          const SizedBox(height: 32),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.card_membership,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'Membership Registration',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Join our community of chess enthusiasts',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['Personal Info', 'Membership Plan', 'Payment', 'Consent'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(steps.length, (index) {
        final isActive = index == _currentStep;
        final isCompleted = index < _currentStep;

        return Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive || isCompleted
                    ? const Color(0xFF3B82F6)
                    : Colors.grey.withOpacity(0.3),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            if (index < steps.length - 1)
              Container(
                width: 40,
                height: 2,
                color: index < _currentStep
                    ? const Color(0xFF3B82F6)
                    : Colors.grey.withOpacity(0.3),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildMembershipPlanStep();
      case 2:
        return _buildPaymentStep();
      case 3:
        return _buildConsentStep();
      default:
        return Container();
    }
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Personal Information'),
        const SizedBox(height: 24),
        
        // Child registration toggle
        _buildGlassCard(
          child: SwitchListTile(
            title: const Text(
              'Registering for a child?',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Parent/guardian information will be required',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            value: _isChildRegistration,
            onChanged: (value) {
              setState(() => _isChildRegistration = value);
            },
            activeColor: const Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(height: 24),

        // Name fields
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _firstNameController,
                label: 'First Name',
                icon: Icons.person,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _lastNameController,
                label: 'Last Name',
                icon: Icons.person_outline,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Contact info
        _buildTextField(
          controller: _emailController,
          label: 'Email Address',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Required';
            if (!value!.contains('@')) return 'Invalid email';
            return null;
          },
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _ageController,
                label: 'Age',
                icon: Icons.cake,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  if (int.tryParse(value!) == null) return 'Invalid age';
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        _buildTextField(
          controller: _locationController,
          label: 'Location',
          icon: Icons.location_on,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),

        // Member type
        _buildGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Member Type',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: [
                  _buildChip('Regular', 'regular'),
                  _buildChip('Student', 'student'),
                  _buildChip('Senior', 'senior'),
                  _buildChip('VIP', 'vip'),
                ],
              ),
            ],
          ),
        ),

        // Parent information (if child registration)
        if (_isChildRegistration) ...[
          const SizedBox(height: 32),
          _buildSectionTitle('Parent/Guardian Information'),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _parentNameController,
            label: 'Parent/Guardian Name',
            icon: Icons.supervised_user_circle,
            validator: (value) => _isChildRegistration && (value?.isEmpty ?? true)
                ? 'Required for child registration'
                : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _parentEmailController,
            label: 'Parent/Guardian Email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (_isChildRegistration && (value?.isEmpty ?? true)) {
                return 'Required for child registration';
              }
              if (_isChildRegistration && !value!.contains('@')) {
                return 'Invalid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _parentPhoneController,
            label: 'Parent/Guardian Phone',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) => _isChildRegistration && (value?.isEmpty ?? true)
                ? 'Required for child registration'
                : null,
          ),
        ],
      ],
    );
  }

  Widget _buildMembershipPlanStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Choose Your Membership Plan'),
        const SizedBox(height: 24),
        if (_membershipPlans.isEmpty)
          _buildGlassCard(
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No membership plans available',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        else
          ...(_membershipPlans.map((plan) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildPlanCard(plan),
              ))),
      ],
    );
  }

  Widget _buildPlanCard(MembershipPlan plan) {
    final isSelected = _selectedPlan?.id == plan.id;

    return InkWell(
      onTap: () => setState(() => _selectedPlan = plan),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                )
              : LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.05),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : Colors.white.withOpacity(0.1),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plan.planTypeDisplay,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'KES ${plan.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (plan.isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'RECOMMENDED',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              plan.description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white24),
            const SizedBox(height: 16),
            ...plan.features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Payment Information'),
        const SizedBox(height: 24),
        _buildGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.payment,
                      color: Colors.greenAccent,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'M-Pesa Payment',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Secure payment via M-Pesa',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white24),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'KES ${_selectedPlan?.price.toStringAsFixed(0) ?? '0'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Payment Instructions:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildInstructionStep('1', 'Go to M-Pesa on your phone'),
              _buildInstructionStep('2', 'Select Lipa Na M-Pesa'),
              _buildInstructionStep('3', 'Select Pay Bill'),
              _buildInstructionStep('4', 'Enter Business Number: 123456'),
              _buildInstructionStep(
                  '5', 'Enter Account Number: Your Name'),
              _buildInstructionStep(
                  '6', 'Enter Amount: KES ${_selectedPlan?.price.toStringAsFixed(0) ?? '0'}'),
              _buildInstructionStep('7', 'Enter your M-Pesa PIN'),
              _buildInstructionStep(
                  '8', 'Copy the transaction ID and enter it below'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          controller: _mpesaPhoneController,
          label: 'M-Pesa Phone Number',
          icon: Icons.phone_android,
          keyboardType: TextInputType.phone,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _transactionIdController,
          label: 'M-Pesa Transaction ID',
          icon: Icons.receipt_long,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildConsentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Terms & Consent'),
        const SizedBox(height: 24),
        _buildGlassCard(
          child: Column(
            children: [
              CheckboxListTile(
                value: _consentGiven,
                onChanged: (value) {
                  setState(() => _consentGiven = value ?? false);
                },
                title: const Text(
                  'I consent to the club membership terms and conditions',
                  style: TextStyle(color: Colors.white),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: const Color(0xFF3B82F6),
              ),
              const Divider(color: Colors.white24),
              CheckboxListTile(
                value: _privacyAccepted,
                onChanged: (value) {
                  setState(() => _privacyAccepted = value ?? false);
                },
                title: const Text(
                  'I accept the privacy policy and data processing terms',
                  style: TextStyle(color: Colors.white),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: const Color(0xFF3B82F6),
              ),
              const Divider(color: Colors.white24),
              CheckboxListTile(
                value: _newsletterSubscription,
                onChanged: (value) {
                  setState(() => _newsletterSubscription = value ?? false);
                },
                title: const Text(
                  'I want to receive newsletters and updates (optional)',
                  style: TextStyle(color: Colors.white),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: const Color(0xFF3B82F6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Review Your Information',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildReviewItem('Name',
                  '${_firstNameController.text} ${_lastNameController.text}'),
              _buildReviewItem('Email', _emailController.text),
              _buildReviewItem('Phone', _phoneController.text),
              _buildReviewItem('Age', _ageController.text),
              _buildReviewItem('Location', _locationController.text),
              _buildReviewItem(
                  'Membership Plan', _selectedPlan?.name ?? 'Not selected'),
              _buildReviewItem('Amount',
                  'KES ${_selectedPlan?.price.toStringAsFixed(0) ?? '0'}'),
              if (_isChildRegistration) ...[
                const Divider(color: Colors.white24, height: 32),
                const Text(
                  'Parent/Guardian Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildReviewItem('Parent Name', _parentNameController.text),
                _buildReviewItem('Parent Email', _parentEmailController.text),
                _buildReviewItem('Parent Phone', _parentPhoneController.text),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_currentStep > 0)
          ElevatedButton.icon(
            onPressed: () {
              setState(() => _currentStep--);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
        else
          const SizedBox(),
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _handleNext,
          icon: Icon(_currentStep == 3 ? Icons.check : Icons.arrow_forward),
          label: Text(_currentStep == 3 ? 'Submit' : 'Next'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  void _handleNext() {
    if (_currentStep < 3) {
      if (_formKey.currentState?.validate() ?? false) {
        // Additional validation
        if (_currentStep == 1 && _selectedPlan == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a membership plan')),
          );
          return;
        }
        setState(() => _currentStep++);
      }
    } else {
      _submitRegistration();
    }
  }

  Future<void> _submitRegistration() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_consentGiven || !_privacyAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the required terms and conditions'),
        ),
      );
      return;
    }

    if (_selectedPlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a membership plan')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final request = ClubMembershipRequest(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        age: int.parse(_ageController.text),
        location: _locationController.text,
        memberType: _selectedMemberType,
        membershipPlanId: _selectedPlan!.id,
        isChildRegistration: _isChildRegistration,
        parentName: _isChildRegistration ? _parentNameController.text : null,
        parentEmail: _isChildRegistration ? _parentEmailController.text : null,
        parentPhone: _isChildRegistration ? _parentPhoneController.text : null,
        mpesaPhoneNumber: _mpesaPhoneController.text,
        paymentAmount: _selectedPlan!.price,
        consentGiven: _consentGiven,
        privacyAccepted: _privacyAccepted,
        newsletterSubscription: _newsletterSubscription,
      );

      final membership = await MembershipService.registerMembership(request);

      // Confirm payment if transaction ID is provided
      if (_transactionIdController.text.isNotEmpty) {
        final updatedMembership = await MembershipService.confirmPayment(
          membership.id,
          _transactionIdController.text,
        );
        setState(() {
          _completedRegistration = updatedMembership;
          _isLoading = false;
        });
      } else {
        setState(() {
          _completedRegistration = membership;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }
  }

  Widget _buildSuccessView() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.greenAccent,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Registration Successful!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome to Panari Chess Club',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildSuccessItem(
                  'Membership Number',
                  _completedRegistration?.membershipNumber ?? 'N/A',
                  Icons.card_membership,
                ),
                const SizedBox(height: 16),
                _buildSuccessItem(
                  'Name',
                  '${_completedRegistration?.firstName ?? ''} ${_completedRegistration?.lastName ?? ''}',
                  Icons.person,
                ),
                const SizedBox(height: 16),
                _buildSuccessItem(
                  'Email',
                  _completedRegistration?.email ?? 'N/A',
                  Icons.email,
                ),
                const SizedBox(height: 16),
                _buildSuccessItem(
                  'Status',
                  _completedRegistration?.registrationStatusDisplay ?? 'Pending',
                  Icons.info,
                ),
                if (_completedRegistration?.mpesaTransactionId != null) ...[
                  const SizedBox(height: 16),
                  _buildSuccessItem(
                    'Transaction ID',
                    _completedRegistration!.mpesaTransactionId!,
                    Icons.receipt,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.home),
            label: const Text('Return to Home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1E3A8A),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widgets
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: child,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF3B82F6)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.white70),
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildChip(String label, String value) {
    final isSelected = _selectedMemberType == value;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedMemberType = value);
      },
      backgroundColor: Colors.white.withOpacity(0.05),
      selectedColor: const Color(0xFF3B82F6),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.white70,
      ),
      checkmarkColor: Colors.white,
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

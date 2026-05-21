import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pcsloan/common/widgets/custom_loan_app_bar.dart';
import 'package:pcsloan/common/widgets/signup_input_field.dart';
import 'package:pcsloan/service/loan_service.dart';
import 'package:pcsloan/service/profile_sevice.dart';
import 'package:pcsloan/utils/local_storage.dart';

class DebitAuthorizationScreen extends ConsumerStatefulWidget {
  const DebitAuthorizationScreen({super.key});

  @override
  ConsumerState<DebitAuthorizationScreen> createState() =>
      _DebitAuthorizationScreen();
}

class _DebitAuthorizationScreen
    extends ConsumerState<DebitAuthorizationScreen> {
  final _profileService = ProfileService();
  bool _fetching = false;
  bool _verifying = false;
  bool _savingBank = false;
  bool _isBankSaved = false;
  final _loanService = LoanService();
  String accountNumber = "";
  String? _selectedBankName;
  String _selectedBankCode = "";
  List<Map<String, String>> _bankList = [];
  final _accountNumberController = TextEditingController();

  String? _verificationStatus;
  String? _verificationMessage;
  String? _accountName;

  @override
  void initState() {
    super.initState();
    _loadAccountNumber();
    loadBankList();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _loadAccountNumber() async {
    setState(() => _fetching = true);

    try {
      final result = await _profileService.fetchUserProfile();
      if (!mounted) return;
      if (result.isNotEmpty) {
        await LocalStorage.saveUser(result['data']);
        if (!mounted) return;
        setState(() {
          _accountNumberController.text =
              result['data']['bank_details']['account_number'] ?? '';
        });
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _fetching = false);
      }
    }
  }

  Future<void> loadBankList() async {
    setState(() => _fetching = true);

    try {
      final List<dynamic> bankListData = await _loanService.getBankList();

      if (!mounted) return;

      if (bankListData.isNotEmpty) {
        setState(() {
          _bankList =
              bankListData
                  .map((bank) {
                    if (bank is Map) {
                      return {
                        'code': bank['code']?.toString() ?? '',
                        'name': bank['name']?.toString() ?? '',
                      };
                    }
                    return {'code': '', 'name': ''};
                  })
                  .where(
                    (bank) =>
                        bank['code']!.isNotEmpty && bank['name']!.isNotEmpty,
                  )
                  .toList();
        });
      }
    } catch (e, stackTrace) {
      if (!mounted) return;
      _showSnackBar('Failed to load banks. Please try again.', isError: true);
    } finally {
      if (mounted) {
        setState(() => _fetching = false);
      }
    }
  }

  void _openBankPicker() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: !_verifying,
      enableDrag: !_verifying,
      elevation: 0,
      builder:
          (context) => BankPickerSheet(
            initiallySelectedCode: _selectedBankCode,
            bankList: _bankList,
            isLoading: _fetching,
            isFrozen: _verifying,
          ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedBankName = result['name'];
        _selectedBankCode = result['code']!;
        _verificationStatus = null;
        _verificationMessage = null;
        _accountName = null;
      });

      await _resolveBank();
    }
  }

  Future<void> _resolveBank() async {
    if (_selectedBankCode == null || _accountNumberController.text.isEmpty) {
      _showSnackBar(
        'Please select a bank and enter account number',
        isError: true,
      );
      return;
    }

    setState(() {
      _verifying = true;
      _verificationStatus = null;
      _verificationMessage = null;
      _accountName = null;
    });

    try {
      final result = await _loanService.verifyBankAccount(
        accountNumber: _accountNumberController.text,
        bankCode: _selectedBankCode,
      );
      if (!mounted) return;

      if (result != null && result.isNotEmpty) {
        final status = result['status'];

        if (status == true || status == 'true' || status == 'success') {
          // Success case
          final data = result['data'];
          setState(() {
            _verificationStatus = 'success';
            _verificationMessage =
                result['message'] ?? 'Account verified successfully';
            _accountName = data != null ? data['account_name'] : null;
          });
          print('✅ Verification successful: $_accountName');
        } else {
          // Error case from API
          setState(() {
            _verificationStatus = 'error';
            _verificationMessage =
                result['message'] ?? 'Failed to verify account';
          });
        }
      } else {
        // Empty response
        setState(() {
          _verificationStatus = 'error';
          _verificationMessage = 'No response from server';
        });
      }
    } catch (e, stackTrace) {
      if (!mounted) return;

      setState(() {
        _verificationStatus = 'error';

        // Parse the error message
        String errorMessage = e.toString();

        // Remove "Exception: " prefix if present
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.substring(11);
        }

        // Check for specific error types
        if (errorMessage.toLowerCase().contains('timeout')) {
          errorMessage =
              'Request timeout. Please check your internet connection.';
        } else if (errorMessage.toLowerCase().contains('socket')) {
          errorMessage =
              'Network error. Please check your internet connection.';
        } else if (errorMessage.toLowerCase().contains('failed')) {
          errorMessage = 'Unable to verify account. Please try again.';
        }

        _verificationMessage = errorMessage;
      });
    } finally {
      if (mounted) {
        setState(() => _verifying = false);
        print('=== VERIFICATION END ===');
      }
    }
  }

  Future<void> _onRefresh() async {
    await Future.wait([_loadAccountNumber(), loadBankList()]);
  }

  Future<void> _saveBank() async {
    if (_verificationStatus != "success") {
      _showSnackBar('Please verify your account first', isError: true);
      return;
    }

    setState(() {
      _savingBank = true;
      _isBankSaved = false;
    });

    try {
      final result = await _loanService.linkBankAccount(
        accountNumber: _accountNumberController.text,
        bankCode: _selectedBankCode,
      );

      if (!mounted) return;

      if (result != null && result.isNotEmpty) {
        final status = result['status'];

        if (status == true || status == 'true' || status == 'success') {
          // ✅ Success case
          setState(() {
            _isBankSaved = true;
          });

          _showSnackBar(
            result['message'] ?? 'Bank account linked successfully',
            isError: false,
          );

          // ✅ Navigate to next screen after brief delay
          await Future.delayed(const Duration(milliseconds: 500));
          if (!mounted) return;
          context.go('/loan-disbursed-screen');
        } else {
          // ❌ Error from API
          _showSnackBar(
            result['message'] ?? 'Failed to link bank account',
            isError: true,
          );
        }
      } else {
        // ❌ Empty response
        _showSnackBar('No response from server', isError: true);
      }
    } catch (e) {
      if (!mounted) return;

      // ❌ Exception occurred
      String errorMessage = e.toString();

      // Remove "Exception: " prefix if present
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }

      // Check for specific error types
      if (errorMessage.toLowerCase().contains('timeout')) {
        errorMessage =
            'Request timeout. Please check your internet connection.';
      } else if (errorMessage.toLowerCase().contains('socket')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (errorMessage.toLowerCase().contains('failed')) {
        errorMessage = 'Unable to link account. Please try again.';
      }

      _showSnackBar(errorMessage, isError: true);
    } finally {
      if (mounted) {
        setState(() => _savingBank = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> benefits = [
      'Instant loan disbursement',
      'Secure and encrypted transactions',
      'No manual payment processing',
      'Track all transactions in one place',
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: CustomLoanAppBar(title: 'Bank Authorization'),
      resizeToAvoidBottomInset: true,
      body:
          _fetching
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xff7C70DF)),
              )
              : SafeArea(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: const Color(0xff7C70DF),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(
                                    0xffA198FF,
                                  ).withOpacity(0.1),
                                ),
                                child: const Icon(
                                  Icons.account_balance,
                                  color: Color(0xff7C70DF),
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Link Your Bank Account',
                              style: TextStyle(
                                color: Color(0xff0F2D62),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Link your bank account to receive loan disbursements quickly and securely',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff0F2D62),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Select Bank',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff0F2D62),
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _verifying ? null : _openBankPicker,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _verifying
                                        ? Colors.grey[100]
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _selectedBankName ?? 'Select Bank',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            _selectedBankName == null
                                                ? const Color(0xFF9CA3AF)
                                                : const Color(0xff0F2D62),
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFF9CA3AF),
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SignupInputField(
                            icon: Icons.account_balance,
                            label: 'Account Number',
                            hintText: '',
                            controller: _accountNumberController,
                            enabled: false,
                          ),

                          if (_verifying)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Center(
                                child: Column(
                                  children: const [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Color(0xff7C70DF),
                                        strokeWidth: 3,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Verifying account...',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          if (_verificationStatus != null && !_verifying)
                            Builder(
                              builder: (context) {
                                final isSuccess =
                                    _verificationStatus == 'success';

                                return Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color:
                                          isSuccess
                                              ? const Color(
                                                0xFFE0F7FA,
                                              ) // Light cyan background
                                              : Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        // Circular icon with purple background
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color:
                                                isSuccess
                                                    ? const Color(
                                                      0xFF9C8CFF,
                                                    ) // Purple color
                                                    : Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            isSuccess
                                                ? Icons.check
                                                : Icons.error,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                isSuccess
                                                    ? 'Verified Account'
                                                    : 'Verification Failed',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Inter",
                                                  color:
                                                      isSuccess
                                                          ? const Color(
                                                            0xFF9C8CFF,
                                                          ) // Purple text
                                                          : Colors.red[700],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              if (_accountName != null)
                                                Text(
                                                  _accountName!,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Inter",
                                                    color: Color(
                                                      0xFF000000,
                                                    ), // Black text
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFFF6F3FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Lock Icon
                                Icon(
                                  Icons.info,
                                  color: Color(0xFF5E3DB3),
                                  size: 20,
                                ),

                                const SizedBox(width: 12),
                                // Text Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Important information',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xFF1F2937),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Ensure the account name matches your registered name. Loan disbursements will be sent to this account within 24 hours of approval.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFFEFF8FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Color(0xff7C70DF),
                                      size: 15,
                                    ),
                                    SizedBox(width: 6),
                                    const Text(
                                      'Why Link Your Account?',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),
                                ...benefits.map(
                                  (benefit) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.check_sharp,
                                          color: Color(0xFF7C70DF),
                                          size: 12,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            benefit,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
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

                          const SizedBox(height: 20),
                          const Divider(thickness: 1, color: Color(0xFFE5E7EB)),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child:
                                _verificationStatus == 'success'
                                    ? ElevatedButton(
                                      onPressed:
                                          _verificationStatus == 'success' &&
                                                  !_savingBank
                                              ? _saveBank // ✅ FIXED: Now calls _saveBank instead of navigating directly
                                              : null,
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        disabledBackgroundColor:
                                            Colors.grey[300],
                                      ),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xff7C70DF),
                                              Color(0xffA198FF),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child:
                                              _savingBank // ✅ Show loading indicator while saving
                                                  ? const SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 3,
                                                        ),
                                                  )
                                                  : Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Icon(
                                                        Icons.link,
                                                        size: 16,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        "Confirm & Link",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: 'Inter',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                        ),
                                      ),
                                    )
                                    : const SizedBox(height: 20),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                context.pop();
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                disabledBackgroundColor: Colors.grey[300],
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: Color(0xFF00B7BD),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.lock_outline,
                                color: Colors.grey,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Your information is secure and encrypted',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}

class BankPickerSheet extends StatefulWidget {
  final String? initiallySelectedCode;
  final List<Map<String, String>> bankList;
  final bool isLoading;
  final bool isFrozen;

  const BankPickerSheet({
    super.key,
    this.initiallySelectedCode,
    required this.bankList,
    this.isLoading = false,
    this.isFrozen = false,
  });

  @override
  _BankPickerSheetState createState() => _BankPickerSheetState();
}

class _BankPickerSheetState extends State<BankPickerSheet> {
  final TextEditingController _searchController = TextEditingController();

  String? _selectedCode;

  late List<Map<String, String>> _banks;
  List<Map<String, String>> _filteredBanks = [];

  @override
  void initState() {
    super.initState();
    _banks = widget.bankList;
    _filteredBanks = List.from(_banks);
    _selectedCode = widget.initiallySelectedCode;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filteredBanks =
          _banks
              .where(
                (b) =>
                    b['name']!.toLowerCase().contains(q) ||
                    b['code']!.toLowerCase().contains(q),
              )
              .toList();
    });
  }

  void _selectBank(String code) {
    if (widget.isFrozen) return;

    final bank = _banks.firstWhere((b) => b['code'] == code);
    Navigator.of(context).pop({'code': bank['code']!, 'name': bank['name']!});
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Bank',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed:
                            widget.isFrozen
                                ? null
                                : () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      controller: _searchController,
                      enabled: !widget.isFrozen,
                      decoration: InputDecoration(
                        hintText: 'Search bank name or code',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child:
                        widget.isLoading
                            ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Color(0xff7C70DF),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Loading banks...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : _filteredBanks.isEmpty
                            ? const Center(child: Text('No banks found'))
                            : ListView.separated(
                              controller: scrollController,
                              itemCount: _filteredBanks.length,
                              separatorBuilder:
                                  (_, __) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final bank = _filteredBanks[index];
                                final code = bank['code']!;
                                final name = bank['name']!;
                                final isSelected = code == _selectedCode;

                                return ListTile(
                                  title: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                    ),
                                  ),
                                  trailing:
                                      isSelected
                                          ? const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                          : null,
                                  onTap: () {
                                    _selectBank(code);
                                  },
                                  enabled: !widget.isFrozen,
                                );
                              },
                            ),
                  ),
                ],
              ),

              if (widget.isFrozen)
                Container(
                  color: Colors.white.withOpacity(0.8),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xff7C70DF)),
                        SizedBox(height: 16),
                        Text(
                          'Verifying account...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff0F2D62),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

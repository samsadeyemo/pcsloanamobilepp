// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:pcsloan/features/loan_application/presentation/paystack_webview.dart';
// import 'package:pcsloan/service/loan_service.dart';

// class LoanRepaymentScreen extends StatefulWidget {
//   final String loanId;
//   final double amount;
//   final String scheduleId;

//   const LoanRepaymentScreen(
//       {super.key, required this.loanId, required this.amount, required this.scheduleId});

//   @override
//   State<LoanRepaymentScreen> createState() => _LoanRepaymentScreenState();
// }

// class _LoanRepaymentScreenState extends State<LoanRepaymentScreen> {
//   double totalRepayment = 0;
//   double amountPaid = 0;
//   double balance = 0;
//   double repaymentProgress = 0;
//   int tenure = 0;
//   String nextPaymentDue = "";
//   double nextAmountDue = 0;
//   bool isPayLoading = false;

//   final _loanService = LoanService();
//   final TextEditingController _amountController = TextEditingController();
//   final FocusNode _amountFocus = FocusNode();

//   double get _enteredAmount =>
//       double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;

//   bool get _isBelowMinimum => _enteredAmount < 100 && _amountController.text.isNotEmpty;
//   bool get _canProceed => _enteredAmount >= 100;

//   String? get _errorText {
//     if (_amountController.text.isEmpty) return null;
//     if (_enteredAmount < 100) return 'Minimum repayment amount is ₦100.00';
//     return null;
//   }

//   @override
//   void initState() {
//     super.initState();
//     nextAmountDue = widget.amount;
//     // Pre-fill with the suggested amount
//     _amountController.text =
//         widget.amount > 0 ? _formatRaw(widget.amount) : '';
//   }

//   @override
//   void dispose() {
//     _amountController.dispose();
//     _amountFocus.dispose();
//     super.dispose();
//   }

//   /// Format a double as a comma-separated string without symbol
//   String _formatRaw(double amount) {
//     return NumberFormat('#,##0.##', 'en_NG').format(amount);
//   }

//   String formatCurrency(double amount) {
//     return NumberFormat.currency(
//       locale: 'en_NG',
//       symbol: '₦',
//       decimalDigits: 2,
//     ).format(amount);
//   }

//   String formatDate(String isoDate) {
//     final parsed = DateTime.tryParse(isoDate);
//     if (parsed == null) return '';
//     return DateFormat('dd/MM/yyyy').format(parsed);
//   }

//   void _onAmountChanged(String value) {
//     // Strip commas, reformat
//     final raw = value.replaceAll(',', '');
//     final parsed = double.tryParse(raw);
//     if (parsed != null) {
//       final formatted = _formatRaw(parsed);
//       // Only update if different to avoid cursor issues
//       if (formatted != value) {
//         _amountController.value = TextEditingValue(
//           text: formatted,
//           selection: TextSelection.collapsed(offset: formatted.length),
//         );
//       }
//     }
//     setState(() {});
//   }

//   Future<void> _repayLoan() async {
//     if (!_canProceed) return;

//     setState(() => isPayLoading = true);

//     try {
//       final response = await _loanService.payLoan(
//         widget.loanId,
//         _enteredAmount,
//         widget.scheduleId,
//       );
//       print('✅ Payment initiation response: $response');

//       final authUrl = response['data']?['data']?['authorization_url'];
//       print('🔗 Authorization URL: $authUrl');

//       if (authUrl == null || authUrl.toString().isEmpty) {
//         throw Exception('Payment link not available. Please try again.');
//       }

//       if (!mounted) return;

//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => PaystackWebViewScreen(
//             authorizationUrl: authUrl.toString(),
//             loanId: widget.loanId,
//           ),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             e.toString().replaceAll('Exception: ', ''),
//             style: const TextStyle(color: Colors.white, fontSize: 13),
//           ),
//           backgroundColor: const Color(0xffC0392B),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           margin: const EdgeInsets.all(16),
//         ),
//       );
//     } finally {
//       if (mounted) setState(() => isPayLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         backgroundColor: const Color(0xffF9FAFB),
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           leading: GestureDetector(
//             onTap: () => context.pop(),
//             child: Container(
//               margin: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: const Color(0xffF3F4F6),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(
//                 Icons.arrow_back_rounded,
//                 color: Color(0xff0F2D62),
//                 size: 20,
//               ),
//             ),
//           ),
//           title: const Text(
//             'Make Repayment',
//             style: TextStyle(
//               color: Color(0xff0F2D62),
//               fontSize: 17,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 8),

//                     // ── Amount Entry Card ──────────────────────────────────
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(22),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Color(0xff4A3FC0),
//                             Color(0xff7C70DF),
//                             Color(0xff9B8FFF),
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xff7C70DF).withOpacity(0.3),
//                             blurRadius: 20,
//                             offset: const Offset(0, 8),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Repayment Amount',
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.white70,
//                               letterSpacing: 0.4,
//                             ),
//                           ),
//                           const SizedBox(height: 14),

//                           // ₦ prefix + text field
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.15),
//                               borderRadius: BorderRadius.circular(14),
//                               border: Border.all(
//                                 color: _isBelowMinimum
//                                     ? Colors.red.shade300
//                                     : Colors.white.withOpacity(0.3),
//                                 width: 1.5,
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 // ₦ symbol pill
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 16, vertical: 18),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white.withOpacity(0.15),
//                                     borderRadius: const BorderRadius.only(
//                                       topLeft: Radius.circular(12),
//                                       bottomLeft: Radius.circular(12),
//                                     ),
//                                   ),
//                                   child: const Text(
//                                     '₦',
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Expanded(
//                                   child: TextField(
//                                     controller: _amountController,
//                                     focusNode: _amountFocus,
//                                     onChanged: _onAmountChanged,
//                                     keyboardType:
//                                         const TextInputType.numberWithOptions(
//                                             decimal: true),
//                                     inputFormatters: [
//                                       FilteringTextInputFormatter.allow(
//                                           RegExp(r'[\d,.]')),
//                                     ],
//                                     style: const TextStyle(
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                     decoration: const InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: '0.00',
//                                       hintStyle: TextStyle(
//                                         color: Colors.white38,
//                                         fontSize: 22,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 // Clear button
//                                 if (_amountController.text.isNotEmpty)
//                                   GestureDetector(
//                                     onTap: () {
//                                       _amountController.clear();
//                                       setState(() {});
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(right: 14),
//                                       child: Icon(
//                                         Icons.cancel_rounded,
//                                         color: Colors.white.withOpacity(0.5),
//                                         size: 20,
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),

//                           // Error text
//                           if (_isBelowMinimum) ...[
//                             const SizedBox(height: 8),
//                             Row(
//                               children: [
//                                 const Icon(Icons.info_outline_rounded,
//                                     color: Colors.red, size: 14),
//                                 const SizedBox(width: 5),
//                                 Text(
//                                   _errorText!,
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],

//                           const SizedBox(height: 16),

//                           // Quick fill chips
//                           const Text(
//                             'Quick fill',
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.white60,
//                               letterSpacing: 0.3,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: _buildChip(
//                                   'Suggested',
//                                   widget.amount > 0
//                                       ? widget.amount
//                                       : nextAmountDue,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: _buildChip(
//                                   'Half',
//                                   (widget.amount > 0
//                                           ? widget.amount
//                                           : nextAmountDue) /
//                                       2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // ── Payment Summary ────────────────────────────────────
//                     const Text(
//                       'Payment Summary',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xff0F2D62),
//                       ),
//                     ),
//                     const SizedBox(height: 12),

//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(14),
//                         border: Border.all(
//                             color: Colors.grey.shade100, width: 1.5),
//                       ),
//                       child: Column(
//                         children: [
//                           _buildSummaryRow(
//                             'You are paying',
//                             _canProceed
//                                 ? formatCurrency(_enteredAmount)
//                                 : '—',
//                             isHighlight: false,
//                           ),
//                           Divider(color: Colors.grey.shade100, height: 1),
//                           _buildSummaryRow(
//                             'Suggested Amount',
//                             formatCurrency(widget.amount > 0
//                                 ? widget.amount
//                                 : nextAmountDue),
//                             isHighlight: false,
//                           ),

//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // ── Info box ───────────────────────────────────────────
//                     Container(
//                       padding: const EdgeInsets.all(14),
//                       decoration: BoxDecoration(
//                         color: const Color(0xffF3F4F6),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: 22,
//                             height: 22,
//                             decoration: BoxDecoration(
//                               color: const Color(0xff7C70DF).withOpacity(0.15),
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 'i',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xff7C70DF),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           const Expanded(
//                             child: Text(
//                               'You will be redirected to a secure payment page to complete your repayment.',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Color(0xff6B7280),
//                                 height: 1.5,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 100),
//                   ],
//                 ),
//               ),
//             ),

//             // ── Repay Now button ───────────────────────────────────────────
//             Container(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, -4),
//                   ),
//                 ],
//               ),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 54,
//                 child: ElevatedButton(
//                   onPressed: _canProceed && !isPayLoading
//                       ? _repayLoan
//                       : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xff7C70DF),
//                     disabledBackgroundColor:
//                         const Color(0xff7C70DF).withOpacity(0.4),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     elevation: _canProceed ? 4 : 0,
//                     shadowColor:
//                         const Color(0xff7C70DF).withOpacity(0.4),
//                   ),
//                   child: isPayLoading
//                       ? const SizedBox(
//                           width: 22,
//                           height: 22,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2.5,
//                           ),
//                         )
//                       : Text(
//                           _canProceed
//                               ? 'Repay ${formatCurrency(_enteredAmount)}'
//                               : 'Enter an amount to continue',
//                           style: const TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                             letterSpacing: 0.3,
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildChip(String label, double amount) {
//     final isSelected = _amountController.text == _formatRaw(amount);
//     return GestureDetector(
//       onTap: () {
//         _amountController.text = _formatRaw(amount);
//         _amountController.selection =
//             TextSelection.collapsed(offset: _amountController.text.length);
//         setState(() {});
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 150),
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? Colors.white
//               : Colors.white.withOpacity(0.15),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: isSelected
//                 ? Colors.white
//                 : Colors.white.withOpacity(0.3),
//             width: 1.2,
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w500,
//                 color: isSelected
//                     ? const Color(0xff7C70DF).withOpacity(0.7)
//                     : Colors.white70,
//               ),
//             ),
//             const SizedBox(height: 2),
//             Text(
//               formatCurrency(amount),
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w700,
//                 color: isSelected ? const Color(0xff7C70DF) : Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSummaryRow(String label, String value,
//       {bool isHighlight = false}) {
//     return Padding(
//       padding:
//           const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 13,
//               color: Color(0xff6B7280),
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: isHighlight ? 15 : 13,
//               fontWeight:
//                   isHighlight ? FontWeight.bold : FontWeight.w600,
//               color: isHighlight
//                   ? const Color(0xff7C70DF)
//                   : const Color(0xff0F2D62),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pcsloan/features/loan_application/presentation/paystack_webview.dart';
import 'package:pcsloan/service/loan_service.dart';

class LoanRepaymentScreen extends StatefulWidget {
  final String loanId;
  final double amount;
  final String scheduleId;

  const LoanRepaymentScreen(
      {super.key,
      required this.loanId,
      required this.amount,
      required this.scheduleId});

  @override
  State<LoanRepaymentScreen> createState() => _LoanRepaymentScreenState();
}

class _LoanRepaymentScreenState extends State<LoanRepaymentScreen> {
  double totalRepayment = 0;
  double amountPaid = 0;
  double balance = 0;
  double repaymentProgress = 0;
  int tenure = 0;
  String nextPaymentDue = "";
  double nextAmountDue = 0;
  bool isPayLoading = false;

  // ── NEW: separate loading flag for full-loan repayment ──────────────────
  bool isFullPayLoading = false;

  final _loanService = LoanService();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocus = FocusNode();

  double get _enteredAmount =>
      double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;

  bool get _isBelowMinimum =>
      _enteredAmount < 100 && _amountController.text.isNotEmpty;
  bool get _canProceed => _enteredAmount >= 100;

  String? get _errorText {
    if (_amountController.text.isEmpty) return null;
    if (_enteredAmount < 100) return 'Minimum repayment amount is ₦100.00';
    return null;
  }

  /// Whether any payment action is in flight (disables both buttons)
  bool get _anyLoading => isPayLoading || isFullPayLoading;

  @override
  void initState() {
    super.initState();
    nextAmountDue = widget.amount;
    _amountController.text =
        widget.amount > 0 ? _formatRaw(widget.amount) : '';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  String _formatRaw(double amount) {
    return NumberFormat('#,##0.##', 'en_NG').format(amount);
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    ).format(amount);
  }

  String formatDate(String isoDate) {
    final parsed = DateTime.tryParse(isoDate);
    if (parsed == null) return '';
    return DateFormat('dd/MM/yyyy').format(parsed);
  }

  void _onAmountChanged(String value) {
    final raw = value.replaceAll(',', '');
    final parsed = double.tryParse(raw);
    if (parsed != null) {
      final formatted = _formatRaw(parsed);
      if (formatted != value) {
        _amountController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    }
    setState(() {});
  }

  // ── Partial repayment (existing) ────────────────────────────────────────
  Future<void> _repayLoan() async {
    if (!_canProceed) return;

    setState(() => isPayLoading = true);

    try {
      final response = await _loanService.payLoan(
        widget.loanId,
        _enteredAmount,
        widget.scheduleId,
      );

      final authUrl = response['data']?['data']?['authorization_url'];

      if (authUrl == null || authUrl.toString().isEmpty) {
        throw Exception('Payment link not available. Please try again.');
      }

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaystackWebViewScreen(
            authorizationUrl: authUrl.toString(),
            loanId: widget.loanId,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showErrorSnack(e.toString());
    } finally {
      if (mounted) setState(() => isPayLoading = false);
    }
  }

  // ── Full loan repayment (NEW) ────────────────────────────────────────────
  Future<void> _repayFullLoan() async {
    setState(() => isFullPayLoading = true);

    try {
      final response = await _loanService.payFullLoan(widget.loanId);

      final authUrl = response['data']?['data']?['authorization_url'];

      if (authUrl == null || authUrl.toString().isEmpty) {
        throw Exception('Payment link not available. Please try again.');
      }

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaystackWebViewScreen(
            authorizationUrl: authUrl.toString(),
            loanId: widget.loanId,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showErrorSnack(e.toString());
    } finally {
      if (mounted) setState(() => isFullPayLoading = false);
    }
  }

  void _showErrorSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.replaceAll('Exception: ', ''),
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
        backgroundColor: const Color(0xffC0392B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xffF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xff0F2D62),
                size: 20,
              ),
            ),
          ),
          title: const Text(
            'Make Repayment',
            style: TextStyle(
              color: Color(0xff0F2D62),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── Amount Entry Card ──────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xff4A3FC0),
                            Color(0xff7C70DF),
                            Color(0xff9B8FFF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff7C70DF).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Repayment Amount',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // ₦ prefix + text field
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _isBelowMinimum
                                    ? Colors.red.shade300
                                    : Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 18),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    '₦',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: TextField(
                                    controller: _amountController,
                                    focusNode: _amountFocus,
                                    onChanged: _onAmountChanged,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[\d,.]')),
                                    ],
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '0.00',
                                      hintStyle: TextStyle(
                                        color: Colors.white38,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_amountController.text.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      _amountController.clear();
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 14),
                                      child: Icon(
                                        Icons.cancel_rounded,
                                        color: Colors.white.withOpacity(0.5),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          if (_isBelowMinimum) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.info_outline_rounded,
                                    color: Colors.red, size: 14),
                                const SizedBox(width: 5),
                                Text(
                                  _errorText!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 16),

                          // ── Quick fill chips ─────────────────────────────
                          const Text(
                            'Quick fill',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white60,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              // Suggested chip
                              Expanded(
                                child: _buildChip(
                                  'Suggested',
                                  widget.amount > 0
                                      ? widget.amount
                                      : nextAmountDue,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Half chip
                              Expanded(
                                child: _buildChip(
                                  'Half',
                                  (widget.amount > 0
                                          ? widget.amount
                                          : nextAmountDue) /
                                      2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // ── Repay All chip (NEW) ─────────────────────
                              Expanded(
                                child: _buildRepayAllChip(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Payment Summary ────────────────────────────────────
                    const Text(
                      'Payment Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0F2D62),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: Colors.grey.shade100, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow(
                            'You are paying',
                            _canProceed
                                ? formatCurrency(_enteredAmount)
                                : '—',
                            isHighlight: false,
                          ),
                          Divider(color: Colors.grey.shade100, height: 1),
                          _buildSummaryRow(
                            'Suggested Amount',
                            formatCurrency(widget.amount > 0
                                ? widget.amount
                                : nextAmountDue),
                            isHighlight: false,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Info box ───────────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xffF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: const Color(0xff7C70DF).withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                'i',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff7C70DF),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'You will be redirected to a secure payment page to complete your repayment.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff6B7280),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // ── Repay Now button ───────────────────────────────────────────
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _canProceed && !_anyLoading ? _repayLoan : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7C70DF),
                    disabledBackgroundColor:
                        const Color(0xff7C70DF).withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: _canProceed ? 4 : 0,
                    shadowColor: const Color(0xff7C70DF).withOpacity(0.4),
                  ),
                  child: isPayLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          _canProceed
                              ? 'Repay ${formatCurrency(_enteredAmount)}'
                              : 'Enter an amount to continue',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Quick-fill chip (existing, unchanged) ─────────────────────────────────
  Widget _buildChip(String label, double amount) {
    final isSelected = _amountController.text == _formatRaw(amount);
    return GestureDetector(
      onTap: _anyLoading
          ? null
          : () {
              _amountController.text = _formatRaw(amount);
              _amountController.selection = TextSelection.collapsed(
                  offset: _amountController.text.length);
              setState(() {});
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.white
                : Colors.white.withOpacity(0.3),
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? const Color(0xff7C70DF).withOpacity(0.7)
                    : Colors.white70,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              formatCurrency(amount),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? const Color(0xff7C70DF) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Repay All chip (NEW) ──────────────────────────────────────────────────
  Widget _buildRepayAllChip() {
    return GestureDetector(
      onTap: _anyLoading ? null : _repayFullLoan,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          // Always uses the solid-white active look to stand out as an action
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isFullPayLoading)
              // Spinner replaces content while loading
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Color(0xff7C70DF),
                  strokeWidth: 2,
                ),
              )
            else ...[
              const Text(
                'Repay All',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff7C70DF),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Full loan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff4A3FC0),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xff6B7280),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isHighlight ? 15 : 13,
              fontWeight:
                  isHighlight ? FontWeight.bold : FontWeight.w600,
              color: isHighlight
                  ? const Color(0xff7C70DF)
                  : const Color(0xff0F2D62),
            ),
          ),
        ],
      ),
    );
  }
}
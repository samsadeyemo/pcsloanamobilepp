import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';

class PaystackWebViewScreen extends StatefulWidget {
  final String authorizationUrl;
  final String loanId;

  const PaystackWebViewScreen({
    super.key,
    required this.authorizationUrl,
    required this.loanId,
  });

  @override
  State<PaystackWebViewScreen> createState() => _PaystackWebViewScreenState();
}

class _PaystackWebViewScreenState extends State<PaystackWebViewScreen> {
  InAppWebViewController? _webViewController;
  bool isLoading = true;
  int _progress = 0;

  // Paystack redirects to callback URL after payment
  // Intercept any URL that is no longer on paystack.com
  bool _isPaystackDone(String url) {
    return !url.contains('paystack.com') &&
        !url.contains('payment-gateway.com') &&
        (url.contains('trxref') ||
            url.contains('reference') ||
            url.contains('callback') ||
            url.contains('verify'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Secure Payment',
          style: TextStyle(
            color: Color(0xff0F2D62),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: const SizedBox.shrink(),
        actions: [
          // X button — pop back
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              margin: const EdgeInsets.only(right: 14),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xffF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Color(0xff0F2D62),
                size: 18,
              ),
            ),
          ),
        ],
        // Progress bar under appbar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: AnimatedOpacity(
            opacity: isLoading ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: LinearProgressIndicator(
              value: _progress / 100,
              backgroundColor: Colors.grey.shade100,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xff7C70DF),
              ),
              minHeight: 3,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(widget.authorizationUrl),
            ),
            initialSettings: InAppWebViewSettings(
              useShouldOverrideUrlLoading: true,
              javaScriptEnabled: true,
              domStorageEnabled: true,
              useOnLoadResource: true,
              transparentBackground: true,
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() => isLoading = true);

              // Detect Paystack callback / completion
              if (url != null && _isPaystackDone(url.toString())) {
                context.go(
                  '/loan-redirect',
                  extra: {'loanId': widget.loanId},
                );
              }
            },
            onLoadStop: (controller, url) {
              setState(() => isLoading = false);
            },
            onProgressChanged: (controller, progress) {
              setState(() => _progress = progress);
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final url = navigationAction.request.url?.toString() ?? '';

              // Intercept callback URL and route back to overview
              if (_isPaystackDone(url)) {
                context.go(
                  '/repayment-overview',
                  extra: {'loanId': widget.loanId},
                );
                return NavigationActionPolicy.CANCEL;
              }

              return NavigationActionPolicy.ALLOW;
            },
            onReceivedError: (controller, request, error) {
              setState(() => isLoading = false);
            },
          ),

          // Initial full-screen loader before page loads
          if (isLoading && _progress < 20)
            Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xff7C70DF),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
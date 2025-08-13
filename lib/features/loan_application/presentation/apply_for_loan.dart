import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplyForLoan extends ConsumerStatefulWidget {
  const ApplyForLoan({super.key});

  @override
  ConsumerState<ApplyForLoan> createState() => _ApplyForLoan();
}

class _ApplyForLoan extends ConsumerState<ApplyForLoan> {
  @override
  Widget build(BuildContext context) {
    String loanAmount = '';
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        leading: SizedBox(
          width: 40,
          child: Center(
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xffF3F4F6),
              ),
              child: Center(
                child: FittedBox(
                  child: Icon(
                    Icons.arrow_back_sharp,
                    size: 20,
                    color: Color(0xff4B5563),
                  ),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xffFFFFFF),
        title: Text(
          'Apply for a Loan',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xff0F2D62),
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Loan Amount",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F2D62),
                    fontFamily: "Inter",
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF7C70DF), width: 1.5),
                    borderRadius: BorderRadius.circular(10),

                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) => loanAmount = value,
                          validator:
                              (value) =>
                                  value != null && value.length >= 6
                                      ? null
                                      : "The Minimum amount you can borrow is ₦10,000",
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Color(0xFFADAEBC),
                              fontSize: 16,
                              fontFamily: "Inter",
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Min: ₦10,000',
                      style: TextStyle(fontSize: 12, color: Color(0xFF4B5563)
                      ),
                    ),
                    Text(
                      'Max: ₦2,000,000',
                      style: TextStyle(fontSize: 12, color: Color(0xFF4B5563),
                      )
                    )
                  ]
                ),
                SizedBox(height: 50,),
                Text(
                  'Select Tenure (Months)',
                  style: TextStyle(
                    color: Color(0xff4B5563),
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

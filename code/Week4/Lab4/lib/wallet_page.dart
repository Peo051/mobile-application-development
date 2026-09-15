import 'package:flutter/material.dart';
import 'action_button.dart';
import 'card_indicator.dart';
import 'wallet_menu_item.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Cards',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showMessage(context, 'Add new card');
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD3D3D3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 24,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  height: 190,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B65C5),
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 7,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Balance',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),

                      SizedBox(height: 7),

                      Text(
                        '\$5250.25',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      Spacer(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '12345678',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '10/24',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CardIndicator(width: 43, color: Color(0xFF444444)),
                    SizedBox(width: 7),
                    CardIndicator(width: 13, color: Color(0xFFAAAAAA)),
                    SizedBox(width: 7),
                    CardIndicator(width: 13, color: Color(0xFFAAAAAA)),
                  ],
                ),

                const SizedBox(height: 38),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ActionButton(
                      icon: Icons.local_atm,
                      iconColor: Color(0xFF11A765),
                      backgroundColor: Color(0xFFFFD99B),
                      title: 'Send',
                      onTap: () {
                        showMessage(context, 'Send money');
                      },
                    ),
                    ActionButton(
                      icon: Icons.credit_card,
                      iconColor: Color(0xFF168AD8),
                      backgroundColor: Color(0xFFD8F0FF),
                      title: 'Pay',
                      onTap: () {
                        showMessage(context, 'Pay');
                      },
                    ),
                    ActionButton(
                      icon: Icons.receipt_long,
                      iconColor: Color(0xFFD8912C),
                      backgroundColor: Color(0xFFFFF0CF),
                      title: 'Bills',
                      onTap: () {
                        showMessage(context, 'View bills');
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                MenuItem(
                  icon: Icons.bar_chart,
                  iconColor: const Color(0xFF56A6C4),
                  title: 'Statistics',
                  subtitle: 'Payment and Income',
                  onTap: () {
                    showMessage(context, 'View statistics');
                  },
                ),

                const SizedBox(height: 10),

                MenuItem(
                  icon: Icons.payments,
                  iconColor: const Color(0xFF14A864),
                  title: 'Transactions',
                  subtitle: 'Transaction History',
                  onTap: () {
                    showMessage(context, 'View transaction history');
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMessage(context, 'Wallet');
        },
        backgroundColor: const Color(0xFFD41454),
        shape: const CircleBorder(),
        child: const Icon(Icons.attach_money, color: Colors.white, size: 27),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: const BottomAppBar(
        height: 63,
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 7,
        child: SizedBox(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // สำหรับทำระบบ Copy เลขบัญชี

class PayPage extends StatelessWidget {
  const PayPage({super.key});

  static const Color brandGold = Color(0xFFB9976C);
  static const Color brandNavy = Color(0xFF2D2F31);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: brandNavy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'สนับสนุนแอดมิน',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: brandNavy,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // --- ส่วน QR Code Card ---
                  _buildPaymentCard(context),
                  
                  const SizedBox(height: 32),

                  // --- ส่วนข้อความถึงคู่หู ---
                  _buildMessageCard(),
                ],
              ),
            ),
            
            // --- ส่วนท้าย (Footer) ---
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'สแกนผ่านแอปธนาคาร',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: brandNavy,
            ),
          ),
          const SizedBox(height: 20),
          
          // QR Code
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: brandGold.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/img/qr.png',
                width: 180,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const SizedBox(height: 24),

          // เบอร์โทร/PromptPay พร้อมปุ่มคัดลอก
          InkWell(
            onTap: () {
              Clipboard.setData(const ClipboardData(text: "0827818941"));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('คัดลอกเลขบัญชีแล้ว'), behavior: SnackBarBehavior.floating),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: brandGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.copy, size: 16, color: brandGold),
                  SizedBox(width: 8),
                  Text(
                    '082-781-8941',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: brandGold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          
          _buildInfoRow('ชื่อบัญชี', 'ชลธี สินสาตร์'),
          const SizedBox(height: 8),
          _buildInfoRow('ธนาคาร', 'พร้อมเพย์'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontFamily: 'Kanit', color: Colors.grey, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Kanit',
            fontWeight: FontWeight.w600,
            color: brandNavy,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: brandNavy.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: brandNavy.withOpacity(0.05)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.pink, size: 20),
              SizedBox(width: 8),
              Text(
                'ข้อความถึงเพื่อนครู',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: brandNavy,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'ระลึกเสมอว่า การสอบครั้งนี้จะเป็นการเหนื่อยครั้งสุดท้ายของเธอแล้วจริง ๆ จงเชื่อมั่นในตัวเองนะ เธอทำได้ และเธอต้องทำได้ ไว้มีโอกาสมาชนแก้วชานมไข่มุกเพื่อฉลองความสำเร็จไปด้วยกันนะ!',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 14,
              height: 1.6,
              color: brandNavy,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: const BoxDecoration(
        color: brandNavy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: const Column(
        children: [
          Text(
            'ขอบคุณที่ดูแลกันนะ',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: brandGold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'เพราะร่างกายขาดชานมไข่มุกไม่ได้',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
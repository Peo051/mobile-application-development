import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  Widget infoText(
    String label,
    String value, {
    Color valueColor = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 17, color: Colors.black),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(color: valueColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget productImage(String path) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(path, fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Thông tin sản phẩm'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3 hình ảnh sản phẩm
              Row(
                children: [
                  Expanded(child: productImage('assets/images/product1.jpg')),
                  const SizedBox(width: 8),
                  Expanded(child: productImage('assets/images/product2.jpg')),
                  const SizedBox(width: 8),
                  Expanded(child: productImage('assets/images/product3.jpg')),
                ],
              ),

              const SizedBox(height: 30),

              infoText('Mã sản phẩm', 'SP001', valueColor: Colors.indigo),

              infoText(
                'Tên sản phẩm',
                'Laptop ASUS TUF Gaming A15',
                valueColor: Colors.blue,
              ),

              infoText('Nhà sản xuất', 'ASUS', valueColor: Colors.green),

              infoText(
                'Giá bán',
                '19.990.000 VNĐ',
                valueColor: Colors.orange.shade800,
              ),

              infoText(
                'Mô tả sản phẩm',
                'Laptop gaming hiệu năng cao, phù hợp cho học tập, '
                    'lập trình, thiết kế và chơi game. '
                    'Máy được trang bị cấu hình mạnh mẽ và màn hình '
                    'tần số quét cao.',
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imagePath;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
  });
}

/// Dữ liệu mẫu 7 sản phẩm điện thoại theo yêu cầu đề bài
final List<Product> sampleProducts = [
  const Product(
    id: '01',
    name: 'Điện thoại 01',
    price: 1200.0,
    description: 'điện thoại mới của hãng SamSung với công nghệ hiện đại',
    imagePath: 'assets/images/phone_01.png',
  ),
  const Product(
    id: '02',
    name: 'Điện thoại 02',
    price: 899.0,
    description: 'thiết kế sang trọng, camera sắc nét đỉnh cao',
    imagePath: 'assets/images/phone_02.png',
  ),
  const Product(
    id: '03',
    name: 'Điện thoại 03',
    price: 749.0,
    description: 'hiệu năng mượt mà, pin trâu sử dụng cả ngày',
    imagePath: 'assets/images/phone_03.png',
  ),
  const Product(
    id: '04',
    name: 'Điện thoại 04',
    price: 602.2,
    description: 'màn hình tràn viền 120Hz siêu mượt mà',
    imagePath: 'assets/images/phone_04.png',
  ),
  const Product(
    id: '05',
    name: 'Điện thoại 05',
    price: 1500.0,
    description: 'flagship đẳng cấp, chụp đêm chuyên nghiệp',
    imagePath: 'assets/images/phone_05.png',
  ),
  const Product(
    id: '06',
    name: 'Điện thoại 06',
    price: 990.0,
    description: 'cấu hình gaming mạnh mẽ, tản nhiệt cực tốt',
    imagePath: 'assets/images/phone_06.png',
  ),
  const Product(
    id: '07',
    name: 'Điện thoại 07',
    price: 2000.0,
    description: 'công nghệ đột phá hàng đầu thị trường',
    imagePath: 'assets/images/phone_07.png',
  ),
];

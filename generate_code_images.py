import os
import sys
from pygments import highlight
from pygments.lexers import DartLexer
from pygments.formatters import HtmlFormatter
from playwright.sync_api import sync_playwright

output_dir = r"f:\Thuc Hanh\LTDD\screenshots"
os.makedirs(output_dir, exist_ok=True)

# Định nghĩa các đoạn code trọng tâm cho từng trang/chức năng
code_snippets = [
    {
        "filename": "code_bai03_qua_cua_vinh.png",
        "title": "lib/bai_03.dart - Giao diện Quà của Vinh",
        "code": """  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(), // Thanh tiêu đề "Quà của Vinh (7)" + nút back + hotline
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildFilterBar(),     // Thanh bộ lọc cuộn ngang (Sắp xếp, Dịch vụ, ...)
                    const SizedBox(height: 12),
                    _buildTwoInfoCards(),  // 2 thẻ thông tin nổi bật (Điểm tích luỹ & Ưu đãi)
                    const SizedBox(height: 14),
                    _buildGiftList(),      // Danh sách 5 mục quà tặng với logo CGV, VIB, ...
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget hiển thị từng thẻ Quà tặng với logo, tiêu đề, tag và nút thao tác
  Widget _buildGiftCard(GiftItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo thương hiệu (CGV, VIB, Bảo hiểm, Sim, Phí không dừng)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(item.assetPath, width: 56, height: 56, fit: BoxFit.contain),
          ),
          const SizedBox(width: 12),
          // Thông tin khuyến mãi, tiêu đề, HSD
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.brandName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                Text(item.description, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                if (item.expiryDate != null)
                  Text(item.expiryDate!, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
              ],
            ),
          ),
          // Nút Thu thập hoặc biểu tượng Trái tim yêu thích
          if (item.isCollectButton)
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(foregroundColor: primaryPink),
              child: const Text('Thu thập'),
            )
          else
            Icon(item.isFavorite ? Icons.favorite : Icons.favorite_border,
                 color: item.isFavorite ? primaryPink : Colors.grey),
        ],
      ),
    );
  }"""
    },
    {
        "filename": "code_bai04_01_intro.png",
        "title": "lib/screens/intro_screen.dart - Màn hình Giới thiệu",
        "code": """class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo trường HUIT tròn lớn ở giữa màn hình
                Container(
                  width: 170,
                  height: 170,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.asset('assets/images/logo_huit.png', fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 32),
                // Tiêu đề Cửa hàng điện thoại
                const Text(
                  'Cửa hàng điện thoại',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Địa chỉ cửa hàng
                const Text(
                  '140 Lê Trọng Tấn, Tân Phú, TP.Hồ Chí Minh',
                  style: TextStyle(fontSize: 13.5, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                // Nút hình viên thuốc màu trắng chuyển sang ShopScreen
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ShopScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.black54, size: 22),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}"""
    },
    {
        "filename": "code_bai04_02_shop.png",
        "title": "lib/screens/shop_screen.dart & product_card.dart - Màn hình Cửa hàng",
        "code": """  // Bố cục thân màn hình ShopScreen: Danh sách sản phẩm cuộn ngang
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC107), // Màu vàng cam theo thiết kế
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Cửa hàng điện thoại',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black87),
            onPressed: _openCartScreen,
          ),
        ],
      ),
      drawer: Drawer(...), // Ngăn kéo menu bên trái
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text('Chọn sản phẩm bạn muốn sử dụng',
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              // ListView cuộn ngang chứa danh sách sản phẩm
              SizedBox(
                height: 380,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 18),
                  itemCount: sampleProducts.length,
                  itemBuilder: (context, index) {
                    final product = sampleProducts[index];
                    return ProductCard(
                      product: product,
                      onAddToCart: () => _showAddToCartDialog(product),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text('Sản phẩm được lựa chọn nhiều nhất',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }"""
    },
    {
        "filename": "code_bai04_03_drawer.png",
        "title": "lib/screens/shop_screen.dart - Ngăn kéo Drawer",
        "code": """      drawer: Drawer(
        child: Column(
          children: [
            // Phần trên: Thông tin cá nhân nền trắng
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
              child: Column(
                children: [
                  ClipOval(
                    child: Image.asset('assets/images/logo_huit.png',
                        width: 72, height: 72, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 12),
                  const Text('Vũ Văn Vĩnh',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('vinhvv@huit.edu.vn',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                ],
              ),
            ),
            // Phần dưới: Menu điều hướng nền màu xanh dương
            Expanded(
              child: Material(
                color: const Color(0xFF2196F3),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.store, color: Colors.black87),
                        title: const Text('Cửa hàng'),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.shopping_cart, color: Colors.black87),
                        title: const Text('Giỏ hàng'),
                        onTap: () {
                          Navigator.pop(context);
                          _openCartScreen();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app, color: Colors.black87),
                        title: const Text('Thoát'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),"""
    },
    {
        "filename": "code_bai04_04_dialog_add.png",
        "title": "lib/screens/shop_screen.dart - Hộp thoại thêm vào Giỏ hàng",
        "code": """  // Hiển thị hộp thoại xác nhận khi người dùng nhấn nút '+' trên thẻ sản phẩm
  void _showAddToCartDialog(Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Xác nhận',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Bạn vừa thêm sản phẩm vào Giỏ hàng'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Không', style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _cartItems.add(product); // Thêm sản phẩm vào danh sách giỏ hàng
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã thêm ${product.name} vào Giỏ hàng'),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text(
              'Đồng ý',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }"""
    },
    {
        "filename": "code_bai04_05_cart.png",
        "title": "lib/screens/cart_screen.dart - Màn hình Giỏ hàng của bạn",
        "code": """  @override
  Widget build(BuildContext context) {
    final bool isEmpty = widget.cartItems.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC107),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Giỏ hàng của bạn',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text('Giỏ hàng của bạn',
                style: TextStyle(fontSize: 12.5, color: Colors.black87)),
            const SizedBox(height: 12),
            // Danh sách các sản phẩm đã thêm kèm nút thùng rác xóa sản phẩm
            Expanded(
              child: isEmpty
                  ? const Center(
                      child: Text('Bạn chưa có sản phẩm nào vô giỏ hàng!!!!',
                          style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: widget.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = widget.cartItems[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(item.price.toString()),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.black87, size: 20),
                                onPressed: () => _confirmRemove(index, item.name),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            // Nút Thanh toán hình viên thuốc bo tròn ở chân trang
            Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 12),
              child: InkWell(
                onTap: _handleCheckout,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text('Thanh toán',
                      style: TextStyle(color: Color(0xFF00D1C7), fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }"""
    },
    {
        "filename": "code_bai04_06_checkout.png",
        "title": "lib/screens/cart_screen.dart - Hộp thoại Thanh toán",
        "code": """  // Xử lý khi nhấn nút Thanh toán
  void _handleCheckout() {
    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn chưa có sản phẩm nào vô giỏ hàng!!!!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Hiển thị dialog xác nhận đã thanh toán xong và xóa sạch giỏ hàng
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Thanh toán',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Bạn đã thanh toán xong giỏ hàng'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                widget.onClearCart(); // Làm rỗng giỏ hàng sau khi thanh toán
              });
            },
            child: const Text(
              'Đồng ý',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }"""
    },
    {
        "filename": "code_bai04_07_dialog_remove.png",
        "title": "lib/screens/cart_screen.dart - Hộp thoại Xóa khỏi Giỏ hàng",
        "code": """  // Hiển thị hộp thoại xác nhận khi bấm biểu tượng thùng rác để xóa sản phẩm
  void _confirmRemove(int index, String productName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Xác nhận',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Bạn muốn loại bỏ sản phẩm này ra khỏi giỏ hàng'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Không', style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                widget.onRemoveItem(index); // Xóa sản phẩm tại vị trí index
              });
            },
            child: const Text(
              'Đồng ý',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }"""
    }
]

formatter = HtmlFormatter(style='monokai', linenos=True, cssclass='source')
pygments_css = formatter.get_style_defs('.source')

html_template = """<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  * {{ box-sizing: border-box; margin: 0; padding: 0; }}
  body {{
    background: transparent;
    font-family: Consolas, 'Fira Code', 'Courier New', monospace;
    display: inline-block;
    padding: 16px;
  }}
  .window {{
    background: #1e1e24;
    border-radius: 12px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.4);
    overflow: hidden;
    min-width: 760px;
    max-width: 900px;
    border: 1px solid #333842;
  }}
  .title-bar {{
    background: #181a1f;
    padding: 10px 16px;
    display: flex;
    align-items: center;
    border-bottom: 1px solid #282c34;
  }}
  .dots {{
    display: flex;
    gap: 8px;
    margin-right: 16px;
  }}
  .dot {{
    width: 12px;
    height: 12px;
    border-radius: 50%;
  }}
  .dot.red {{ background: #ff5f56; }}
  .dot.yellow {{ background: #ffbd2e; }}
  .dot.green {{ background: #27c93f; }}
  .file-name {{
    color: #abb2bf;
    font-size: 13px;
    font-weight: 600;
    letter-spacing: 0.3px;
  }}
  .code-body {{
    padding: 16px 20px;
    font-size: 13.5px;
    line-height: 1.55;
    overflow-x: auto;
  }}
  .linenodiv {{
    border-right: 1px solid #3a3f4b;
    padding-right: 12px;
    margin-right: 12px;
  }}
  .linenodiv pre {{
    color: #5c6370 !important;
  }}
  {pygments_css}
</style>
</head>
<body>
  <div class="window" id="capture-target">
    <div class="title-bar">
      <div class="dots">
        <div class="dot red"></div>
        <div class="dot yellow"></div>
        <div class="dot green"></div>
      </div>
      <div class="file-name">{title}</div>
    </div>
    <div class="code-body">
      {highlighted_code}
    </div>
  </div>
</body>
</html>
"""

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page(device_scale_factor=2) # 2x resolution for retina-like sharpness

    for item in code_snippets:
        highlighted = highlight(item["code"], DartLexer(), formatter)
        full_html = html_template.format(
            pygments_css=pygments_css,
            title=item["title"],
            highlighted_code=highlighted
        )
        page.set_content(full_html)
        target = page.locator("#capture-target")
        out_path = os.path.join(output_dir, item["filename"])
        target.screenshot(path=out_path)
        print(f"Generated: {out_path}")

    browser.close()
print("All code screenshots generated successfully!")

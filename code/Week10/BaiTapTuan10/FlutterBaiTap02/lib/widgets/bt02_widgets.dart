import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/bt02_theme.dart';

enum Bt02LeadingIcon { home, back }

class Bt02AppBar extends StatelessWidget implements PreferredSizeWidget {
  const Bt02AppBar({
    required this.title,
    this.leadingIcon = Bt02LeadingIcon.home,
    this.onLeadingPressed,
    this.dark = false,
    super.key,
  });

  final String title;
  final Bt02LeadingIcon leadingIcon;
  final VoidCallback? onLeadingPressed;
  final bool dark;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final foreground = dark ? Colors.white : Bt02Colors.darkBlue;
    final asset = leadingIcon == Bt02LeadingIcon.home
        ? 'assets/figma/home.svg'
        : 'assets/figma/back.svg';
    final overlayStyle = dark
        ? const SystemUiOverlayStyle(
            statusBarColor: Bt02Colors.darkBlue,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          )
        : const SystemUiOverlayStyle(
            statusBarColor: Bt02Colors.gold,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          );

    return AppBar(
      toolbarHeight: 64,
      centerTitle: true,
      backgroundColor: dark ? Bt02Colors.darkBlue : Bt02Colors.gold,
      foregroundColor: foreground,
      systemOverlayStyle: overlayStyle,
      leadingWidth: 56,
      leading: IconButton(
        tooltip: leadingIcon == Bt02LeadingIcon.home ? 'Trang chủ' : 'Quay lại',
        onPressed:
            onLeadingPressed ??
            (leadingIcon == Bt02LeadingIcon.back
                ? () => Navigator.of(context).maybePop()
                : null),
        icon: SvgPicture.asset(
          asset,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: foreground,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: const [SizedBox(width: 56)],
    );
  }
}

class Bt02SectionHeader extends StatelessWidget {
  const Bt02SectionHeader(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Bt02Colors.sectionBlue,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Bt02Colors.surface,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class Bt02PrimaryButton extends StatelessWidget {
  const Bt02PrimaryButton({
    required this.label,
    required this.onPressed,
    this.iconAsset,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final String? iconAsset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Bt02Colors.primaryBlue,
          foregroundColor: Bt02Colors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        child: iconAsset == null
            ? Text(label)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    iconAsset!,
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      Bt02Colors.surface,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(label),
                ],
              ),
      ),
    );
  }
}

class Bt02ErrorState extends StatelessWidget {
  const Bt02ErrorState({
    required this.onRetry,
    this.technicalDetails,
    super.key,
  });

  final VoidCallback onRetry;
  final String? technicalDetails;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
      children: [
        const Text(
          'Có lỗi khi kết nối',
          style: TextStyle(
            color: Bt02Colors.text,
            fontSize: 20,
            height: 1.4,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 18),
        const Bt02SectionHeader('Trạng thái dữ liệu'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 24),
          decoration: BoxDecoration(
            color: Bt02Colors.surface,
            border: Border.all(color: Bt02Colors.border),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Bt02Colors.purpleSoft,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/figma/warning.svg',
                  width: 28,
                  height: 28,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Không thể tải dữ liệu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Bt02Colors.text,
                  fontSize: 18,
                  height: 1.45,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ứng dụng không truy cập được Web API. Hãy kiểm tra mạng hoặc địa chỉ máy chủ.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Bt02Colors.muted,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
              if (technicalDetails != null) ...[
                const SizedBox(height: 9),
                Text(
                  technicalDetails!,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Bt02Colors.muted,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        Bt02PrimaryButton(
          label: 'Thử tải lại',
          iconAsset: 'assets/figma/refresh.svg',
          onPressed: onRetry,
        ),
      ],
    );
  }
}

class Bt02EmptyStatePanel extends StatelessWidget {
  const Bt02EmptyStatePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
      decoration: BoxDecoration(
        color: Bt02Colors.surface,
        border: Border.all(color: Bt02Colors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Bt02Colors.purpleSoft,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              'assets/figma/no-results.svg',
              width: 28,
              height: 28,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Không có đề tài phù hợp',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Bt02Colors.text,
              fontSize: 18,
              height: 1.45,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Chưa có dữ liệu tương ứng với bộ lọc đang chọn. Hãy thử loại đề tài khác.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Bt02Colors.muted,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class Bt02LoadingCard extends StatelessWidget {
  const Bt02LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 114,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Bt02Colors.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Bt02Colors.surfaceAlt,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 196,
                height: 14,
                decoration: BoxDecoration(
                  color: Bt02Colors.surfaceAlt,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 9),
              Container(
                width: 143,
                height: 10,
                decoration: BoxDecoration(
                  color: Bt02Colors.surfaceAlt,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

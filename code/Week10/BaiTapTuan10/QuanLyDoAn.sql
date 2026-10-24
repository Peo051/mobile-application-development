-- ===================================
-- PHAN 1: TAO DATABASE
-- ===================================
IF DB_ID(N'QuanLyDoAn') IS NULL
BEGIN
    CREATE DATABASE QuanLyDoAn;
END
GO

USE [QuanLyDoAn];
GO

-- ===================================
-- PHAN 2: TAO CAC BANG
-- ===================================
-- Khoa chinh, UNIQUE va CHECK duoc khai bao cung voi bang.
IF OBJECT_ID(N'dbo.LoaiDeTai', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.LoaiDeTai
    (
        MaLoai  VARCHAR(10)   NOT NULL,
        TenLoai NVARCHAR(100) NOT NULL,

        CONSTRAINT PK_LoaiDeTai PRIMARY KEY (MaLoai),
        CONSTRAINT UQ_LoaiDeTai_TenLoai UNIQUE (TenLoai)
    );
END
GO

IF OBJECT_ID(N'dbo.ChuyenNganh', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ChuyenNganh
    (
        MaCN  VARCHAR(10)    NOT NULL,
        TenCN NVARCHAR(150)  NOT NULL,
        MoTa  NVARCHAR(500)  NULL,

        CONSTRAINT PK_ChuyenNganh PRIMARY KEY (MaCN),
        CONSTRAINT UQ_ChuyenNganh_TenCN UNIQUE (TenCN)
    );
END
GO

IF OBJECT_ID(N'dbo.DeTai', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DeTai
    (
        MaDeTai          VARCHAR(10)    NOT NULL,
        TenDeTai         NVARCHAR(250)  NOT NULL,
        SoLuongSVToiDa   INT            NOT NULL,
        GiangVienHuongDan NVARCHAR(150) NULL,
        YeuCauDeTai      NVARCHAR(MAX)  NULL,
        MaLoai           VARCHAR(10)    NULL,
        MaCN             VARCHAR(10)    NOT NULL,

        CONSTRAINT PK_DeTai PRIMARY KEY (MaDeTai),
        CONSTRAINT CK_DeTai_SoLuongSVToiDa CHECK (SoLuongSVToiDa > 0)
    );
END
GO

IF OBJECT_ID(N'dbo.NganhHoc', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.NganhHoc
    (
        MaNganh          VARCHAR(10)    NOT NULL,
        TenNganh         NVARCHAR(150)  NOT NULL,
        GioiThieu        NVARCHAR(MAX)  NULL,
        KienThucDaoTao   NVARCHAR(MAX)  NULL,
        CoHoiNgheNghiep  NVARCHAR(MAX)  NULL,

        CONSTRAINT PK_NganhHoc PRIMARY KEY (MaNganh)
    );
END
GO

-- ===================================
-- PHAN 3: KHOA NGOAI VA RANG BUOC
-- ===================================
-- DeTai.MaLoai duoc phep NULL khi nguon chua xac dinh loai de tai.
IF NOT EXISTS
(
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = N'FK_DeTai_LoaiDeTai'
      AND parent_object_id = OBJECT_ID(N'dbo.DeTai')
)
BEGIN
    ALTER TABLE dbo.DeTai WITH CHECK
        ADD CONSTRAINT FK_DeTai_LoaiDeTai
        FOREIGN KEY (MaLoai) REFERENCES dbo.LoaiDeTai (MaLoai);
END
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = N'FK_DeTai_ChuyenNganh'
      AND parent_object_id = OBJECT_ID(N'dbo.DeTai')
)
BEGIN
    ALTER TABLE dbo.DeTai WITH CHECK
        ADD CONSTRAINT FK_DeTai_ChuyenNganh
        FOREIGN KEY (MaCN) REFERENCES dbo.ChuyenNganh (MaCN);
END
GO

-- Bat lai va kiem tra khoa ngoai neu bang da ton tai tu truoc.
ALTER TABLE dbo.DeTai WITH CHECK CHECK CONSTRAINT FK_DeTai_LoaiDeTai;
ALTER TABLE dbo.DeTai WITH CHECK CHECK CONSTRAINT FK_DeTai_ChuyenNganh;
GO

-- Index phuc vu loc de tai theo loai va chuyen nganh.
IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_DeTai_MaLoai'
      AND object_id = OBJECT_ID(N'dbo.DeTai')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_DeTai_MaLoai
        ON dbo.DeTai (MaLoai);
END
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_DeTai_MaCN'
      AND object_id = OBJECT_ID(N'dbo.DeTai')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_DeTai_MaCN
        ON dbo.DeTai (MaCN);
END
GO

-- ===================================
-- PHAN 4: THEM DU LIEU MAU
-- ===================================
-- Them theo khoa chinh va ten duy nhat; khong ghi de cac ban ghi da co.
SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRANSACTION;

    -- Du lieu goc Bài 10: bon loai de tai duoc the hien trong tai lieu va Figma.
    INSERT INTO dbo.LoaiDeTai (MaLoai, TenLoai)
    SELECT seed.MaLoai, seed.TenLoai
    FROM (VALUES
        ('DA',    N'Đồ án'),
        ('KLKS',  N'KLKS'),
        ('LV',    N'Luận văn'),
        ('KHAC',  N'Khác')
    ) AS seed (MaLoai, TenLoai)
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.LoaiDeTai AS currentRow
        WHERE currentRow.MaLoai = seed.MaLoai
           OR currentRow.TenLoai = seed.TenLoai
    );

    -- Du lieu goc Bài 10 gom bon chuyen nganh; Kỹ thuật phần mềm giu nguyen DT001 Week 3.
    -- MoTa bon chuyen nganh tren man hinh duoc doi chieu theo hinh mau trang 20.
    INSERT INTO dbo.ChuyenNganh (MaCN, TenCN, MoTa)
    SELECT seed.MaCN, seed.TenCN, seed.MoTa
    FROM (VALUES
        ('CNPM', N'Công nghệ phần mềm', N'Phát triển các ứng dụng giải quyết các vấn đề thực tế.'),
        ('HTTT', N'Hệ thống thông tin', N'Phát triển các kỹ thuật xử lý thông tin trong tổ chức.'),
        ('MMT',  N'Mạng máy tính', N'Xử lý các vấn đề liên quan đến mạng máy tính.'),
        ('ATTT', N'An toàn thông tin', N'Thiết kế và đảm bảo an toàn cho hệ thống máy tính.'),
        ('KTPM', N'Kỹ thuật phần mềm', CAST(NULL AS NVARCHAR(500)))
    ) AS seed (MaCN, TenCN, MoTa)
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.ChuyenNganh AS currentRow
        WHERE currentRow.MaCN = seed.MaCN
           OR currentRow.TenCN = seed.TenCN
    );

    -- Bo sung MoTa cho cac ban ghi da co neu truong nay con NULL; giu nguyen mo ta hien tai.
    UPDATE currentRow
    SET MoTa = seed.MoTa
    FROM dbo.ChuyenNganh AS currentRow
    INNER JOIN (VALUES
        ('CNPM', N'Công nghệ phần mềm', N'Phát triển các ứng dụng giải quyết các vấn đề thực tế.'),
        ('HTTT', N'Hệ thống thông tin', N'Phát triển các kỹ thuật xử lý thông tin trong tổ chức.'),
        ('MMT',  N'Mạng máy tính', N'Xử lý các vấn đề liên quan đến mạng máy tính.'),
        ('ATTT', N'An toàn thông tin', N'Thiết kế và đảm bảo an toàn cho hệ thống máy tính.')
    ) AS seed (MaCN, TenCN, MoTa)
        ON seed.MaCN = currentRow.MaCN
       AND seed.TenCN = currentRow.TenCN
    WHERE currentRow.MoTa IS NULL;

    -- Du lieu goc Week 3: DT001; MaLoai = NULL vi source khong xac nhan loai de tai.
    INSERT INTO dbo.DeTai
    (
        MaDeTai, TenDeTai, SoLuongSVToiDa, GiangVienHuongDan,
        YeuCauDeTai, MaLoai, MaCN
    )
    SELECT seed.MaDeTai, seed.TenDeTai, seed.SoLuongSVToiDa, seed.GiangVienHuongDan,
           seed.YeuCauDeTai, seed.MaLoai, seed.MaCN
    FROM (VALUES
        ('DT001',
         N'Xây dựng ứng dụng quản lý cửa hàng thú cưng',
         3,
         N'ThS. Nguyễn Văn A',
         N'Sinh viên có kiến thức về Flutter, Dart, cơ sở dữ liệu và phân tích thiết kế hệ thống.',
         CAST(NULL AS VARCHAR(10)),
         'KTPM')
    ) AS seed
      (MaDeTai, TenDeTai, SoLuongSVToiDa, GiangVienHuongDan, YeuCauDeTai, MaLoai, MaCN)
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.DeTai AS currentRow
        WHERE currentRow.MaDeTai = seed.MaDeTai
    );

    -- Du lieu mau minh hoa (DT002-DT010), phan bo qua cac loai va chuyen nganh.
    INSERT INTO dbo.DeTai
    (
        MaDeTai, TenDeTai, SoLuongSVToiDa, GiangVienHuongDan,
        YeuCauDeTai, MaLoai, MaCN
    )
    SELECT seed.MaDeTai, seed.TenDeTai, seed.SoLuongSVToiDa, NULL,
           seed.YeuCauDeTai, seed.MaLoai, seed.MaCN
    FROM (VALUES
        ('DT002', N'Xây dựng ứng dụng quản lý bán hàng trực tuyến', 3,
         N'Phân tích yêu cầu và xây dựng ứng dụng có chức năng quản lý sản phẩm, đơn hàng và báo cáo.',
         'DA', 'CNPM'),
        ('DT003', N'Phân tích và thiết kế hệ thống quản lý thư viện', 2,
         N'Mô hình hóa quy trình quản lý sách, bạn đọc, mượn và trả sách.',
         'KLKS', 'HTTT'),
        ('DT004', N'Mô phỏng giám sát hiệu năng mạng máy tính', 3,
         N'Thu thập và trình bày một số chỉ số hoạt động của mạng trong môi trường mô phỏng.',
         'DA', 'MMT'),
        ('DT005', N'Nghiên cứu giải pháp phát hiện xâm nhập mạng', 2,
         N'Tìm hiểu và đánh giá phương pháp nhận diện dấu hiệu truy cập mạng bất thường.',
         'LV', 'ATTT'),
        ('DT006', N'Xây dựng ứng dụng di động hỗ trợ lập kế hoạch học tập', 3,
         N'Thiết kế giao diện và chức năng quản lý môn học, lịch học và nhắc việc.',
         'DA', 'KTPM'),
        ('DT007', N'Phân tích dữ liệu phục vụ báo cáo quản trị doanh nghiệp', 2,
         N'Tổ chức dữ liệu mẫu và xây dựng các báo cáo tổng hợp phục vụ tra cứu.',
         'KLKS', 'HTTT'),
        ('DT008', N'Xây dựng cổng thông tin việc làm cho sinh viên', 3,
         N'Thiết kế chức năng đăng tin, tìm kiếm và xem thông tin cơ hội việc làm.',
         'KHAC', 'CNPM'),
        ('DT009', N'Nghiên cứu giải pháp xác thực đa yếu tố cho ứng dụng web', 2,
         N'Tìm hiểu các phương thức xác thực và đánh giá khả năng áp dụng cho ứng dụng web.',
         'LV', 'ATTT'),
        ('DT010', N'Mô phỏng mạng máy tính cho phòng thực hành', 3,
         N'Thiết kế sơ đồ mạng mẫu và kiểm tra kết nối giữa các thiết bị trong mô phỏng.',
         'KHAC', 'MMT')
    ) AS seed
      (MaDeTai, TenDeTai, SoLuongSVToiDa, YeuCauDeTai, MaLoai, MaCN)
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.DeTai AS currentRow
        WHERE currentRow.MaDeTai = seed.MaDeTai
    );

    -- Du lieu goc Week 3 lab05; noi dung duoc giu theo source Dart.
    INSERT INTO dbo.NganhHoc
    (
        MaNganh, TenNganh, GioiThieu, KienThucDaoTao, CoHoiNgheNghiep
    )
    SELECT seed.MaNganh, seed.TenNganh, seed.GioiThieu, seed.KienThucDaoTao,
           seed.CoHoiNgheNghiep
    FROM (VALUES
        ('7480201',
         N'CÔNG NGHỆ THÔNG TIN',
         N'Ngành Công nghệ Thông tin đào tạo kiến thức và kỹ năng về phát triển phần mềm, hệ thống thông tin, cơ sở dữ liệu, mạng máy tính và các công nghệ hiện đại.',
         N'Lập trình, cơ sở dữ liệu, phát triển Web/Mobile, phân tích thiết kế hệ thống, trí tuệ nhân tạo và công nghệ phần mềm.',
         N'Lập trình viên, kỹ sư phần mềm, Web Developer, Mobile Developer, kiểm thử phần mềm, quản trị hệ thống...'),
        ('7480202',
         N'AN TOÀN THÔNG TIN',
         N'Ngành An toàn Thông tin đào tạo kiến thức về bảo vệ hệ thống máy tính, mạng và dữ liệu trước các nguy cơ tấn công và truy cập trái phép.',
         N'An ninh mạng, mật mã học, bảo mật hệ thống, bảo mật Web, kiểm thử xâm nhập và quản lý an toàn thông tin.',
         N'Kỹ sư an ninh mạng, chuyên viên bảo mật, Security Engineer, SOC Analyst, Pentester...')
    ) AS seed
      (MaNganh, TenNganh, GioiThieu, KienThucDaoTao, CoHoiNgheNghiep)
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.NganhHoc AS currentRow
        WHERE currentRow.MaNganh = seed.MaNganh
    );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO

-- ===================================
-- PHAN 5: CAC CAU TRUY VAN KIEM THU
-- ===================================
-- 1. Danh sach loai de tai.
SELECT MaLoai, TenLoai
FROM dbo.LoaiDeTai
ORDER BY MaLoai;

-- 2. Danh sach chuyen nganh.
SELECT MaCN, TenCN, MoTa
FROM dbo.ChuyenNganh
ORDER BY MaCN;

-- 3. Danh sach tat ca de tai.
SELECT MaDeTai, TenDeTai, SoLuongSVToiDa, GiangVienHuongDan,
       MaLoai, MaCN
FROM dbo.DeTai
ORDER BY MaDeTai;

-- 4. Chi tiet DT001; LEFT JOIN de van hien thi khi MaLoai chua duoc xac dinh.
SELECT d.MaDeTai, d.TenDeTai, d.SoLuongSVToiDa, d.GiangVienHuongDan,
       d.YeuCauDeTai, d.MaLoai, l.TenLoai, d.MaCN, cn.TenCN
FROM dbo.DeTai AS d
LEFT JOIN dbo.LoaiDeTai AS l ON l.MaLoai = d.MaLoai
INNER JOIN dbo.ChuyenNganh AS cn ON cn.MaCN = d.MaCN
WHERE d.MaDeTai = 'DT001';

-- 5. De tai theo loai (vi du: KLKS).
DECLARE @MaLoaiCanTim VARCHAR(10) = 'KLKS';
SELECT d.MaDeTai, d.TenDeTai, d.SoLuongSVToiDa, d.MaLoai, l.TenLoai, d.MaCN
FROM dbo.DeTai AS d
INNER JOIN dbo.LoaiDeTai AS l ON l.MaLoai = d.MaLoai
WHERE d.MaLoai = @MaLoaiCanTim
ORDER BY d.MaDeTai;

-- 6. De tai theo chuyen nganh (vi du: ATTT).
DECLARE @MaCNCanTim VARCHAR(10) = 'ATTT';
SELECT d.MaDeTai, d.TenDeTai, d.SoLuongSVToiDa, d.MaCN, cn.TenCN, d.MaLoai
FROM dbo.DeTai AS d
INNER JOIN dbo.ChuyenNganh AS cn ON cn.MaCN = d.MaCN
WHERE d.MaCN = @MaCNCanTim
ORDER BY d.MaDeTai;

-- 7. JOIN de lay ten loai va ten chuyen nganh cho moi de tai.
SELECT d.MaDeTai, d.TenDeTai, d.SoLuongSVToiDa,
       l.TenLoai, cn.TenCN, d.GiangVienHuongDan
FROM dbo.DeTai AS d
LEFT JOIN dbo.LoaiDeTai AS l ON l.MaLoai = d.MaLoai
INNER JOIN dbo.ChuyenNganh AS cn ON cn.MaCN = d.MaCN
ORDER BY d.MaDeTai;

-- 8. Thong tin hai nganh hoc duoc doi chieu tu Week 3.
SELECT MaNganh, TenNganh, GioiThieu, KienThucDaoTao, CoHoiNgheNghiep
FROM dbo.NganhHoc
WHERE MaNganh IN ('7480201', '7480202')
ORDER BY MaNganh;

-- 9. Tong so ban ghi cua tung bang.
SELECT N'LoaiDeTai' AS TenBang, COUNT_BIG(*) AS SoLuongBanGhi FROM dbo.LoaiDeTai
UNION ALL
SELECT N'ChuyenNganh', COUNT_BIG(*) FROM dbo.ChuyenNganh
UNION ALL
SELECT N'DeTai', COUNT_BIG(*) FROM dbo.DeTai
UNION ALL
SELECT N'NganhHoc', COUNT_BIG(*) FROM dbo.NganhHoc;

-- 10. Ban ghi thieu hoac sai quan he (ket qua mong doi: khong co dong).
-- MaLoai NULL duoc chap nhan neu chua xac dinh loai de tai.
SELECT d.MaDeTai, d.MaLoai, d.MaCN,
       CASE
           WHEN cn.MaCN IS NULL THEN N'Thiếu hoặc sai mã chuyên ngành'
           WHEN d.MaLoai IS NOT NULL AND l.MaLoai IS NULL THEN N'Thiếu hoặc sai mã loại đề tài'
       END AS LoiQuanHe
FROM dbo.DeTai AS d
LEFT JOIN dbo.LoaiDeTai AS l ON l.MaLoai = d.MaLoai
LEFT JOIN dbo.ChuyenNganh AS cn ON cn.MaCN = d.MaCN
WHERE cn.MaCN IS NULL
   OR (d.MaLoai IS NOT NULL AND l.MaLoai IS NULL);
GO

-- ===================================
-- PHAN 6: KIEM TRA TOAN VEN DU LIEU
-- ===================================
-- DBCC tra ve cac vi pham rang buoc neu co; ket qua mong doi la khong co vi pham.
DBCC CHECKCONSTRAINTS WITH ALL_CONSTRAINTS;
GO

-- Kiem tra khoa ngoai dang bi vo hieu hoa hoac chua duoc tin cay (ket qua mong doi: 0 dong).
SELECT name AS TenKhoaNgoai, is_disabled AS BiVoHieuHoa,
       is_not_trusted AS ChuaDuocKiemTraDayDu
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID(N'dbo.DeTai')
  AND (is_disabled = 1 OR is_not_trusted = 1);

-- Kiem tra suc chua sinh vien khong hop le (ket qua mong doi: 0 dong; CHECK da ngan du lieu nay).
SELECT MaDeTai, SoLuongSVToiDa
FROM dbo.DeTai
WHERE SoLuongSVToiDa <= 0;
GO

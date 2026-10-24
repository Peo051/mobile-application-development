using Microsoft.EntityFrameworkCore;
using QuanLyDoAnApi.Entities;

namespace QuanLyDoAnApi.Data;

// Ánh xạ theo schema QuanLyDoAn.sql (không dùng Migration hoặc EnsureCreated).
// Vì không truy cập được SQL Server trên máy người dùng, các ánh xạ này được
// dựng từ file SQL; chưa phải mã thực thi Scaffold-DbContext trên máy người dùng.
public class QuanLyDoAnContext : DbContext
{
    public QuanLyDoAnContext(DbContextOptions<QuanLyDoAnContext> options)
        : base(options) { }

    public DbSet<LoaiDeTai> LoaiDeTais => Set<LoaiDeTai>();
    public DbSet<ChuyenNganh> ChuyenNganhs => Set<ChuyenNganh>();
    public DbSet<DeTai> DeTais => Set<DeTai>();
    public DbSet<NganhHoc> NganhHocs => Set<NganhHoc>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<LoaiDeTai>(entity =>
        {
            entity.ToTable("LoaiDeTai", "dbo");
            entity.HasKey(e => e.MaLoai).HasName("PK_LoaiDeTai");
            entity.HasIndex(e => e.TenLoai).IsUnique().HasDatabaseName("UQ_LoaiDeTai_TenLoai");
            entity.Property(e => e.MaLoai).HasMaxLength(10).IsUnicode(false);
            entity.Property(e => e.TenLoai).HasMaxLength(100).IsRequired();
        });

        modelBuilder.Entity<ChuyenNganh>(entity =>
        {
            entity.ToTable("ChuyenNganh", "dbo");
            entity.HasKey(e => e.MaCN).HasName("PK_ChuyenNganh");
            entity.HasIndex(e => e.TenCN).IsUnique().HasDatabaseName("UQ_ChuyenNganh_TenCN");
            entity.Property(e => e.MaCN).HasMaxLength(10).IsUnicode(false);
            entity.Property(e => e.TenCN).HasMaxLength(150).IsRequired();
            entity.Property(e => e.MoTa).HasMaxLength(500);
        });

        modelBuilder.Entity<DeTai>(entity =>
        {
            entity.ToTable("DeTai", "dbo");
            entity.HasKey(e => e.MaDeTai).HasName("PK_DeTai");
            entity.HasIndex(e => e.MaLoai).HasDatabaseName("IX_DeTai_MaLoai");
            entity.HasIndex(e => e.MaCN).HasDatabaseName("IX_DeTai_MaCN");
            entity.Property(e => e.MaDeTai).HasMaxLength(10).IsUnicode(false);
            entity.Property(e => e.TenDeTai).HasMaxLength(250).IsRequired();
            entity.Property(e => e.GiangVienHuongDan).HasMaxLength(150);
            entity.Property(e => e.MaLoai).HasMaxLength(10).IsUnicode(false).IsRequired(false);
            entity.Property(e => e.MaCN).HasMaxLength(10).IsUnicode(false).IsRequired();
            // Giữ NULL cho MaLoai; không xóa dây chuyền nếu xóa chuyên ngành/loại.
            entity.HasOne(e => e.LoaiDeTai)
                .WithMany(e => e.DeTais)
                .HasForeignKey(e => e.MaLoai)
                .OnDelete(DeleteBehavior.NoAction)
                .HasConstraintName("FK_DeTai_LoaiDeTai");
            entity.HasOne(e => e.ChuyenNganh)
                .WithMany(e => e.DeTais)
                .HasForeignKey(e => e.MaCN)
                .OnDelete(DeleteBehavior.NoAction)
                .HasConstraintName("FK_DeTai_ChuyenNganh");
        });

        modelBuilder.Entity<NganhHoc>(entity =>
        {
            entity.ToTable("NganhHoc", "dbo");
            entity.HasKey(e => e.MaNganh).HasName("PK_NganhHoc");
            entity.Property(e => e.MaNganh).HasMaxLength(10).IsUnicode(false);
            entity.Property(e => e.TenNganh).HasMaxLength(150).IsRequired();
        });
    }
}

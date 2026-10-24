namespace QuanLyDoAnApi.Entities;

// Bảng dbo.DeTai. MaLoai có thể NULL, nhất là DT001 từ source Week 3.
public class DeTai
{
    public string MaDeTai { get; set; } = null!;
    public string TenDeTai { get; set; } = null!;
    public int SoLuongSVToiDa { get; set; }
    public string? GiangVienHuongDan { get; set; }
    public string? YeuCauDeTai { get; set; }
    public string? MaLoai { get; set; }
    public string MaCN { get; set; } = null!;

    public LoaiDeTai? LoaiDeTai { get; set; }
    public ChuyenNganh ChuyenNganh { get; set; } = null!;
}

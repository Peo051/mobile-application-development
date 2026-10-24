namespace QuanLyDoAnApi.Entities;

// Bảng dbo.LoaiDeTai trong database QuanLyDoAn.
public class LoaiDeTai
{
    public string MaLoai { get; set; } = null!;
    public string TenLoai { get; set; } = null!;

    public ICollection<DeTai> DeTais { get; set; } = new List<DeTai>();
}

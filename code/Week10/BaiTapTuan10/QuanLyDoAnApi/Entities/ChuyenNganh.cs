namespace QuanLyDoAnApi.Entities;

// Bảng dbo.ChuyenNganh.
public class ChuyenNganh
{
    public string MaCN { get; set; } = null!;
    public string TenCN { get; set; } = null!;
    public string? MoTa { get; set; }

    public ICollection<DeTai> DeTais { get; set; } = new List<DeTai>();
}

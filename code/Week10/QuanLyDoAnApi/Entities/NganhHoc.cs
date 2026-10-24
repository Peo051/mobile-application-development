namespace QuanLyDoAnApi.Entities;

// Bảng dbo.NganhHoc.
public class NganhHoc
{
    public string MaNganh { get; set; } = null!;
    public string TenNganh { get; set; } = null!;
    public string? GioiThieu { get; set; }
    public string? KienThucDaoTao { get; set; }
    public string? CoHoiNgheNghiep { get; set; }
}

namespace QuanLyDoAnApi.DTOs;

public sealed record DeTaiChiTietDto(
    string MaDeTai,
    string TenDeTai,
    int SoLuongSinhVienToiDa,
    string? MaLoai,
    string? TenLoai,
    string MaCN,
    string TenCN,
    string? GiangVienHuongDan,
    string? YeuCauDeTai);

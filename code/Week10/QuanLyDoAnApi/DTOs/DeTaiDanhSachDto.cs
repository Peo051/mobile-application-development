namespace QuanLyDoAnApi.DTOs;

public sealed record DeTaiDanhSachDto(
    string MaDeTai,
    string TenDeTai,
    int SoLuongSinhVienToiDa,
    string? MaLoai,
    string? TenLoai,
    string MaCN,
    string TenCN,
    string? GiangVienHuongDan);

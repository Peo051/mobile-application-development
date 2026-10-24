namespace QuanLyDoAnApi.DTOs;

public sealed record NganhHocDto(
    string MaNganh,
    string TenNganh,
    string? GioiThieu,
    string? KienThucDaoTao,
    string? CoHoiNgheNghiep);

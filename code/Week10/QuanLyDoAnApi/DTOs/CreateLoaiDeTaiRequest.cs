using System.ComponentModel.DataAnnotations;

namespace QuanLyDoAnApi.DTOs;

public sealed class CreateLoaiDeTaiRequest
{
    [Required]
    [StringLength(10)]
    public string MaLoai { get; init; } = string.Empty;

    [Required]
    [StringLength(100)]
    public string TenLoai { get; init; } = string.Empty;
}

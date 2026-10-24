using System.ComponentModel.DataAnnotations;

namespace QuanLyDoAnApi.DTOs;

public sealed class UpdateLoaiDeTaiRequest
{
    [Required]
    [StringLength(100)]
    public string TenLoai { get; init; } = string.Empty;
}

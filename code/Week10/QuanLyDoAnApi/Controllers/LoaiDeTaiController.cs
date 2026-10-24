using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyDoAnApi.Data;
using QuanLyDoAnApi.DTOs;
using QuanLyDoAnApi.Entities;

namespace QuanLyDoAnApi.Controllers;

[ApiController]
[Route("api/loai-de-tai")]
public class LoaiDeTaiController : ControllerBase
{
    private readonly QuanLyDoAnContext _db;

    public LoaiDeTaiController(QuanLyDoAnContext db) => _db = db;

    // GET /api/loai-de-tai
    [HttpGet]
    public async Task<ActionResult<List<LoaiDeTaiDto>>> GetAll(CancellationToken ct)
    {
        var data = await _db.Set<LoaiDeTai>()
            .AsNoTracking()
            .OrderBy(x => x.MaLoai)
            .Select(x => new LoaiDeTaiDto(x.MaLoai, x.TenLoai))
            .ToListAsync(ct);

        return Ok(data);
    }
}

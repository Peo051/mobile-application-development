using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyDoAnApi.Data;
using QuanLyDoAnApi.DTOs;
using QuanLyDoAnApi.Entities;

namespace QuanLyDoAnApi.Controllers;

[ApiController]
[Route("api/chuyen-nganh")]
public class ChuyenNganhController : ControllerBase
{
    private readonly QuanLyDoAnContext _db;

    public ChuyenNganhController(QuanLyDoAnContext db) => _db = db;

    // GET /api/chuyen-nganh
    [HttpGet]
    public async Task<ActionResult<List<ChuyenNganhDto>>> GetAll(CancellationToken ct)
    {
        var data = await _db.Set<ChuyenNganh>()
            .AsNoTracking()
            .OrderBy(x => x.MaCN)
            .Select(x => new ChuyenNganhDto(x.MaCN, x.TenCN, x.MoTa))
            .ToListAsync(ct);

        return Ok(data);
    }
}

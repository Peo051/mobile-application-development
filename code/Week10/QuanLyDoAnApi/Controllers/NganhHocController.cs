using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyDoAnApi.Data;
using QuanLyDoAnApi.DTOs;
using QuanLyDoAnApi.Entities;

namespace QuanLyDoAnApi.Controllers;

[ApiController]
[Route("api/nganh-hoc")]
public class NganhHocController : ControllerBase
{
    private readonly QuanLyDoAnContext _db;

    public NganhHocController(QuanLyDoAnContext db) => _db = db;

    // GET /api/nganh-hoc
    [HttpGet]
    public async Task<ActionResult<List<NganhHocDto>>> GetAll(CancellationToken ct)
    {
        var data = await _db.Set<NganhHoc>()
            .AsNoTracking()
            .OrderBy(x => x.MaNganh)
            .Select(x => new NganhHocDto(
                x.MaNganh,
                x.TenNganh,
                x.GioiThieu,
                x.KienThucDaoTao,
                x.CoHoiNgheNghiep))
            .ToListAsync(ct);

        return Ok(data);
    }

    // GET /api/nganh-hoc/7480201
    [HttpGet("{maNganh}")]
    public async Task<ActionResult<NganhHocDto>> GetById(
        [FromRoute] string maNganh, CancellationToken ct)
    {
        var data = await _db.Set<NganhHoc>()
            .AsNoTracking()
            .Where(x => x.MaNganh == maNganh)
            .Select(x => new NganhHocDto(
                x.MaNganh,
                x.TenNganh,
                x.GioiThieu,
                x.KienThucDaoTao,
                x.CoHoiNgheNghiep))
            .FirstOrDefaultAsync(ct);

        return data is null ? NotFound() : Ok(data);
    }
}

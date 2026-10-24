using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
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
        var data = await _db.LoaiDeTais
            .AsNoTracking()
            .OrderBy(x => x.MaLoai)
            .Select(x => new LoaiDeTaiDto(x.MaLoai, x.TenLoai))
            .ToListAsync(ct);

        return Ok(data);
    }

    // GET /api/loai-de-tai/KLKS
    [HttpGet("{maLoai}")]
    public async Task<ActionResult<LoaiDeTaiDto>> GetById(
        [FromRoute] string maLoai, CancellationToken ct)
    {
        string key = maLoai.Trim();
        var data = await _db.LoaiDeTais
            .AsNoTracking()
            .Where(x => x.MaLoai == key)
            .Select(x => new LoaiDeTaiDto(x.MaLoai, x.TenLoai))
            .FirstOrDefaultAsync(ct);

        return data is null ? NotFound() : Ok(data);
    }

    // POST /api/loai-de-tai
    [HttpPost]
    public async Task<ActionResult<LoaiDeTaiDto>> Create(
        [FromBody] CreateLoaiDeTaiRequest request, CancellationToken ct)
    {
        string maLoai = request.MaLoai.Trim();
        string tenLoai = request.TenLoai.Trim();

        if (await _db.LoaiDeTais.AnyAsync(x => x.MaLoai == maLoai, ct))
        {
            return Conflict(CreateConflict("Mã loại đề tài đã tồn tại."));
        }

        if (await _db.LoaiDeTais.AnyAsync(x => x.TenLoai == tenLoai, ct))
        {
            return Conflict(CreateConflict("Tên loại đề tài đã tồn tại."));
        }

        var entity = new LoaiDeTai
        {
            MaLoai = maLoai,
            TenLoai = tenLoai
        };

        _db.LoaiDeTais.Add(entity);

        try
        {
            await _db.SaveChangesAsync(ct);
        }
        catch (DbUpdateException exception) when (IsUniqueConstraintViolation(exception))
        {
            // Cơ sở dữ liệu vẫn là lớp bảo vệ cuối cùng nếu có request đồng thời.
            return Conflict(CreateConflict("Mã hoặc tên loại đề tài đã tồn tại."));
        }

        var result = new LoaiDeTaiDto(entity.MaLoai, entity.TenLoai);
        return CreatedAtAction(nameof(GetById), new { maLoai = entity.MaLoai }, result);
    }

    // PUT /api/loai-de-tai/KLKS
    [HttpPut("{maLoai}")]
    public async Task<ActionResult<LoaiDeTaiDto>> Update(
        [FromRoute] string maLoai,
        [FromBody] UpdateLoaiDeTaiRequest request,
        CancellationToken ct)
    {
        string key = maLoai.Trim();
        string tenLoai = request.TenLoai.Trim();

        var entity = await _db.LoaiDeTais
            .FirstOrDefaultAsync(x => x.MaLoai == key, ct);

        if (entity is null)
        {
            return NotFound();
        }

        if (await _db.LoaiDeTais.AnyAsync(
                x => x.MaLoai != key && x.TenLoai == tenLoai, ct))
        {
            return Conflict(CreateConflict("Tên loại đề tài đã tồn tại."));
        }

        entity.TenLoai = tenLoai;

        try
        {
            await _db.SaveChangesAsync(ct);
        }
        catch (DbUpdateException exception) when (IsUniqueConstraintViolation(exception))
        {
            return Conflict(CreateConflict("Tên loại đề tài đã tồn tại."));
        }

        return Ok(new LoaiDeTaiDto(entity.MaLoai, entity.TenLoai));
    }

    // DELETE /api/loai-de-tai/KLKS
    [HttpDelete("{maLoai}")]
    public async Task<IActionResult> Delete([FromRoute] string maLoai, CancellationToken ct)
    {
        string key = maLoai.Trim();
        var entity = await _db.LoaiDeTais
            .FirstOrDefaultAsync(x => x.MaLoai == key, ct);

        if (entity is null)
        {
            return NotFound();
        }

        if (await _db.DeTais.AnyAsync(x => x.MaLoai == key, ct))
        {
            return Conflict(CreateConflict(
                "Không thể xóa loại đề tài đang được đề tài sử dụng."));
        }

        _db.LoaiDeTais.Remove(entity);

        try
        {
            await _db.SaveChangesAsync(ct);
        }
        catch (DbUpdateException exception) when (IsForeignKeyViolation(exception))
        {
            // Bảo vệ trường hợp một đề tài tham chiếu loại này được thêm đồng thời.
            return Conflict(CreateConflict(
                "Không thể xóa loại đề tài đang được đề tài sử dụng."));
        }

        return NoContent();
    }

    private static ProblemDetails CreateConflict(string detail) => new()
    {
        Status = StatusCodes.Status409Conflict,
        Title = "Dữ liệu không thể được lưu.",
        Detail = detail
    };

    private static bool IsUniqueConstraintViolation(DbUpdateException exception) =>
        exception.InnerException is SqlException { Number: 2601 or 2627 };

    private static bool IsForeignKeyViolation(DbUpdateException exception) =>
        exception.InnerException is SqlException { Number: 547 };
}

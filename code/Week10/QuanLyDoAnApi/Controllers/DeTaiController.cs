using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyDoAnApi.Data;
using QuanLyDoAnApi.DTOs;
using QuanLyDoAnApi.Entities;

namespace QuanLyDoAnApi.Controllers;

[ApiController]
[Route("api/de-tai")]
public class DeTaiController : ControllerBase
{
    private readonly QuanLyDoAnContext _db;

    public DeTaiController(QuanLyDoAnContext db) => _db = db;

    // GET /api/de-tai?maLoai=KLKS&maCN=HTTT
    // Bỏ trống tham số để lấy tất cả đề tài, bao gồm DT001 có MaLoai = NULL.
    [HttpGet]
    public async Task<ActionResult<List<DeTaiDanhSachDto>>> GetAll(
        [FromQuery] string? maLoai,
        [FromQuery] string? maCN,
        CancellationToken ct)
    {
        IQueryable<DeTai> query = _db.Set<DeTai>().AsNoTracking();

        if (!string.IsNullOrWhiteSpace(maLoai))
        {
            string value = maLoai.Trim();
            query = query.Where(x => x.MaLoai == value);
        }

        if (!string.IsNullOrWhiteSpace(maCN))
        {
            string value = maCN.Trim();
            query = query.Where(x => x.MaCN == value);
        }

        // LEFT JOIN LoaiDeTai để vẫn lấy DT001 khi MaLoai là NULL.
        var result = await (
            from d in query
            join cn in _db.Set<ChuyenNganh>().AsNoTracking()
                on d.MaCN equals cn.MaCN
            join l in _db.Set<LoaiDeTai>().AsNoTracking()
                on d.MaLoai equals l.MaLoai into loaiJoin
            from l in loaiJoin.DefaultIfEmpty()
            orderby d.MaDeTai
            select new DeTaiDanhSachDto(
                d.MaDeTai,
                d.TenDeTai,
                d.SoLuongSVToiDa,
                d.MaLoai,
                l == null ? null : l.TenLoai,
                d.MaCN,
                cn.TenCN,
                d.GiangVienHuongDan)
        ).ToListAsync(ct);

        return Ok(result);
    }

    // GET /api/de-tai/DT001
    [HttpGet("{maDeTai}")]
    public async Task<ActionResult<DeTaiChiTietDto>> GetById(
        [FromRoute] string maDeTai, CancellationToken ct)
    {
        var result = await (
            from d in _db.Set<DeTai>().AsNoTracking()
            join cn in _db.Set<ChuyenNganh>().AsNoTracking()
                on d.MaCN equals cn.MaCN
            join l in _db.Set<LoaiDeTai>().AsNoTracking()
                on d.MaLoai equals l.MaLoai into loaiJoin
            from l in loaiJoin.DefaultIfEmpty()
            where d.MaDeTai == maDeTai
            select new DeTaiChiTietDto(
                d.MaDeTai,
                d.TenDeTai,
                d.SoLuongSVToiDa,
                d.MaLoai,
                l == null ? null : l.TenLoai,
                d.MaCN,
                cn.TenCN,
                d.GiangVienHuongDan,
                d.YeuCauDeTai)
        ).FirstOrDefaultAsync(ct);

        return result is null ? NotFound() : Ok(result);
    }
}

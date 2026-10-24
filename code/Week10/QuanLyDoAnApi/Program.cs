using Microsoft.EntityFrameworkCore;
using QuanLyDoAnApi.Data;
using System.Text.Json;

var builder = WebApplication.CreateBuilder(args);

// Kết nối database QuanLyDoAn đã tạo trong Giai đoạn 2.
var connectionString = builder.Configuration.GetConnectionString("QuanLyDoAn");
if (string.IsNullOrWhiteSpace(connectionString))
{
    throw new InvalidOperationException(
        "Chưa cấu hình ConnectionStrings:QuanLyDoAn trong appsettings.Development.json hoặc User Secrets.");
}

builder.Services.AddDbContext<QuanLyDoAnContext>(options =>
    options.UseSqlServer(connectionString));

// Flutter Web/Swagger chạy khác origin có thể gọi API trong môi trường thực hành.
// Không mở CORS rộng trong cấu hình Production.
if (builder.Environment.IsDevelopment())
{
    builder.Services.AddCors(options =>
        options.AddDefaultPolicy(policy =>
            policy.AllowAnyOrigin()
                .AllowAnyHeader()
                .AllowAnyMethod()));
}

// Tên thuộc tính trong JSON dùng camelCase để Flutter dễ xử lý.
builder.Services.AddControllers().AddJsonOptions(options =>
    options.JsonSerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddProblemDetails();

var app = builder.Build();

// Lỗi được trả về dạng ProblemDetails, không lộ chi tiết SQL trong response.
app.UseExceptionHandler();

if (app.Environment.IsDevelopment())
{
    app.UseCors();
    app.UseSwagger();
    app.UseSwaggerUI();
}
else
{
    app.UseHttpsRedirection();
}

app.MapControllers();
app.Run();

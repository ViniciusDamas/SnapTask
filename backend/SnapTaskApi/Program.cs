using Microsoft.EntityFrameworkCore;
using SnapTaskApi.Application.Interfaces;
using SnapTaskApi.Application.Services;
using SnapTaskApi.Infrastructure.Persistence;
using SnapTaskApi.Infrastructure.Repositories;

var builder = WebApplication.CreateBuilder(args);

// Controllers
builder.Services.AddControllers();

// DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"))
);

// Repositories
builder.Services.AddScoped<IBoardRepository, BoardRepository>();

// Services
builder.Services.AddScoped<IBoardService, BoardService>();

var app = builder.Build();

// Middleware pipeline
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();

app.Run();

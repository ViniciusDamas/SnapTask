using Microsoft.EntityFrameworkCore;
using SnapTaskApi.Application.UseCases.Cards;
using SnapTaskApi.Infrastructure.Persistence;
using SnapTaskApi.Infrastructure.Repositories;
using SnapTaskApi.Application.UseCases.Boards;
using SnapTaskApi.Application.UseCases.Columns;
using SnapTaskApi.Application.Abstractions.Repositories;

var builder = WebApplication.CreateBuilder(args);

// Controllers
builder.Services.AddControllers();

// DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"))
);

// Repositories
builder.Services.AddScoped<IBoardRepository, BoardRepository>();
builder.Services.AddScoped<IColumnRepository, ColumnRepository>();
builder.Services.AddScoped<ICardRepository, CardRepository>();

// UseCases

    // Boards
    builder.Services.AddScoped<CreateBoard>();
    builder.Services.AddScoped<UpdateBoard>();
    builder.Services.AddScoped<DeleteBoard>();
    builder.Services.AddScoped<GetAllBoards>();
    builder.Services.AddScoped<GetBoardById>();

    // Columns
    builder.Services.AddScoped<MoveColumn>();
    builder.Services.AddScoped<CreateColumn>();
    builder.Services.AddScoped<UpdateColumn>();
    builder.Services.AddScoped<DeleteColumn>();
    builder.Services.AddScoped<GetColumnById>();

    // Cards
    builder.Services.AddScoped<CreateCard>();

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

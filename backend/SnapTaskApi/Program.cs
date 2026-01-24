using System.Text;
using SnapTaskApi.WebApi.Security;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using SnapTaskApi.Application.Abstractions.CurrentUser;
using SnapTaskApi.Application.Abstractions.Repositories;
using SnapTaskApi.Application.UseCases.Boards;
using SnapTaskApi.Application.UseCases.Cards;
using SnapTaskApi.Application.UseCases.Columns;
using SnapTaskApi.Infrastructure.Identity;
using SnapTaskApi.Infrastructure.Persistence;
using SnapTaskApi.Infrastructure.Repositories;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Identity
builder.Services
    .AddIdentityCore<ApplicationUser>(options =>
    {
        options.Password.RequiredLength = 8;
        options.Lockout.MaxFailedAccessAttempts = 5;
        options.User.RequireUniqueEmail = true;
    })
    .AddRoles<IdentityRole<Guid>>()
    .AddEntityFrameworkStores<AppDbContext>()
    .AddDefaultTokenProviders();

// JWT Auth
var jwtKey = builder.Configuration["Jwt:Key"]!;
var jwtIssuer = builder.Configuration["Jwt:Issuer"]!;
var jwtAudience = builder.Configuration["Jwt:Audience"]!;

builder.Services
    .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = jwtIssuer,

            ValidateAudience = true,
            ValidAudience = jwtAudience,

            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey)),

            ValidateLifetime = true,
            ClockSkew = TimeSpan.FromMinutes(2)
        };
    });

builder.Services.AddScoped<JwtTokenService>();

builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<ICurrentUser, CurrentUser>();

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
    builder.Services.AddScoped<GetCardById>();
    builder.Services.AddScoped<UpdateCard>();
    builder.Services.AddScoped<DeleteCard>();

var app = builder.Build();

// Middleware pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
app.Run();

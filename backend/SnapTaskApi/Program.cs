using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using SnapTaskApi.Application.Abstractions.CurrentUser;
using SnapTaskApi.Application.Abstractions.Repositories;
using SnapTaskApi.Application.UseCases.Boards;
using SnapTaskApi.Application.UseCases.Cards;
using SnapTaskApi.Application.UseCases.Columns;
using SnapTaskApi.Infrastructure.Identity;
using SnapTaskApi.Infrastructure.Persistence;
using SnapTaskApi.Infrastructure.Repositories;
using SnapTaskApi.WebApi.Security;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// ---------------------------
// ProblemDetails (RFC 7807)
// ---------------------------
builder.Services.AddProblemDetails(options =>
{
    // Adiciona traceId em todas as respostas de erro (útil p/ correlacionar logs)
    options.CustomizeProblemDetails = ctx =>
    {
        ctx.ProblemDetails.Extensions["traceId"] = ctx.HttpContext.TraceIdentifier;
    };
});

// Padroniza 400 de validação (ModelState) como ValidationProblemDetails
builder.Services.Configure<ApiBehaviorOptions>(options =>
{
    options.InvalidModelStateResponseFactory = context =>
    {
        var problem = new ValidationProblemDetails(context.ModelState)
        {
            Title = "Erro de validação",
            Status = StatusCodes.Status400BadRequest,
            Type = "https://httpstatuses.com/400",
            Instance = context.HttpContext.Request.Path
        };

        problem.Extensions["traceId"] = context.HttpContext.TraceIdentifier;

        return new BadRequestObjectResult(problem)
        {
            ContentTypes = { "application/problem+json" }
        };
    };
});

// ---------------------------
// Identity
// ---------------------------
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

// ---------------------------
// Test Config Defaults
// ---------------------------
if (builder.Environment.IsEnvironment("Testing"))
{
    builder.Configuration.AddInMemoryCollection(new Dictionary<string, string?>
    {
        ["Jwt:Key"] = "TEST_JWT_KEY_12345678901234567890",
        ["Jwt:Issuer"] = "SnapTask.Test",
        ["Jwt:Audience"] = "SnapTask.Test"
    });
}
// ---------------------------
// JWT Auth
// ---------------------------
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

        // Padroniza respostas 401/403 em ProblemDetails
        options.Events = new JwtBearerEvents
        {
            OnChallenge = async context =>
            {
                // Impede a resposta padrão do framework
                context.HandleResponse();

                var problem = new ProblemDetails
                {
                    Title = "Não autenticado",
                    Status = StatusCodes.Status401Unauthorized,
                    Detail = "Token ausente, inválido ou expirado.",
                    Type = "https://httpstatuses.com/401",
                    Instance = context.Request.Path
                };

                problem.Extensions["traceId"] = context.HttpContext.TraceIdentifier;

                context.Response.StatusCode = problem.Status.Value;
                context.Response.ContentType = "application/problem+json";
                await context.Response.WriteAsJsonAsync(problem);
            },
            OnForbidden = async context =>
            {
                var problem = new ProblemDetails
                {
                    Title = "Acesso negado",
                    Status = StatusCodes.Status403Forbidden,
                    Detail = "Você não tem permissão para acessar este recurso.",
                    Type = "https://httpstatuses.com/403",
                    Instance = context.Request.Path
                };

                problem.Extensions["traceId"] = context.HttpContext.TraceIdentifier;

                context.Response.StatusCode = problem.Status.Value;
                context.Response.ContentType = "application/problem+json";
                await context.Response.WriteAsJsonAsync(problem);
            }
        };
    });

builder.Services.AddScoped<JwtTokenService>();

builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<ICurrentUser, CurrentUser>();

// ---------------------------
// Controllers
// ---------------------------
builder.Services.AddControllers();

// ---------------------------
// DbContext
// ---------------------------
if (builder.Environment.IsEnvironment("Testing"))
{
    builder.Services.AddDbContext<AppDbContext>(options =>
        options.UseInMemoryDatabase("SnapTask_TestDb"));
}
else
{
    builder.Services.AddDbContext<AppDbContext>(options =>
        options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));
}
// ---------------------------
// Repositories
// ---------------------------
builder.Services.AddScoped<IBoardRepository, BoardRepository>();
builder.Services.AddScoped<IColumnRepository, ColumnRepository>();
builder.Services.AddScoped<ICardRepository, CardRepository>();

// ---------------------------
// UseCases
// ---------------------------

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

// ---------------------------
// Global Exception Handler -> 500 ProblemDetails
// ---------------------------
app.UseExceptionHandler(errorApp =>
{
    errorApp.Run(async context =>
    {
        var feature = context.Features.Get<IExceptionHandlerFeature>();
        var ex = feature?.Error;

        // Recomendado: logar aqui com ILogger<Program>
        // var logger = context.RequestServices.GetRequiredService<ILogger<Program>>();
        // logger.LogError(ex, "Unhandled exception");

        var problem = new ProblemDetails
        {
            Title = "Erro interno",
            Status = StatusCodes.Status500InternalServerError,
            Detail = app.Environment.IsDevelopment()
                ? ex?.Message
                : "Ocorreu um erro inesperado.",
            Type = "https://httpstatuses.com/500",
            Instance = context.Request.Path
        };

        problem.Extensions["traceId"] = context.TraceIdentifier;

        context.Response.StatusCode = problem.Status.Value;
        context.Response.ContentType = "application/problem+json";
        await context.Response.WriteAsJsonAsync(problem);
    });
});

// ---------------------------
// Middleware pipeline
// ---------------------------
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



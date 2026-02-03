namespace SnapTaskApi.Infrastructure.Persistence;

using SnapTaskApi.Domain.Entities.Cards;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using SnapTaskApi.Infrastructure.Identity;
using Microsoft.AspNetCore.Identity;
using SnapTaskApi.Domain.Entities.Columns;
using SnapTaskApi.Domain.Entities.Boards;

public class AppDbContext : IdentityDbContext<ApplicationUser, IdentityRole<Guid>, Guid>
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<Board> Boards => Set<Board>();
    public DbSet<Column> Columns => Set<Column>();
    public DbSet<Card> Cards => Set<Card>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Board>(entity =>
        {
            entity.ToTable("boards");

            entity.HasKey(x => x.Id);

            entity.Property(x => x.Name)
                  .HasMaxLength(120)
                  .IsRequired();

            entity.Property(x => x.CreatedAt)
                  .IsRequired();
           
            entity.Property(x => x.OwnerUserId)
                  .IsRequired();


            entity.HasMany(x => x.Columns)
                  .WithOne(x => x.Board)
                  .HasForeignKey(x => x.BoardId)
                  .OnDelete(DeleteBehavior.Cascade);

            entity.HasIndex(x => x.OwnerUserId);
            entity.HasIndex(x => x.Name);
            entity.HasIndex(x => new { x.OwnerUserId, x.Name });

        });

        modelBuilder.Entity<Column>(entity =>
        {
            entity.ToTable("columns");

            entity.HasKey(x => x.Id);

            entity.Property(x => x.Name)
                  .HasMaxLength(120)
                  .IsRequired();

            entity.Property(x => x.Order)
                  .IsRequired();

            entity.Property(x => x.BoardId)
                  .IsRequired();

            // Column 1-N Cards
            entity.HasMany(x => x.Cards)
                  .WithOne(x => x.Column)
                  .HasForeignKey(x => x.ColumnId)
                  .OnDelete(DeleteBehavior.Cascade);

            entity.HasIndex(x => new { x.BoardId, x.Order })
                  .IsUnique();
        });

        modelBuilder.Entity<Card>(entity =>
        {
            entity.ToTable("cards");

            entity.HasKey(x => x.Id);

            entity.Property(x => x.Title)
                  .HasMaxLength(160)
                  .IsRequired();

            entity.Property(x => x.Status)
                   .HasConversion<string>()
                   .IsRequired();

            entity.Property(x => x.Description)
                  .HasMaxLength(2000);

            entity.Property(x => x.Order)
                  .IsRequired();

            entity.Property(x => x.ColumnId)
                  .IsRequired();

            entity.HasIndex(x => new { x.ColumnId, x.Order })
                  .IsUnique();
        });
    }
}

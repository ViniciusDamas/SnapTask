namespace SnapTaskApi.Domain.Entities;

public class Card
{
    public Guid Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int Order {  get; set; }

    public Guid ColumnId { get; set; }
}
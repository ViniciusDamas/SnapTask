namespace SnapTaskApi.Dtos;

public class ColumnCreateDto
{
    public string Name { get; set; } = string.Empty;
    public Guid BoardId { get; set; }
}
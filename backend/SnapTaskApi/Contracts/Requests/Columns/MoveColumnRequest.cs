namespace SnapTaskApi.Contracts.Requests.Columns;

public record MoveColumnRequest
(
    int ColumnId,
    int BoardId,
    int? PrevColumnId, 
    int? NextColumnId 
);

public record MoveColumnResult(int Id, int BoardId, int Order);
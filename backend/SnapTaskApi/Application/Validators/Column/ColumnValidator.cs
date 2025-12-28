using SnapTaskApi.Contracts.Requests.Columns;
using System.ComponentModel.DataAnnotations;

namespace SnapTaskApi.Application.Validators.Column;
public class ColumnValidator
{
    public void Validate(CreateColumnRequest request)
    {
        if (request.BoardId == Guid.Empty)
            throw new ValidationException("BoardId cannot be empty.");

        if (request is null || string.IsNullOrWhiteSpace(request.Name))
            throw new ValidationException("Request cannot be null.");
    }

    public void Validate(Guid id, UpdateColumnRequest request)
    {
        if (id == Guid.Empty)
            throw new ValidationException("Id cannot be empty.");

        if (request is null || string.IsNullOrWhiteSpace(request.Name))
            throw new ValidationException("Request cannot be null.");
    }
}

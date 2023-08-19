CREATE   FUNCTION [sqids].[IsBlockedId] (
	@Id NVARCHAR(MAX)
)
RETURNS BIT
BEGIN
	IF EXISTS(SELECT 1 FROM [sqids].[BlockList] WHERE @Id LIKE '%' + Word + '%') RETURN 1
	RETURN 0
END
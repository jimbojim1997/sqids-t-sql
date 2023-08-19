CREATE   FUNCTION [sqids].[GetCharacters]
(
	@String VARCHAR(MAX)
)
RETURNS @ReturnTable TABLE
(
	[I] INT,
	[C] NCHAR(1)
)
AS
BEGIN
	
	DECLARE @i INT = 1,
			@length INT = LEN(@String)

	WHILE (@i <= @length)
	BEGIN
		INSERT INTO @ReturnTable (I, C)
		VALUES (@i - 1, SUBSTRING(@String, @i, 1))
		SET @i = @i + 1
	END

	RETURN
END

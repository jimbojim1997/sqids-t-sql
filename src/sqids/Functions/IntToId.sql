CREATE   FUNCTION [sqids].[IntToId] (
	@Value INT,
	@Alphabet IntCharTable READONLY
)
RETURNS NVARCHAR(MAX)
BEGIN
	DECLARE @id NVARCHAR(MAX) = '',
			@length INT = (SELECT COUNT(*) FROM @Alphabet),
			@c NCHAR(1),
			@r INT = @Value

	-- TSQL doesn't have do while so manually duiplicate first iteration

	SELECT @c = C FROM @Alphabet WHERE I = @r % @length
	SET @id = @c + @id
	SET @r = FLOOR(@r / @length)

	WHILE (@r > 0)
	BEGIN
		SELECT @c = C FROM @Alphabet WHERE I = @r % @length
		SET @id = @c + @id
		SET @r = FLOOR(@r / @length)
	END

	RETURN @id
END
CREATE   FUNCTION [sqids].[IdToInt] (
	@Id NVARCHAR(MAX),
	@Alphabet IntCharTable READONLY
)
RETURNS INT
BEGIN
	DECLARE @a INT = 0,
			@length INT = LEN(@Id),
			@alhabetLength INT = (SELECT MAX(I) FROM @Alphabet) + 1,
			@i INT = 0,
			@c NCHAR(1),
			@indexOfChar INT
	
	DECLARE @characters [sqids].IntCharTable
	INSERT INTO @characters (I, C)
	SELECT I, C FROM [sqids].[GetCharacters](@Id)

	WHILE (@i < @length)
	BEGIN
		SELECT @c = C FROM @characters WHERE I = @i
		SELECT @indexOfChar = I FROM @Alphabet WHERE C = @c

		SET @a = @a * @alhabetLength + @indexOfChar

		SET @i = @i + 1
	END

	RETURN @a
END
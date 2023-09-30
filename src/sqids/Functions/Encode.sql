-- Encode a single number into a Squid ID.
-- Specification: https://github.com/sqids/sqids-spec/blob/main/src/index.ts

-- Note: RAISERROR cannot be used within a user-define function so a hack is used to return a meaningful error to the user.

CREATE FUNCTION [sqids].[Encode]
(
	@Number INT,
	@Alphabet NVARCHAR(MAX) = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
	@MinLength INT = 0
)
RETURNS VARCHAR(MAX)
BEGIN
	DECLARE @IntMaxValue INT = 2147483647

	-- Options validation from specification constructor method.
	IF LEN(@Alphabet) < 3 RETURN CAST('Alphabet length must be at least 3.' AS INT)

	DECLARE @alphabetCharacters AS IntCharTable
	INSERT INTO @alphabetCharacters (I, C)
	SELECT I, C FROM [sqids].[GetCharacters](@Alphabet)

	IF LEN(@Alphabet) <> (SELECT COUNT(*) FROM [sqids].[GetDistinctCharacters](@alphabetCharacters)) RETURN CAST('Alphabet must contain unique characters.' AS INT)

	IF @MinLength < 0 OR @MinLength > 255 RETURN CAST('Minimum length must be greater than or equal to 0 and less than or equal to 255.' AS INT)

	DECLARE @shuffledAlphabet AS IntCharTable
	INSERT INTO @shuffledAlphabet (I, C)
	SELECT I, C FROM [sqids].[ShuffleCharacters](@alphabetCharacters)

	--End of specification constructor

	IF @Number < 0 OR @Number > @IntMaxValue RETURN CAST('Encoding supports numbers between 0 and ' + CAST(@IntMaxValue AS VARCHAR(MAX)) + '.' AS INT)

	DECLARE @Numbers AS IntIntTable
	INSERT INTO @Numbers VALUES (0, @Number)

	DECLARE @Id NVARCHAR(MAX)
	EXEC @Id = [sqids].[EncodeInternal] @Numbers = @Numbers, @Increment = 0, @Alphabet = @shuffledAlphabet, @MinLength = @MinLength

	RETURN @Id
END

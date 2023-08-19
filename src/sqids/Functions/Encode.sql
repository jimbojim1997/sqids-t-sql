-- Encode a single number into a Squid ID.
-- Specification: https://github.com/sqids/sqids-spec/blob/main/src/index.ts

-- Note: RAISERROR cannot be used within a user-define function so a hack is used to return a meaningful error to the user.

CREATE   FUNCTION [sqids].[Encode]
(
	@Number INT,
	@Alphabet NVARCHAR(MAX) = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
	@MinLength INT = 0
)
RETURNS VARCHAR(MAX)
BEGIN
	DECLARE @IntMaxValue INT = 2147483647

	-- Options validation from specification conststructor method.
	IF LEN(@Alphabet) < 5 RETURN CAST('Alphabet length must be at least 5.' AS INT)

	DECLARE @alphabetCharacters AS IntCharTable
	INSERT INTO @alphabetCharacters (I, C)
	SELECT I, C FROM [sqids].[GetCharacters](@Alphabet)

	IF LEN(@Alphabet) <> (SELECT COUNT(*) FROM [sqids].[GetDistinctCharacters](@alphabetCharacters)) RETURN CAST('Alphabet must contain unique characters.' AS INT)

	IF @MinLength < 0 OR @MinLength > @IntMaxValue RETURN CAST('Minimum length must be greater than or equal to 0 and less than or equal to ' +  @IntMaxValue + '.' AS INT)

	DECLARE @shuffledAlphabet AS IntCharTable
	INSERT INTO @shuffledAlphabet (I, C)
	SELECT I, C FROM [sqids].[ShuffleCharacters](@alphabetCharacters)

	RETURN '<success>'
END

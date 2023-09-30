CREATE FUNCTION [sqids].[EncodeInternal]
(
	@Numbers AS IntIntTable READONLY,
	@Increment AS INT,
	@Alphabet AS IntCharTable READONLY,
	@MinLength AS INT
)
RETURNS VARCHAR(MAX)
BEGIN
	DECLARE @numbersLength INT = (SELECT COUNT(*) FROM @Numbers),
			@alphabetLength INT = (SELECT COUNT(*) FROM @Alphabet)

	-- if increment is greater than alphabet length, we've reached max attempts
	IF @Increment > @alphabetLength RETURN CAST ('Reached max attempts to re-generate the ID' AS INT)

	-- get a semi-random offset from input numbers
	DECLARE @offset INT = @numbersLength,
			@i INT = 0
	WHILE @i < @numbersLength
	BEGIN
		DECLARE @number INT = (SELECT TOP 1 N FROM @Numbers WHERE I = @i)
		DECLARE @alphabetIndex INT = @number % @alphabetLength
		DECLARE @char NCHAR(1) = (SELECT TOP 1 C FROM @Alphabet WHERE I = @alphabetIndex)

		SET @offset = UNICODE(@char) + @i + @offset 
		SET @i = @i + 1
	END
	SET @offset = @offset % @alphabetLength


	-- if there is a non-zero `increment`, it's an internal attempt to re-generated the ID
	SET @offset = (@offset + @Increment) % @alphabetLength

	-- re-arrange alphabet so that second-half goes in front of the first-half
	DECLARE @rearrangedAlphabet IntCharTable
	INSERT INTO @rearrangedAlphabet (I, C)
	SELECT CASE WHEN I < @offset THEN I + @alphabetLength - @offset ELSE I - @offset END, C
	FROM @Alphabet

	-- `prefix` is the first character in the generated ID, used for randomization
	DECLARE @prefix NCHAR(1) = (SELECT TOP 1 C FROM @rearrangedAlphabet WHERE I = 0)

	-- reverse alphabet (otherwise for [0, x] `offset` and `separator` will be the same char)
	DECLARE @reversedAlphabet IntCharTable
	INSERT INTO @reversedAlphabet (I, C)
	SELECT @alphabetLength - I - 1, C
	FROM @rearrangedAlphabet

	-- final ID will always have the `prefix` character at the beginning
	DECLARE @ret NVARCHAR(MAX) = @prefix

	-- encode input array
	DECLARE @workingAlphabet IntCharTable
	INSERT INTO @workingAlphabet (I, C) SELECT I, C FROM @reversedAlphabet
	DECLARE @alphabetWithoutSeparator IntCharTable
	SET @i = 0
	WHILE @i < @numbersLength
	BEGIN
		DECLARE @num INT = (SELECT N FROM @Numbers WHERE I = @i)
		
		-- the first character of the alphabet is going to be reserved for the `separator`
		DELETE FROM @alphabetWithoutSeparator
		INSERT INTO @alphabetWithoutSeparator (I, C)
		SELECT I - 1, C
		FROM @workingAlphabet
		WHERE I > 0

		DECLARE @id NVARCHAR(MAX)
		EXEC @id = [sqids].[IntToId] @num, @alphabetWithoutSeparator
		SET @ret = @ret + @id

		IF @i < @numbersLength - 1
		BEGIN
			DECLARE @separator NCHAR(1) = (SELECT TOP 1 C FROM @workingAlphabet WHERE I = 0)
			SET @ret = @ret + @separator

			UPDATE @workingAlphabet
			SET I = sh.I
			FROM @workingAlphabet wa
			JOIN [sqids].[ShuffleCharacters](@workingAlphabet) sh ON sh.C = wa.C COLLATE Latin1_General_100_BIN2_UTF8
		END

		SET @i = @i + 1
	END

	-- handle `minLength` requirement, if the ID is too short
	--TODO
	IF @MinLength > LEN(@ret)
	BEGIN
		SET @ret = @ret + (SELECT TOP 1 C FROM @workingAlphabet WHERE I = 0)

		WHILE @MinLength - LEN(@ret) > 0
		BEGIN

			UPDATE @workingAlphabet
			SET I = sh.I
			FROM @workingAlphabet wa
			JOIN [sqids].[ShuffleCharacters](@workingAlphabet) sh ON sh.C = wa.C COLLATE Latin1_General_100_BIN2_UTF8

			;WITH slice (C) AS (
				SELECT TOP (LEAST(@MinLength - LEN(@ret), @alphabetLength)) C
				FROM @workingAlphabet
				ORDER BY I
			)
			SELECT @ret = @ret + STRING_AGG(C, '') FROM slice
		END
	END

	-- if ID has a blocked word anywhere, restart with a +1 increment
	DECLARE @isBlockedId BIT
	EXEC @isBlockedId = [sqids].[IsBlockedId] @Id = @ret
	IF @isBlockedId = 1
	BEGIN
		DECLARE @nextIncrement INT = @Increment + 1
		EXEC @ret = [sqids].[EncodeInternal] @Numbers = @Numbers, @Increment = @nextIncrement, @Alphabet = @Alphabet, @MinLength = @MinLength
	END

	RETURN @ret
END
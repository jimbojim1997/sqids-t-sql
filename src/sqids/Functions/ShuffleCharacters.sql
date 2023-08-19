CREATE   FUNCTION [sqids].[ShuffleCharacters] (
	@Characters [sqids].[IntCharTable] READONLY
)
RETURNS @ReturnTable TABLE
(
	[I] INT,
	[C] NCHAR(1)
)
AS
BEGIN
	DECLARE @length INT = (SELECT COUNT(*) FROM @Characters)
	DECLARE @i INT = 0
	DECLARE @j INT = @length - 1
	DECLARE @r INT, @charI CHAR, @charJ CHAR

	DECLARE @shuffleTable [sqids].[IntCharTable]
	INSERT INTO @shuffleTable (I, C)
	SELECT I, C FROM @Characters


	WHILE (@j > 0)
	BEGIN
		SELECT @charI = C FROM @shuffleTable WHERE I = @i
		SELECT @charJ = C FROM @shuffleTable WHERE I = @j
		SET @r = (@i * @j + UNICODE(@charI) + UNICODE(@charJ)) % @length

		UPDATE @shuffleTable SET I = @i WHERE I = @r
		UPDATE @shuffleTable SET I = @r WHERE C = @charI COLLATE Latin1_General_100_BIN2_UTF8

		SET @i = @i + 1
		SET @j = @j - 1
	END

	INSERT INTO @ReturnTable
	SELECT I, C FROM @shuffleTable
	ORDER BY I ASC

	RETURN
END
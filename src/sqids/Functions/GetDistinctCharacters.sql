CREATE FUNCTION [sqids].[GetDistinctCharacters]
(
	@Characters [sqids].[IntCharTable] READONLY
)
RETURNS TABLE AS RETURN
(
	SELECT DISTINCT C COLLATE Latin1_General_100_BIN2_UTF8 AS C
	FROM @Characters
)

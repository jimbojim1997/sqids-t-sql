-- Unit test for [sqids].[ShuffleCharacters].
-- A unit test passes when the relevant column in the output dataset is 1.

DECLARE @alphabetCharacters AS [sqids].[IntCharTable]
DECLARE @expectedCharacters AS [sqids].[IntCharTable]
DECLARE @shuffledAlphabet AS [sqids].[IntCharTable]
DECLARE @joinedAlphabets TABLE (I INT, SC CHAR(1), EC CHAR(1), [Match] BIT)

-- Test1: default shuffle, checking for randomness.
DELETE FROM @alphabetCharacters
INSERT INTO @alphabetCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')

DELETE FROM @expectedCharacters
INSERT INTO @expectedCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('fwjBhEY2uczNPDiloxmvISCrytaJO4d71T0W3qnMZbXVHg6eR8sAQ5KkpLUGF9')

DELETE FROM @shuffledAlphabet
INSERT INTO @shuffledAlphabet (I, C) SELECT I, C FROM [sqids].[ShuffleCharacters](@alphabetCharacters)

DELETE FROM @joinedAlphabets
INSERT INTO @joinedAlphabets SELECT sa.I, sa.C, ec.C, CASE WHEN sa.C = ec.C THEN 1 ELSE 0 END FROM @shuffledAlphabet sa JOIN @expectedCharacters ec ON ec.I = sa.I ORDER BY sa.I
DECLARE @test1Pass BIT = CASE WHEN (SELECT COUNT(*) FROM @alphabetCharacters) = (SELECT COUNT(*) FROM @joinedAlphabets WHERE [Match] = 1) THEN 1 ELSE 0 END

-- Test2: numbers in the front, another check for randomness.
DELETE FROM @alphabetCharacters
INSERT INTO @alphabetCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')

DELETE FROM @expectedCharacters
INSERT INTO @expectedCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('ec38UaynYXvoxSK7RV9uZ1D2HEPw6isrdzAmBNGT5OCJLk0jlFbtqWQ4hIpMgf')

DELETE FROM @shuffledAlphabet
INSERT INTO @shuffledAlphabet (I, C) SELECT I, C FROM [sqids].[ShuffleCharacters](@alphabetCharacters)

DELETE FROM @joinedAlphabets
INSERT INTO @joinedAlphabets SELECT sa.I, sa.C, ec.C, CASE WHEN sa.C = ec.C THEN 1 ELSE 0 END FROM @shuffledAlphabet sa JOIN @expectedCharacters ec ON ec.I = sa.I ORDER BY sa.I
DECLARE @test2Pass BIT = CASE WHEN (SELECT COUNT(*) FROM @alphabetCharacters) = (SELECT COUNT(*) FROM @joinedAlphabets WHERE [Match] = 1) THEN 1 ELSE 0 END

-- Test3a: swapping front 2 characters.
DELETE FROM @alphabetCharacters
INSERT INTO @alphabetCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')

DELETE FROM @expectedCharacters
INSERT INTO @expectedCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('ec38UaynYXvoxSK7RV9uZ1D2HEPw6isrdzAmBNGT5OCJLk0jlFbtqWQ4hIpMgf')

DELETE FROM @shuffledAlphabet
INSERT INTO @shuffledAlphabet (I, C) SELECT I, C FROM [sqids].[ShuffleCharacters](@alphabetCharacters)

DELETE FROM @joinedAlphabets
INSERT INTO @joinedAlphabets SELECT sa.I, sa.C, ec.C, CASE WHEN sa.C = ec.C THEN 1 ELSE 0 END FROM @shuffledAlphabet sa JOIN @expectedCharacters ec ON ec.I = sa.I ORDER BY sa.I
DECLARE @test3aPass BIT = CASE WHEN (SELECT COUNT(*) FROM @alphabetCharacters) = (SELECT COUNT(*) FROM @joinedAlphabets WHERE [Match] = 1) THEN 1 ELSE 0 END

-- Test3b: swapping front 2 characters.
DELETE FROM @alphabetCharacters
INSERT INTO @alphabetCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('1023456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')

DELETE FROM @expectedCharacters
INSERT INTO @expectedCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('xI3RUayk1MSolQK7e09zYmFpVXPwHiNrdfBJ6ZAT5uCWbntgcDsEqjv4hLG28O')

DELETE FROM @shuffledAlphabet
INSERT INTO @shuffledAlphabet (I, C) SELECT I, C FROM [sqids].[ShuffleCharacters](@alphabetCharacters)

DELETE FROM @joinedAlphabets
INSERT INTO @joinedAlphabets SELECT sa.I, sa.C, ec.C, CASE WHEN sa.C = ec.C THEN 1 ELSE 0 END FROM @shuffledAlphabet sa JOIN @expectedCharacters ec ON ec.I = sa.I ORDER BY sa.I
DECLARE @test3bPass BIT = CASE WHEN (SELECT COUNT(*) FROM @alphabetCharacters) = (SELECT COUNT(*) FROM @joinedAlphabets WHERE [Match] = 1) THEN 1 ELSE 0 END

-- Test4a: swapping last 2 characters.
DELETE FROM @alphabetCharacters
INSERT INTO @alphabetCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')

DELETE FROM @expectedCharacters
INSERT INTO @expectedCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('ec38UaynYXvoxSK7RV9uZ1D2HEPw6isrdzAmBNGT5OCJLk0jlFbtqWQ4hIpMgf')

DELETE FROM @shuffledAlphabet
INSERT INTO @shuffledAlphabet (I, C) SELECT I, C FROM [sqids].[ShuffleCharacters](@alphabetCharacters)

DELETE FROM @joinedAlphabets
INSERT INTO @joinedAlphabets SELECT sa.I, sa.C, ec.C, CASE WHEN sa.C = ec.C THEN 1 ELSE 0 END FROM @shuffledAlphabet sa JOIN @expectedCharacters ec ON ec.I = sa.I ORDER BY sa.I
DECLARE @test4aPass BIT = CASE WHEN (SELECT COUNT(*) FROM @alphabetCharacters) = (SELECT COUNT(*) FROM @joinedAlphabets WHERE [Match] = 1) THEN 1 ELSE 0 END

-- Test4b: swapping last 2 characters.
DELETE FROM @alphabetCharacters
INSERT INTO @alphabetCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY')

DELETE FROM @expectedCharacters
INSERT INTO @expectedCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('x038UaykZMSolIK7RzcbYmFpgXEPHiNr1d2VfGAT5uJWQetjvDswqn94hLC6BO')

DELETE FROM @shuffledAlphabet
INSERT INTO @shuffledAlphabet (I, C) SELECT I, C FROM [sqids].[ShuffleCharacters](@alphabetCharacters)

DELETE FROM @joinedAlphabets
INSERT INTO @joinedAlphabets SELECT sa.I, sa.C, ec.C, CASE WHEN sa.C = ec.C THEN 1 ELSE 0 END FROM @shuffledAlphabet sa JOIN @expectedCharacters ec ON ec.I = sa.I ORDER BY sa.I
DECLARE @test4bPass BIT = CASE WHEN (SELECT COUNT(*) FROM @alphabetCharacters) = (SELECT COUNT(*) FROM @joinedAlphabets WHERE [Match] = 1) THEN 1 ELSE 0 END

-- Test5: short alphabet.
DELETE FROM @alphabetCharacters
INSERT INTO @alphabetCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('0123456789')

DELETE FROM @expectedCharacters
INSERT INTO @expectedCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('4086517392')

DELETE FROM @shuffledAlphabet
INSERT INTO @shuffledAlphabet (I, C) SELECT I, C FROM [sqids].[ShuffleCharacters](@alphabetCharacters)

DELETE FROM @joinedAlphabets
INSERT INTO @joinedAlphabets SELECT sa.I, sa.C, ec.C, CASE WHEN sa.C = ec.C THEN 1 ELSE 0 END FROM @shuffledAlphabet sa JOIN @expectedCharacters ec ON ec.I = sa.I ORDER BY sa.I
DECLARE @test5Pass BIT = CASE WHEN (SELECT COUNT(*) FROM @alphabetCharacters) = (SELECT COUNT(*) FROM @joinedAlphabets WHERE [Match] = 1) THEN 1 ELSE 0 END

-- Test6: really short alphabet.
DELETE FROM @alphabetCharacters
INSERT INTO @alphabetCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('12345')

DELETE FROM @expectedCharacters
INSERT INTO @expectedCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('24135')

DELETE FROM @shuffledAlphabet
INSERT INTO @shuffledAlphabet (I, C) SELECT I, C FROM [sqids].[ShuffleCharacters](@alphabetCharacters)

DELETE FROM @joinedAlphabets
INSERT INTO @joinedAlphabets SELECT sa.I, sa.C, ec.C, CASE WHEN sa.C = ec.C THEN 1 ELSE 0 END FROM @shuffledAlphabet sa JOIN @expectedCharacters ec ON ec.I = sa.I ORDER BY sa.I
DECLARE @test6Pass BIT = CASE WHEN (SELECT COUNT(*) FROM @alphabetCharacters) = (SELECT COUNT(*) FROM @joinedAlphabets WHERE [Match] = 1) THEN 1 ELSE 0 END

-- Test7: lowercase alphabet.
DELETE FROM @alphabetCharacters
INSERT INTO @alphabetCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('abcdefghijklmnopqrstuvwxyz')

DELETE FROM @expectedCharacters
INSERT INTO @expectedCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('lbfziqvscptmyxrekguohwjand')

DELETE FROM @shuffledAlphabet
INSERT INTO @shuffledAlphabet (I, C) SELECT I, C FROM [sqids].[ShuffleCharacters](@alphabetCharacters)

DELETE FROM @joinedAlphabets
INSERT INTO @joinedAlphabets SELECT sa.I, sa.C, ec.C, CASE WHEN sa.C = ec.C THEN 1 ELSE 0 END FROM @shuffledAlphabet sa JOIN @expectedCharacters ec ON ec.I = sa.I ORDER BY sa.I
DECLARE @test7Pass BIT = CASE WHEN (SELECT COUNT(*) FROM @alphabetCharacters) = (SELECT COUNT(*) FROM @joinedAlphabets WHERE [Match] = 1) THEN 1 ELSE 0 END

-- Test8: uppercase alphabet.
DELETE FROM @alphabetCharacters
INSERT INTO @alphabetCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('ABCDEFGHIJKLMNOPQRSTUVWXYZ')

DELETE FROM @expectedCharacters
INSERT INTO @expectedCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('ZXBNSIJQEDMCTKOHVWFYUPLRGA')

DELETE FROM @shuffledAlphabet
INSERT INTO @shuffledAlphabet (I, C) SELECT I, C FROM [sqids].[ShuffleCharacters](@alphabetCharacters)

DELETE FROM @joinedAlphabets
INSERT INTO @joinedAlphabets SELECT sa.I, sa.C, ec.C, CASE WHEN sa.C = ec.C THEN 1 ELSE 0 END FROM @shuffledAlphabet sa JOIN @expectedCharacters ec ON ec.I = sa.I ORDER BY sa.I
DECLARE @test8Pass BIT = CASE WHEN (SELECT COUNT(*) FROM @alphabetCharacters) = (SELECT COUNT(*) FROM @joinedAlphabets WHERE [Match] = 1) THEN 1 ELSE 0 END

-- Test9: bars. Bar character codes must be used as the characters are incorrectly parsed.
DELETE FROM @alphabetCharacters
INSERT INTO @alphabetCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters](CHAR(9601) + CHAR(9602) + CHAR(9603) + CHAR(9604) + CHAR(9605) + CHAR(9606) + CHAR(9607) + CHAR(9608))

DELETE FROM @expectedCharacters
INSERT INTO @expectedCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters](CHAR(9602) + CHAR(9607) + CHAR(9604) + CHAR(9605) + CHAR(9606) + CHAR(9603) + CHAR(9601) + CHAR(9608))

DELETE FROM @shuffledAlphabet
INSERT INTO @shuffledAlphabet (I, C) SELECT I, C FROM [sqids].[ShuffleCharacters](@alphabetCharacters)

DELETE FROM @joinedAlphabets
INSERT INTO @joinedAlphabets SELECT sa.I, sa.C, ec.C, CASE WHEN sa.C = ec.C THEN 1 ELSE 0 END FROM @shuffledAlphabet sa JOIN @expectedCharacters ec ON ec.I = sa.I ORDER BY sa.I
DECLARE @test9Pass BIT = CASE WHEN (SELECT COUNT(*) FROM @alphabetCharacters) = (SELECT COUNT(*) FROM @joinedAlphabets WHERE [Match] = 1) THEN 1 ELSE 0 END

-- Test10: bars with numbers. Bar character codes must be used as the characters are incorrectly parsed.
DELETE FROM @alphabetCharacters
INSERT INTO @alphabetCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters](CHAR(9601) + CHAR(9602) + CHAR(9603) + CHAR(9604) + CHAR(9605) + CHAR(9606) + CHAR(9607) + CHAR(9608) +'0123456789')

DELETE FROM @expectedCharacters
INSERT INTO @expectedCharacters (I, C) SELECT I, C FROM [sqids].[GetCharacters]('14' + CHAR(9605) + CHAR(9602) + CHAR(9607) + '320'+ CHAR(9606) + '75'+ CHAR(9604) + CHAR(9608) + '96'+ CHAR(9603) +'8'+ CHAR(9601))

DELETE FROM @shuffledAlphabet
INSERT INTO @shuffledAlphabet (I, C) SELECT I, C FROM [sqids].[ShuffleCharacters](@alphabetCharacters)

DELETE FROM @joinedAlphabets
INSERT INTO @joinedAlphabets SELECT sa.I, sa.C, ec.C, CASE WHEN sa.C = ec.C THEN 1 ELSE 0 END FROM @shuffledAlphabet sa JOIN @expectedCharacters ec ON ec.I = sa.I ORDER BY sa.I
DECLARE @test10Pass BIT = CASE WHEN (SELECT COUNT(*) FROM @alphabetCharacters) = (SELECT COUNT(*) FROM @joinedAlphabets WHERE [Match] = 1) THEN 1 ELSE 0 END

-- Output test results.
SELECT
	@test1Pass Test1Pass,
	@test2Pass Test2Pass,
	@test3aPass Test3aPass,
	@test3bPass Test3bPass,
	@test4aPass Test4aPass,
	@test4bPass Test4bPass,
	@test5Pass Test5Pass,
	@test6Pass Test6Pass,
	@test7Pass Test7Pass,
	@test8Pass Test8Pass,
	@test9Pass Test9Pass,
	@test10Pass Test10Pass

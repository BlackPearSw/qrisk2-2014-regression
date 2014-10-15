-- Copyright 2014 Black Pear Software Ltd.
-- License: GNU GPL3 (see README.md)

--generate text for bash script to generate test outputs for scenarios based on a representative set
--of input values for each variable
--export from SQL Server using:
--  bcp qrisk..TestCase out regression.cases.sh -c -T

USING qrisk;

IF OBJECT_ID('Number') IS NULL
    BEGIN
        CREATE TABLE Number
            (
              N INT CONSTRAINT Number_PK PRIMARY KEY CLUSTERED ( N )
            );

        WITH    L0
                  AS ( SELECT   1 AS C
                       UNION ALL
                       SELECT   1 AS O
                     ),
                L1
                  AS ( SELECT   1 AS C
                       FROM     L0 AS A
                                CROSS JOIN L0 AS B
                     ),
                L2
                  AS ( SELECT   1 AS C
                       FROM     L1 AS A
                                CROSS JOIN L1 AS B
                     ),
                L3
                  AS ( SELECT   1 AS C
                       FROM     L2 AS A
                                CROSS JOIN L2 AS B
                     ),
                L4
                  AS ( SELECT   1 AS C
                       FROM     L3 AS A
                                CROSS JOIN L3 AS B
                     ),
                Nums
                  AS ( SELECT   ROW_NUMBER() OVER ( ORDER BY ( SELECT
                                                              NULL
                                                             ) ) AS N
                       FROM     L4
                     )
            INSERT  INTO Number
                    SELECT TOP 100000
                            N
                    FROM    Nums
                    ORDER BY N

    END

DECLARE @Age TABLE ( value INT )
INSERT  INTO @Age --25 to 84 in increments of 10
        SELECT  N * 10 + 5
        FROM    Number
        WHERE   N > 1
                AND N < 8
        UNION
        SELECT  84

DECLARE @Bool TABLE ( value INT )
INSERT  INTO @Bool
        SELECT  N - 1
        FROM    Number
        WHERE   N < 3

DECLARE @BMI TABLE ( value INT )
INSERT  INTO @BMI
        SELECT  N
        FROM    Number
        WHERE   N >= 20
                AND N <= 40
				AND (N % 5) = 0

DECLARE @Ethrisk TABLE ( value INT )
INSERT  INTO @Ethrisk
        SELECT  N
        FROM    Number
        WHERE   N < 10

DECLARE @Rati TABLE ( value INT )
INSERT  INTO @Rati
        SELECT  N
        FROM    Number
        WHERE   N <= 12
                AND ( ( N % 4 ) = 0
                      OR N = 1
                    )

DECLARE @SBP TABLE ( value INT )
INSERT  INTO @SBP --70-210 in increments of 20
        SELECT  N
        FROM    Number
        WHERE   N >= 70
                AND N <= 210
                AND ( ( N + 10 ) % 20 ) = 0


DECLARE @Smokecat TABLE ( value INT )
INSERT  INTO @Smokecat
        SELECT  N - 1
        FROM    Number
        WHERE   N < 6

DECLARE @Town TABLE ( value INT )
INSERT  INTO @Town
        SELECT  -7
        UNION
        SELECT  0
        UNION
        SELECT  11

IF OBJECT_ID('TestData') IS NOT NULL
    BEGIN
        DROP TABLE TestData;
    END

SELECT --Run for whole cartesian set!
        age.value AS age ,
        b_AF.value AS b_AF ,
        b_ra.value AS b_ra ,
        b_renal.value AS b_renal ,
        b_treatedhyp.value AS b_treatedhyp ,
        b_type1.value AS b_type1 ,
        b_type2.value AS b_type2 ,
        bmi.value AS bmi ,
        ethrisk.value AS ethrisk ,
        fh_cvd.value AS fh_cvd ,
        rati.value AS rati ,
        sbp.value AS sbp ,
        smokecat.value AS smokecat ,
        10 AS surv ,
        town.value AS town
INTO    TestData
FROM    @Age age
        CROSS JOIN @Bool b_AF
        CROSS JOIN @Bool b_ra
        CROSS JOIN @Bool b_renal
        CROSS JOIN @Bool b_treatedhyp
        CROSS JOIN @Bool b_type1
        CROSS JOIN @Bool b_type2
        CROSS JOIN @BMI bmi
        CROSS JOIN @Ethrisk ethrisk
        CROSS JOIN @Bool fh_cvd
        CROSS JOIN @Rati rati
        CROSS JOIN @SBP sbp
        CROSS JOIN @Smokecat smokecat
        CROSS JOIN @Town town;

IF OBJECT_ID('TestCase') IS NOT NULL
    BEGIN
        DROP TABLE TestCase;
    END

;
WITH    args
          AS ( SELECT   CAST(arg.age AS VARCHAR(255)) + ' '
                        + CAST(arg.b_AF AS VARCHAR(255)) + ' '
                        + CAST(arg.b_ra AS VARCHAR(255)) + ' '
                        + CAST(arg.b_renal AS VARCHAR(255)) + ' '
                        + CAST(arg.b_treatedhyp AS VARCHAR(255)) + ' '
                        + CAST(arg.b_type1 AS VARCHAR(255)) + ' '
                        + CAST(arg.b_type2 AS VARCHAR(255)) + ' '
                        + CAST(arg.bmi AS VARCHAR(255)) + ' '
                        + CAST(arg.ethrisk AS VARCHAR(255)) + ' '
                        + CAST(arg.fh_cvd AS VARCHAR(255)) + ' '
                        + CAST(arg.rati AS VARCHAR(255)) + ' '
                        + CAST(arg.sbp AS VARCHAR(255)) + ' '
                        + CAST(arg.smokecat AS VARCHAR(255)) + ' '
                        + CAST(arg.surv AS VARCHAR(255)) + ' '
                        + CAST(arg.town AS VARCHAR(255)) AS value
               FROM     dbo.TestData arg
             )
    SELECT  'female=$(./bin/Q80_model_4_0_commandLine ' + args.value
            + '); male=$(./bin/Q80_model_4_1_commandLine ' + args.value
            + '); echo "' + args.value
            + '" $female $male >> regression-testcases.txt;' AS line
    INTO    TestCase
    FROM    args

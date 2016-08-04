USE [MaskingDB]
GO

/****** Object:  UserDefinedFunction [dbo].[MaskHelper]    Script Date: 08/02/2016 17:15:41 ******/
/*
 * 8.2.16-tb. Modifying this function to be able to mask different types differently. For instance
 * if we need to mask a datetime field, the resulting value must still be a valid date, i.e., 
 * yyyy-mm-dd format with numbers in valid ranges (not simply replacing with x's).
 */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[MaskHelper]
(
	@Text VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)  -- see if we can use sql_variant data type here?
AS
BEGIN
	
	DECLARE @TextLen int = LEN(IsNull(@Text,''));

	IF (@TextLen < 4) RETURN @Text;
	
	-- if value passed in is date, then replace it with an actual date
	IF ISDATE(@Text) = 1 RETURN '2000-01-01';

	RETURN SUBSTRING(@Text, 1, 3) + REPLICATE('*', @TextLen - 3);
	
	/*
	 * Possibly look to the following in determinings data types of the values being masked:
	 *     select column_name, data_type 
	 *     from information_schema.columns 
	 *     where table_name=’your_table’
	 */

END
GO
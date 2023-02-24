USE BookShareDB;
GO

CREATE OR ALTER VIEW [vCurrentShareAgreements]
AS
SELECT [agreementID],
	   [copyID],
	   [borrowerID],
	   [lendingDate],
	   [returnDate],
	   [state]
FROM [shareAgreement]
WHERE [state] = 0 OR [state] = 1 OR [state] = 3;
GO
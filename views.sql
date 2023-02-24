USE BookShareDB;
GO

CREATE VIEW [vCurrentShareAgreements]
AS
SELECT [agreementID],
	   [copyID],
	   [borrowerID],
	   [lendingDate],
	   [returnDate],
	   [state]
FROM [shareAgreement]
WHERE [returnDate] >= CAST((GETDATE()) AS date);
GO
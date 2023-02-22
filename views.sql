USE BookShareDB;
GO

CREATE VIEW vCurrentShareAgreements
AS
SELECT [agreementID],
	   [copyID],
	   [ownerID],
	   [borrowerID],
	   [lendingDate],
	   [returnDate],
	   [state]
FROM shareAgreement
WHERE [returnDate] >= CAST((GETDATE()) AS date);
GO
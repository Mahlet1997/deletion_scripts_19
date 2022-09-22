
--script to alter VarchalertEvents view

USE [marcus8]
GO

ALTER VIEW [dbo].[vArchAlertEvents]
AS
SELECT *, NULL AS DashCamEventRID FROM Marcus_2011..AlertEvents WITH (NOLOCK)
UNION ALL
SELECT *, NULL AS DashCamEventRID FROM Marcus_2012..AlertEvents WITH (NOLOCK)
UNION ALL
SELECT *, NULL AS DashCamEventRID FROM Marcus_2013..AlertEvents WITH (NOLOCK)
UNION ALL
SELECT *, NULL AS DashCamEventRID FROM Marcus_2014..AlertEvents WITH (NOLOCK)
UNION ALL
SELECT *, NULL AS DashCamEventRID FROM Marcus_2015..AlertEvents WITH (NOLOCK)
UNION ALL
SELECT *, NULL AS DashCamEventRID FROM Marcus_2016..AlertEvents WITH (NOLOCK)
UNION ALL
SELECT *, NULL AS DashCamEventRID FROM Marcus_2017..AlertEvents WITH (NOLOCK)
UNION ALL
SELECT *, NULL AS DashCamEventRID FROM Marcus_2018..AlertEvents WITH (NOLOCK)
UNION ALL
SELECT *, NULL AS DashCamEventRID FROM Marcus_2019..AlertEvents WITH (NOLOCK)
UNION ALL
SELECT * FROM Marcus8..AlertEvents WITH (NOLOCK)
GO

--script to alter vArchMarcusCommands


USE [marcus8]
GO

ALTER VIEW [dbo].[vArchMarcusCommands]
AS
SELECT * FROM Marcus_2011..MarcusCommands WITH (NOLOCK)
UNION ALL
SELECT * FROM Marcus_2012..MarcusCommands WITH (NOLOCK)
UNION ALL
SELECT * FROM Marcus_2013..MarcusCommands WITH (NOLOCK)
UNION ALL
SELECT * FROM Marcus_2014..MarcusCommands WITH (NOLOCK)
UNION ALL
SELECT * FROM Marcus_2015..MarcusCommands WITH (NOLOCK)
UNION ALL
SELECT * FROM Marcus_2016..MarcusCommands WITH (NOLOCK)
UNION ALL
SELECT * FROM Marcus_2017..MarcusCommands WITH (NOLOCK)
UNION ALL
SELECT * FROM Marcus_2018..MarcusCommands WITH (NOLOCK)
UNION ALL
SELECT * FROM Marcus_2019..MarcusCommands WITH (NOLOCK)
UNION ALL
SELECT * FROM Marcus8..MarcusCommands WITH (NOLOCK)

GO








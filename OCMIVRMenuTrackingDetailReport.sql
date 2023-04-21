/* 
-- =============================================
-- Author:<Shruthi>
-- Version:<4.1.12.3001-beta.1>
-- =============================================
*/
SET @v_count:= (SELECT COUNT(*) from OCMCustomReport where ReportName='OCMIVRMenuTrackingDetailReport');
SET @qry = IF((@v_count>=1),
	'UPDATE OCMCustomReport
    SET ReportQuery = ''SELECT CTG.UCID, 
	FORMATDATETIME(CTG.StartDateTime,''''dd/MM/yyyy HH:mm:ss'''') AS StartDateTime,
	FORMATDATETIME(CTG.EndDateTime,''''dd/MM/yyyy HH:mm:ss'''') AS EndDateTime,
	CTG.Duration,TI.AgentID, A.AgentName, A.TeamName,CTG.CallerID,CTG.DNIS,
	CTG.Hotline,CTG.ServiceNumber,CTG.CustomerID,CTG.CustomerIDType,CTG.CustomerType,
	CTG.Language,CTG.LastMenu,CTG.ProductType,
	(case when CTG.TransferredFlag = ''''AT'''' then ''''Yes'''' ELSE ''''No'''' END) AS TransferredFlag,
	CTG.TransferVDN, CTG.Intent, CTGMN.MenuName,CTGMN.MenuID, CTGMN.MenuOrder, 
	SUM(CAST(CTGMN.MaxCount AS UNSIGNED)) AS NoOfAttempts,
	FORMATDATETIME(CTGMN.MenuStartDateTime,''''dd/MM/yyyy HH:mm:ss'''') AS MenuStartDateTime,
	FORMATDATETIME(CTGMN.MenuEndDateTime,''''dd/MM/yyyy HH:mm:ss'''') AS MenuEndDateTime,
	CTGMN.Value,FORMATDATETIME(CTGMN.ReportDateTime,''''dd/MM/yyyy HH:mm:ss'''') AS ReportDateTime 
	FROM OCM_IvrJourneyReport CTG INNER JOIN OCM_IvrJourneyReport_MenuNavigation CTGMN ON CTG.UCID = CTGMN.UCID 
	LEFT JOIN (
		select min(ID) as ID, SessionID, max(AgentID) as AgentID from OCM_AgentInteractionReport I 
		WHERE I.`ReportDateTime`>=ExportFromDate and I.`ReportDateTime`<=ExportToDate
		group by SessionID 
	) TI ON CTG.UCID = TI.SessionId
	AgentHierarchyResult A ON A.AgentId=TI.AgentID
	WHERE CTG.`ReportDateTime`>=ExportFromDate and CTG.`ReportDateTime`<=ExportToDate
	GROUP BY CTG.`UCID`, TI.AgentID, A.AgentName, A.TeamName, StartDateTime,EndDateTime,CTG.Duration,CTG.CallerID,CTG.DNIS,
	CTG.Hotline,CTG.ServiceNumber,CTG.CustomerID,CTG.CustomerIDType,CTG.CustomerType,
	CTG.Language,CTG.LastMenu,CTG.ProductType,CTG.TransferredFlag,CTG.TransferVDN, CTG.Intent, CTGMN.MenuName,
	CTGMN.MenuID, CTGMN.MenuOrder, CTGMN.MenuStartDateTime,CTGMN.MenuEndDateTime,CTGMN.Value,ReportDateTime'',
    LastChangedOn = DATE_FORMAT(NOW(), ''%Y%m%d %k%i%s'')
    WHERE ReportName=''OCMIVRMenuTrackingDetailReport'';'
,
	'INSERT INTO OCMCustomReport ( ReportName, ReportQuery, ReportCreatedBy, ReportCreatedOn, LastChangedBy, LastChangedOn, ReportType) 
	VALUES ( N''OCMIVRMenuTrackingDetailReport'', N''SELECT CTG.UCID, 
	FORMATDATETIME(CTG.StartDateTime,''''dd/MM/yyyy HH:mm:ss'''') AS StartDateTime,
	FORMATDATETIME(CTG.EndDateTime,''''dd/MM/yyyy HH:mm:ss'''') AS EndDateTime,
	CTG.Duration,TI.AgentID, A.AgentName, A.TeamName,CTG.CallerID,CTG.DNIS,
	CTG.Hotline,CTG.ServiceNumber,CTG.CustomerID,CTG.CustomerIDType,CTG.CustomerType,
	CTG.Language,CTG.LastMenu,CTG.ProductType,
	(case when CTG.TransferredFlag = ''''AT'''' then ''''Yes'''' ELSE ''''No'''' END) AS TransferredFlag,
	CTG.TransferVDN, CTG.Intent, CTGMN.MenuName,CTGMN.MenuID, CTGMN.MenuOrder, 
	SUM(CAST(CTGMN.MaxCount AS UNSIGNED)) AS NoOfAttempts,
	FORMATDATETIME(CTGMN.MenuStartDateTime,''''dd/MM/yyyy HH:mm:ss'''') AS MenuStartDateTime,
	FORMATDATETIME(CTGMN.MenuEndDateTime,''''dd/MM/yyyy HH:mm:ss'''') AS MenuEndDateTime,
	CTGMN.Value,FORMATDATETIME(CTGMN.ReportDateTime,''''dd/MM/yyyy HH:mm:ss'''') AS ReportDateTime 
	FROM OCM_IvrJourneyReport CTG INNER JOIN OCM_IvrJourneyReport_MenuNavigation CTGMN ON CTG.UCID = CTGMN.UCID 
	LEFT JOIN (
		select min(ID) as ID, SessionID, max(AgentID) as AgentID from OCM_AgentInteractionReport I 
		WHERE I.`ReportDateTime`>=ExportFromDate and I.`ReportDateTime`<=ExportToDate
		group by SessionID 
	) TI ON CTG.UCID = TI.SessionId
	AgentHierarchyResult A ON A.AgentId=TI.AgentID
	WHERE CTG.`ReportDateTime`>=ExportFromDate and CTG.`ReportDateTime`<=ExportToDate
	GROUP BY CTG.`UCID`, TI.AgentID, A.AgentName, A.TeamName, StartDateTime,EndDateTime,CTG.Duration,CTG.CallerID,CTG.DNIS,
	CTG.Hotline,CTG.ServiceNumber,CTG.CustomerID,CTG.CustomerIDType,CTG.CustomerType,
	CTG.Language,CTG.LastMenu,CTG.ProductType,CTG.TransferredFlag,CTG.TransferVDN, CTG.Intent, CTGMN.MenuName,
	CTGMN.MenuID, CTGMN.MenuOrder, CTGMN.MenuStartDateTime,CTGMN.MenuEndDateTime,CTGMN.Value,ReportDateTime'',
	N''Admin'',DATE_FORMAT(NOW(), ''%Y%m%d %k%i%s''), N''Admin'', DATE_FORMAT(NOW(), ''%Y%m%d %k%i%s''), N''Generic'');'
	);
SET @stmt_str =  @qry;
PREPARE stmt FROM @stmt_str;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
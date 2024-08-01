-- Scripts are not supported under any SolarWinds support program or service.
-- Scripts are provided AS IS without warranty of any kind. SolarWinds further
-- disclaims all warranties including, without limitation, any implied warranties
-- of merchantability or of fitness for a particular purpose. The risk arising
-- out of the use or performance of the scripts and documentation stays with you.
-- In no event shall SolarWinds or anyone else involved in the creation,
-- production, or delivery of the scripts be liable for any damages whatsoever
-- (including, without limitation, damages for loss of business profits, business
-- interruption, loss of business information, or other pecuniary loss) arising
-- out of the use of or inability to use the scripts or documentation.

-- Setting password enforcement
IF EXISTS(SELECT * FROM [WebSettings] WHERE [SettingName] = 'AdminPasswordEnforcement')
        UPDATE [WebSettings]
        SET [SettingValue] = 'True'
        WHERE [SettingName] = 'AdminPasswordEnforcement'
    ELSE
        INSERT INTO [WebSettings] ([SettingName], [SettingValue])
        VALUES ('AdminPasswordEnforcement', 'True')
		
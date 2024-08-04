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

Update Limitations set WhereClause = REPLACE(REPLACE(REPLACE(CAST(WhereClause as varchar(max)), '( (', ' ( ( '), '((', ' ( ( '),'))',' ) ) ')
DELETE FROM Limitations WHERE WhereClause = '1=1'
DELETE FROM LimitationSnapShots
DELETE FROM ContainerMemberSnapshots
DELETE FROM PendingNotifications
DELETE FROM SubscriptionTags
DELETE FROM Subscriptions WHERE EndpointAddress NOT LIKE 'http%'

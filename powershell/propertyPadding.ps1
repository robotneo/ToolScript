# 作者：Neo
# 时间：2019/8/17
# 作用：把指定OU中的用户邮件属性进行添加 邮箱属性: 用户加后缀@itkmi.com

# 找到邮箱为空的用户对象并设置为邮箱
# ?是Where-Object的别名，%是ForEach-Object的别名
Get-ADUser -Filter {enabled -eq "true"} -SearchBase  'OU=市场部,OU=DTAll,DC=test,DC=com' -Properties name,EmailAddress | Where-Object {$_.EmailAddress -eq $null} | ForEach-Object {Set-ADUser $_ -EmailAddress ($_.sAMAccountName + '@itkmi.com')}

# Get-ADUser -Filter {enabled -eq "false"} -SearchBase  'OU=海拍客,OU=hipacall,DC=hipac,DC=vip'

# Get-ADUser -Filter 'Name -like "*"' -SearchBase  'OU=市场部,OU=DTAll,DC=test,DC=com' -Properties EmailAddress | % {Set-ADUser $_ -EmailAddress ($_.sAMAccountName + '@itkmi.com')}

# Get-ADUser -Filter 'Name -like "*"' -SearchBase  'CN=test3,OU=市场部,OU=DTAll,DC=test,DC=com' -Properties EmailAddress | % {Set-ADUser $_ -EmailAddress ($_.sAMAccountName + '@itkmi.com')}

# Get-ADUser -Filter 'Name -like "*"' -SearchBase  'CN=test3,OU=市场部,OU=DTAll,DC=test,DC=com' -Properties EmailAddress


# 生产环境中我们往往会遇到以多个邮箱别名结尾的情况，如何快速导出当前域用户邮箱以某字段或后缀结尾的用户列表信息变得尤为重要

# 本例简单汇总下如何通过Powershell快速筛选出当前邮箱信息包含azureyun.com的用户列表并导出
Get-ADUser -Filter * -SearchBase "OU=syncall,DC=azureyun,DC=com" -Properties name,mail |Where-Object {$_.mail -match "azureyun.com"} |Export-Csv c:\azureyun_mail.csv -Encoding utf8 -NoTypeInformation

# 同时我们也可以快速获取当前邮箱包含azureyun.com信息的用户数量：
(Get-ADUser -Filter * -SearchBase "OU=syncall,DC=azureyun,DC=com" -Properties name,mail |Where-Object {$_.mail -match "azureyun.com"} ).count
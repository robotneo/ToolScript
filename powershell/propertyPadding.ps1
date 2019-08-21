# ���ߣ�Neo
# ʱ�䣺2019/8/17
# ���ã���ָ��OU�е��û��ʼ����Խ������ ��������: �û��Ӻ�׺@itkmi.com

# �ҵ�����Ϊ�յ��û���������Ϊ����
# ?��Where-Object�ı�����%��ForEach-Object�ı���
Get-ADUser -Filter {enabled -eq "true"} -SearchBase  'OU=�г���,OU=DTAll,DC=test,DC=com' -Properties name,EmailAddress | Where-Object {$_.EmailAddress -eq $null} | ForEach-Object {Set-ADUser $_ -EmailAddress ($_.sAMAccountName + '@itkmi.com')}

# Get-ADUser -Filter {enabled -eq "false"} -SearchBase  'OU=���Ŀ�,OU=hipacall,DC=hipac,DC=vip'

# Get-ADUser -Filter 'Name -like "*"' -SearchBase  'OU=�г���,OU=DTAll,DC=test,DC=com' -Properties EmailAddress | % {Set-ADUser $_ -EmailAddress ($_.sAMAccountName + '@itkmi.com')}

# Get-ADUser -Filter 'Name -like "*"' -SearchBase  'CN=test3,OU=�г���,OU=DTAll,DC=test,DC=com' -Properties EmailAddress | % {Set-ADUser $_ -EmailAddress ($_.sAMAccountName + '@itkmi.com')}

# Get-ADUser -Filter 'Name -like "*"' -SearchBase  'CN=test3,OU=�г���,OU=DTAll,DC=test,DC=com' -Properties EmailAddress


# �������������������������Զ�����������β���������ο��ٵ�����ǰ���û�������ĳ�ֶλ��׺��β���û��б���Ϣ�����Ϊ��Ҫ

# �����򵥻��������ͨ��Powershell����ɸѡ����ǰ������Ϣ����azureyun.com���û��б�����
Get-ADUser -Filter * -SearchBase "OU=syncall,DC=azureyun,DC=com" -Properties name,mail |Where-Object {$_.mail -match "azureyun.com"} |Export-Csv c:\azureyun_mail.csv -Encoding utf8 -NoTypeInformation

# ͬʱ����Ҳ���Կ��ٻ�ȡ��ǰ�������azureyun.com��Ϣ���û�������
(Get-ADUser -Filter * -SearchBase "OU=syncall,DC=azureyun,DC=com" -Properties name,mail |Where-Object {$_.mail -match "azureyun.com"} ).count
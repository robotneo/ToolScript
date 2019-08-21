# 作者：Neo
# 时间：2019/8/18
# 通过随机数生成用户密码，并把用户密码设置为每个用户发送相关用户信息邮件到用户邮箱

# 定义邮件全局变量
$EmailStmpServer = "smtp.itkmi.com"
$EmailSender="it-monitor@itkmi.com"
#$EmailRecipient="test1@itkmi.com"
# 定义是否发邮件
$SendMail=$true
# 定义是否发生报告
$SaveReport=$true
$ReportName=".\$(get-date -format yyyyMMdd)-ReportStatus.html"

$HTMLHeader = @'
<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Frameset//EN' 'http://www.w3.org/TR/html4/frameset.dtd'>
<html>
<head>
<title>我的域用户信息</title>
<style type='text/css'>
    body {
        font-size: 14px;
        font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
    }

    #report { width: 1000px; }

    table{
    border-collapse: collapse;
    border: none;
    font: 10pt Verdana, Geneva, Arial, Helvetica, sans-serif;
    color: black;
    margin-bottom: 10px;
    }

    table td{
    font-size: 12px;
    padding-left: 0px;
    padding-right: 20px;
    text-align: left;
    }

    table th {
    font-size: 12px;
    font-weight: bold;
    padding-left: 0px;
    padding-right: 20px;
    text-align: left;
    }

    h3{
    clear: both;
    font-size: 115%;
    margin-left: 20px;
    margin-top: 30px;
    }

    table.list{ float: left; }
    table.list td:nth-child(1){
    font-weight: bold;
    border-right: 1px grey solid;
    text-align: right;
    }

    table.list td:nth-child(2){ padding-left: 7px; }
    table tr:nth-child(even) td:nth-child(even){ background: #CCCCCC; }
    table tr:nth-child(odd) td:nth-child(odd){ background: #F2F2F2; }
    tr:nth-child(even) td:nth-child(odd){ background: #DDDDDD; }
    table tr:nth-child(odd) td:nth-child(even){ background: #E5E5E5; }
    div.column { width: 350px; float: left; }
    div.first{ padding-right: 20px; border-right: 1px  grey solid; }
    div.second{ margin-left: 30px; }
    table{ margin-left: 20px; }
</style>
</head>
<body>
'@



$HTMLEnd = @'
</div>
</body>
</html>
'@

$Users = Get-ADUser -Filter {enabled -eq "true"} -SearchBase 'OU=研发部,OU=DTALL,DC=itkmi,DC=com' -SearchScope Subtree -Properties sAMAccountName
foreach ($user in $Users)
{
    $password =.\Get-RandomString.ps1 -LowerCase -UpperCase -Numbers
    Set-ADAccountPassword -Identity $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $password -Force)
    $domainUser = $user.SamAccountName
    $upnUser = $user.UserPrincipalName
    $EmailRecipient = $user.SamAccountName + "@itkmi.com"
    #把重新重置密码的用户和密码发送到对应的用户邮箱中
    $CurrentSystemHTML = ''
    $CurrentSystemHTML += "<hr noshade size=3 width='100%'>"
    $CurrentSystemHTML += "<div id='report'>"
    $CurrentSystemHTML += "<h3>$domainUser 用户信息</h3>"
    $CurrentSystemHTML += '<table class="list">'
    $CurrentSystemHTML += '<tr>'
    $CurrentSystemHTML += '<td>AD域名</td>'
    $CurrentSystemHTML += "<td>hipac.vip</td>"
    $CurrentSystemHTML += "</tr>"
    $CurrentSystemHTML += '<tr>'
    $CurrentSystemHTML += '<td>用户</td>'
    $CurrentSystemHTML += "<td>$domainUser</td>"
    $CurrentSystemHTML += "</tr>"
    $CurrentSystemHTML += "<tr>"
    $CurrentSystemHTML += "<td>密码</td>"
    $CurrentSystemHTML += "<td>$password</td>"
    $CurrentSystemHTML += "</tr>"
    $CurrentSystemHTML += "<tr>"
    $CurrentSystemHTML += "<td>UPN账户</td>"
    $CurrentSystemHTML += "<td>$upnUser</td>"
    $CurrentSystemHTML += "</tr>"
    $CurrentSystemHTML += "</table>"

    $HTMLMiddle = $CurrentSystemHTML
    $HTMLmessage = $HTMLHeader + $HTMLMiddle + $HTMLEnd

    if ($SendMail)
    {
	    $HTMLmessage = $HTMLmessage | Out-String
        #  -Port 465 -UseSsl -Credential $user
        $Sub = "域用户信息(重要)"
        #SMTP发信验证
        $anonUser = "it-monitor@itkmi.com"
        $anonPass = ConvertTo-SecureString "123456" -AsPlainText -Force
        $anonCred = New-Object System.Management.Automation.PSCredential($anonUser, $anonPass)
        Send-MailMessage -To $EmailRecipient -Subject $Sub -From $EmailSender -BodyAsHtml $HTMLmessage -SmtpServer $EmailStmpServer -Credential $anonCred -Encoding ([System.Text.Encoding]::UTF8)
	    Start-Sleep -Milliseconds 200
    }
    elseif ($SaveReport)
    {
	    $HTMLMessage | Out-File $ReportName
    }
    else
    {
        Return $HTMLmessage
    }
}
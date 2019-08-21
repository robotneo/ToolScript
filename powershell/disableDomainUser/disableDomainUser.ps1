# ���ߣ�Neo
# ʱ�䣺2019/8/20
# ͨ��csv�ļ���Ϣ������������û�

Write-Host @"
#
# name.csv ���Ҫ���õ��˻� ������
#
# log.txt  ��ϸ��¼������û�ִ�е�ÿһ��ִ�в�������Description�� ɾ��ÿһ���飬 �ƶ��ȵȣ�
#
# �������Ķ���ɫ���棬�����к��Դ�����û��������ֶ�����
#
"@
pause
# ���Թ������øò�����ʵ��ִ�У�ֻ��ʾ
# Ҫʹ�ã�������ע�͵����в�����һ��
# $needWhatIf = "-WhatIf"
$needWhatIf = ""
# ÿִ��һ����������ʾȷ��
# Ҫȡ����������ע�͵����в�����һ��
#$needConfirm = ""
$needConfirm = "-Confirm:"+"$"+"false"
#$needConfirm = "None"
$suffix = "{0} {1}" -f $needWhatIf, $needConfirm
 
$baseDN = "DC=hipac,DC=vip"
$resigningOU = "OU=DTAll,DC=itkmi,DC=com"
 
# $cmd ����Ҫִ�е������ַ���
# ִ�������¼������־�ʹ�����־
function logAndExe($cmd) {
    $cmd | Tee-Object log.txt -Append
    Invoke-Expression $cmd
    if( -not $?){
    $Error[0] | Tee-Object log.txt -Append
    }
}
 
# $sam �����û���SamAccountName
# �����û��������飬���޳�����Domain Users��
# ���� �� ���ַ����б� [group1, group2, .....]
function search_user_group($sam){
    $groups = Get-ADPrincipalGroupMembership -Identity $sam
    $group_list = New-Object System.Collections.ArrayList
    foreach($g in $groups){
        if($g.name -ne 'Domain Users'){
            $group_list.Add($g) | Out-Null
        }
    }
    return $group_list
}
 
# ��ʼִ�����߼�
Start-Process -Wait notepad -ArgumentList .\name.csv
$userList = Import-Csv 'name.csv' -Encoding Default
$samList = New-Object System.Collections.ArrayList
$d = Get-Date
"`r`n$d����ʼ�����û���`r`n" | Tee-Object -Append "log.txt" | Write-Host
foreach($u in $userList){
    # $block_str = "(Name -eq '{0}') -and (Mobile -eq '{1}')" -f $u.Name, $u.Mobile
    $u.Name = $u.Name.TrimEnd()
    # �û�������������׺����ȫ�޶����ϡ�+������������������01��������+��ȫ�޶�
    if($u.Name.EndsWith("+")){
        $u.Name = $u.Name.TrimEnd("+")
        $block_str = "Name -eq ""{0}""" -f $u.Name
    }
    else{
        $block_str = "Name -like ""{0}*""" -f $u.Name
    }
    $block = [scriptblock]::Create($block_str)
    $tmp = Get-ADUser -Filter $block -SearchBase $baseDN
    if($tmp -eq $null){
        "��""$baseDN""���Ҳ����û�: $($u.Name) ,��˺��ԣ���ȷ��" | Tee-Object -Append "log.txt" | Write-Warning
        continue
    }
    # ����û����������ƣ���һ��ɸѡ
    # �磺 ����
    # ����01����������棬�����������������
    # �ٶ� �������� ����01, �����������ظ�
    elseif($tmp.GetType().Name -eq "Object[]"){
        $tmp2 = $tmp | Where-Object {($_.Name -eq $u.Name ) -or $_.Name.Contains($u.Name+��0��)}
        if($tmp2.GetType().Name -eq "Object[]"){
            # �������ϲŻ���Object[]�� ���������һ��,��Ϊ $_.Name -eq $u.Name
            "���û��˺�: $($u.Name) ������������˺��ԣ���ȷ�Ϻ���д���������磺����01��`r`n����û�Ϊ�����������������û�����01�ȣ���ȫ�޶���������д ""����+""" | Tee-Object -Append "log.txt" | Write-Warning
            "-----------------------------" | Tee-Object -Append "log.txt" | Write-Warning
            foreach($t in $tmp2){
                $t.Name | Tee-Object -Append "log.txt" | Write-Warning
            }
            "-----------------------------" | Tee-Object -Append "log.txt" | Write-Warning
            # �����������ӣ�����������һ���û�
            continue
        }
        else{
            # ɸѡ��ֻ��һ������������뵽�������б�
            if($tmp2.Name -ne $u.Name){
                "��""$baseDN""���ҵ��û�: {0} ��name.csv�е��û�: {1} ����ȫƥ��,����˺���" -f $tmp2.Name, $u.Name | Tee-Object -Append "log.txt" | Write-Warning
                continue
            }
            $tmp = $tmp2
        }
    }
    elseif($tmp.Name -ne $u.Name){
        "��""$baseDN""���Ҳ����û�: $($u.Name) ,��˺��ԣ���ȷ��" | Tee-Object -Append "log.txt" | Write-Warning
        continue
    }
    $samList.Add($tmp) | Out-Null
}
 
# ���б����û�ִ���ƶ����޳��飬��������
foreach($u in $samList){
    $d = Get-Date
    "$d����ʼ�����û���$($u.Name)`r`n" | Tee-Object -Append "log.txt" | Write-Warning
 
    # �����ͬ������Ա��ְ��Ҫ�ŵ���ͬOU�������Ӻ���detect_ou�ж�
    # $ou = detect_ou($u.DistinguishedName)
    # �������溯������OU��û�ҵ�Ŀ��OU�����账������¼����־
 
    $ou = $resigningOU
    $leaveUserOu = "OU=Leave,OU=DTALL,DC=itkmi,DC=com"
    if($ou -ne $false){
        # ����1�� �ȸ��û�����
        $_desc = Get-ADUser -Identity $u.SamAccountName -Properties Description
        $desc = $_desc.Description
        $cmd = @"
Set-ADUser -Identity {0} -Description {1} {2}
"@ -f $u.SamAccountName, ("`"��ְ {0} {1}`"" -f $d.ToString("yyyy/M/dd"), $desc), $suffix
        logAndExe($cmd)
        # ����2�� �޳��û���������
        foreach($g in search_user_group($u.SamAccountName)){
            $cmd = @"
Remove-ADGroupMember -Identity "{0}" -Members "{1}" {2}
"@ -f $g, $u.SamAccountName, $suffix
            logAndExe($cmd)
        }
        # ����3�� ���ø��û�
        $cmd = @"
Disable-ADAccount -Identity {0} {1}
"@ -f $u.SamAccountName, $suffix
        logAndExe($cmd)
        # ����4�� �ƶ����û�����Ӧ��OU
        $cmd = @"
Move-ADObject -Identity "{0}" -TargetPath "{1}" {2}
"@ -f $u.DistinguishedName, $leaveUserOu, $suffix
        logAndExe($cmd)
    }
}
Pause
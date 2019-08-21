# 作者：Neo
# 时间：2019/8/20
# 通过csv文件信息，禁用相关域用户

Write-Host @"
#
# name.csv 存放要禁用的账户 中文名
#
# log.txt  详细记录了针对用户执行的每一个执行操作（改Description， 删除每一个组， 移动等等）
#
# 请认真阅读黄色警告，对其中忽略处理的用户，进行手动处理
#
"@
pause
# 调试过程设置该参数不实际执行，只提示
# 要使用，请设置注释掉该行并新增一行
# $needWhatIf = "-WhatIf"
$needWhatIf = ""
# 每执行一个操作都提示确认
# 要取消，请设置注释掉该行并新增一行
#$needConfirm = ""
$needConfirm = "-Confirm:"+"$"+"false"
#$needConfirm = "None"
$suffix = "{0} {1}" -f $needWhatIf, $needConfirm
 
$baseDN = "DC=hipac,DC=vip"
$resigningOU = "OU=DTAll,DC=itkmi,DC=com"
 
# $cmd 传入要执行的命令字符串
# 执行命令并记录命令日志和错误日志
function logAndExe($cmd) {
    $cmd | Tee-Object log.txt -Append
    Invoke-Expression $cmd
    if( -not $?){
    $Error[0] | Tee-Object log.txt -Append
    }
}
 
# $sam 传入用户的SamAccountName
# 搜索用户所属的组，并剔除掉‘Domain Users’
# 返回 组 的字符串列表 [group1, group2, .....]
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
 
# 开始执行主逻辑
Start-Process -Wait notepad -ArgumentList .\name.csv
$userList = Import-Csv 'name.csv' -Encoding Default
$samList = New-Object System.Collections.ArrayList
$d = Get-Date
"`r`n$d：开始导入用户：`r`n" | Tee-Object -Append "log.txt" | Write-Host
foreach($u in $userList){
    # $block_str = "(Name -eq '{0}') -and (Mobile -eq '{1}')" -f $u.Name, $u.Mobile
    $u.Name = $u.Name.TrimEnd()
    # 用户可能有重名后缀，完全限定加上’+‘，比如张三，张三01，则张三+完全限定
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
        "在""$baseDN""下找不到用户: $($u.Name) ,因此忽略，请确认" | Tee-Object -Append "log.txt" | Write-Warning
        continue
    }
    # 如果用户姓名有类似，进一步筛选
    # 如： 张三
    # 张三01将会给出警告，张三三不会给出警告
    # 假定 给出的是 张三01, 不会搜索到重复
    elseif($tmp.GetType().Name -eq "Object[]"){
        $tmp2 = $tmp | Where-Object {($_.Name -eq $u.Name ) -or $_.Name.Contains($u.Name+“0”)}
        if($tmp2.GetType().Name -eq "Object[]"){
            # 两个以上才会是Object[]， 结果至少有一个,因为 $_.Name -eq $u.Name
            "该用户账号: $($u.Name) 存在重名，因此忽略，请确认后填写完整名，如：张三01！`r`n如果用户为张三，而还有其他用户张三01等，完全限定张三请填写 ""张三+""" | Tee-Object -Append "log.txt" | Write-Warning
            "-----------------------------" | Tee-Object -Append "log.txt" | Write-Warning
            foreach($t in $tmp2){
                $t.Name | Tee-Object -Append "log.txt" | Write-Warning
            }
            "-----------------------------" | Tee-Object -Append "log.txt" | Write-Warning
            # 警告后，跳过添加，继续处理下一个用户
            continue
        }
        else{
            # 筛选后只有一个，则继续加入到待处理列表
            if($tmp2.Name -ne $u.Name){
                "在""$baseDN""下找到用户: {0} 与name.csv中的用户: {1} 不完全匹配,，因此忽略" -f $tmp2.Name, $u.Name | Tee-Object -Append "log.txt" | Write-Warning
                continue
            }
            $tmp = $tmp2
        }
    }
    elseif($tmp.Name -ne $u.Name){
        "在""$baseDN""下找不到用户: $($u.Name) ,因此忽略，请确认" | Tee-Object -Append "log.txt" | Write-Warning
        continue
    }
    $samList.Add($tmp) | Out-Null
}
 
# 对列表中用户执行移动，剔除组，改名操作
foreach($u in $samList){
    $d = Get-Date
    "$d：开始处理用户：$($u.Name)`r`n" | Tee-Object -Append "log.txt" | Write-Warning
 
    # 如果不同部门人员离职需要放到不同OU，可增加函数detect_ou判断
    # $ou = detect_ou($u.DistinguishedName)
    # 根据上面函数查找OU，没找到目标OU将不予处理，并记录下日志
 
    $ou = $resigningOU
    $leaveUserOu = "OU=Leave,OU=DTALL,DC=itkmi,DC=com"
    if($ou -ne $false){
        # 步骤1： 先改用户描述
        $_desc = Get-ADUser -Identity $u.SamAccountName -Properties Description
        $desc = $_desc.Description
        $cmd = @"
Set-ADUser -Identity {0} -Description {1} {2}
"@ -f $u.SamAccountName, ("`"离职 {0} {1}`"" -f $d.ToString("yyyy/M/dd"), $desc), $suffix
        logAndExe($cmd)
        # 步骤2： 剔除用户所属的组
        foreach($g in search_user_group($u.SamAccountName)){
            $cmd = @"
Remove-ADGroupMember -Identity "{0}" -Members "{1}" {2}
"@ -f $g, $u.SamAccountName, $suffix
            logAndExe($cmd)
        }
        # 步骤3： 禁用该用户
        $cmd = @"
Disable-ADAccount -Identity {0} {1}
"@ -f $u.SamAccountName, $suffix
        logAndExe($cmd)
        # 步骤4： 移动该用户到对应的OU
        $cmd = @"
Move-ADObject -Identity "{0}" -TargetPath "{1}" {2}
"@ -f $u.DistinguishedName, $leaveUserOu, $suffix
        logAndExe($cmd)
    }
}
Pause
# 作者：Neo
# 时间：2019/8/18

#requires -version 2

<#
.概要
输出随机字符串
.描述
输出包含指定类型字符的一个或多个随机字符串
.参数长度
指定输出字符串的长度,默认值为8,您不能指定小于4的值
.参数: LowerCase
指定字符串必须包含小写ASCII字符（默认值）如果您不希望随机字符串包含小写ASCII字符,请指定-LowerCase：$ false
.参数: UpperCase
指定字符串必须包含大写ASCII字符
.参数: Numbers
指定字符串必须包含数字字符（0到9）
.参数: Symbols
指定字符串必须包含打字机符号字符
.参数: Count
指定要输出的随机字符串数
.示例
PS C:\> Get-RandomString
输出包含8个随机小写ASCII字符的字符串
.示例
PS C:\> Get-RandomString -Length 14 -Count 5
输出5个随机字符串，每个字符串包含14个小写ASCII字符
.示例
PS C:\> Get-RandomString -UpperCase -LowerCase -Numbers -Count 10
输出10个随机8个字符的字符串，包含大写，小写和数字
.示例
PS C:\> Get-RandomString -Length 32 -LowerCase:$false -Numbers -Symbols -Count 20
输出20个包含数字和打字符号的随机32个字符的字符串
.示例
PS C:\> Get-RandomString -Length 4 -LowerCase:$false -Numbers -Count 15
输出15个随机4个字符的字符串，仅包含数字
#>

param(
  [UInt32] $Length=8,
  [Switch] $LowerCase=$TRUE,
  [Switch] $UpperCase=$FALSE,
  [Switch] $Numbers=$FALSE,
  [Switch] $Symbols=$FALSE,
  [Uint32] $Count=1
)

if ($Length -lt 4) {
  throw "-Length must specify a value greater than 3"
}

if (-not ($LowerCase -or $UpperCase -or $Numbers -or $Symbols)) {
  throw "You must specify one of: -LowerCase -UpperCase -Numbers -Symbols"
}

# Specifies bitmap values for character sets selected.
$CHARSET_LOWER = 1
$CHARSET_UPPER = 2
$CHARSET_NUMBER = 4
$CHARSET_SYMBOL = 8

# Creates character arrays for the different character classes,
# based on ASCII character values.
$charsLower = 97..122 | foreach-object { [Char] $_ }
$charsUpper = 65..90 | foreach-object { [Char] $_ }
$charsNumber = 48..57 | foreach-object { [Char] $_ }
$charsSymbol = 35,36,42,43,44,45,46,47,58,59,61,63,64,
  91,92,93,95,123,125,126 | foreach-object { [Char] $_ }

# Contains the array of characters to use.
$charList = @()
# Contains bitmap of the character sets selected.
$charSets = 0
if ($LowerCase) {
  $charList += $charsLower
  $charSets = $charSets -bor $CHARSET_LOWER
}
if ($UpperCase) {
  $charList += $charsUpper
  $charSets = $charSets -bor $CHARSET_UPPER
}
if ($Numbers) {
  $charList += $charsNumber
  $charSets = $charSets -bor $CHARSET_NUMBER
}
if ($Symbols) {
  $charList += $charsSymbol
  $charSets = $charSets -bor $CHARSET_SYMBOL
}

# Returns True if the string contains at least one character
# from the array, or False otherwise.
function test-stringcontents([String] $test, [Char[]] $chars) {
  foreach ($char in $test.ToCharArray()) {
    if ($chars -ccontains $char) { return $TRUE }
  }
  return $FALSE
}

1..$Count | foreach-object {
  # Loops until the string contains at least
  # one character from each character class.
  do {
    # No character classes matched yet.
    $flags = 0
    $output = ""
    # Create output string containing random characters.
    1..$Length | foreach-object {
      $output += $charList[(get-random -maximum $charList.Length)]
    }
    # Check if character classes match.
    if ($LowerCase) {
      if (test-stringcontents $output $charsLower) {
        $flags = $flags -bor $CHARSET_LOWER
      }
    }
    if ($UpperCase) {
      if (test-stringcontents $output $charsUpper) {
        $flags = $flags -bor $CHARSET_UPPER
      }
    }
    if ($Numbers) {
      if (test-stringcontents $output $charsNumber) {
        $flags = $flags -bor $CHARSET_NUMBER
      }
    }
    if ($Symbols) {
      if (test-stringcontents $output $charsSymbol) {
        $flags = $flags -bor $CHARSET_SYMBOL
      }
    }
  }
  until ($flags -eq $charSets)
  # Output the string.
  $output
}
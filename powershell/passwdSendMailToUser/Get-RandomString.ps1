# ���ߣ�Neo
# ʱ�䣺2019/8/18

#requires -version 2

<#
.��Ҫ
�������ַ���
.����
�������ָ�������ַ���һ����������ַ���
.��������
ָ������ַ����ĳ���,Ĭ��ֵΪ8,������ָ��С��4��ֵ
.����: LowerCase
ָ���ַ����������СдASCII�ַ���Ĭ��ֵ���������ϣ������ַ�������СдASCII�ַ�,��ָ��-LowerCase��$ false
.����: UpperCase
ָ���ַ������������дASCII�ַ�
.����: Numbers
ָ���ַ���������������ַ���0��9��
.����: Symbols
ָ���ַ�������������ֻ������ַ�
.����: Count
ָ��Ҫ���������ַ�����
.ʾ��
PS C:\> Get-RandomString
�������8�����СдASCII�ַ����ַ���
.ʾ��
PS C:\> Get-RandomString -Length 14 -Count 5
���5������ַ�����ÿ���ַ�������14��СдASCII�ַ�
.ʾ��
PS C:\> Get-RandomString -UpperCase -LowerCase -Numbers -Count 10
���10�����8���ַ����ַ�����������д��Сд������
.ʾ��
PS C:\> Get-RandomString -Length 32 -LowerCase:$false -Numbers -Symbols -Count 20
���20���������ֺʹ��ַ��ŵ����32���ַ����ַ���
.ʾ��
PS C:\> Get-RandomString -Length 4 -LowerCase:$false -Numbers -Count 15
���15�����4���ַ����ַ���������������
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
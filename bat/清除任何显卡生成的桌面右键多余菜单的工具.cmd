regsvr32 /u /s igfxpph.dll
reg delete HKEY_CLASSES_ROOT\Directory\Background\shellex\ContextMenuHandlers /f
reg add HKEY_CLASSES_ROOT\Directory\Background\shellex\ContextMenuHandlers\new /ve /d {D969A300-E7FF-11d0-A93B-00A0C90F2719}
; ˵����Intel�����Կ�����810��815E��845G��865G�ȣ�����
; �������Ҽ����ɶ���Ĳ˵���û�����ò�Ҫ�����ؼ�����Щ
; �˵���ʹ�Ҽ�������û���������һ�ֵ����ٶ����ĸо���
; ��������Ҽ�����˵��İ취��

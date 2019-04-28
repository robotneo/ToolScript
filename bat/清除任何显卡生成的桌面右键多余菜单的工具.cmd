regsvr32 /u /s igfxpph.dll
reg delete HKEY_CLASSES_ROOT\Directory\Background\shellex\ContextMenuHandlers /f
reg add HKEY_CLASSES_ROOT\Directory\Background\shellex\ContextMenuHandlers\new /ve /d {D969A300-E7FF-11d0-A93B-00A0C90F2719}
; 说明：Intel集成显卡（如810，815E，845G，865G等），会
; 在桌面右键生成多余的菜单，没有作用不要紧，关键是这些
; 菜单会使右键弹出变得缓慢。给人一种电脑速度慢的感觉。
; 这是清除右键多余菜单的办法。

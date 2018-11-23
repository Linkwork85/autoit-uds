#include-Once

#include <Array.au3>

#include "UDSConstants.au3"

; # Index # =====================================================================================================================
; Title: 			Map
; AutoIt Version: 	3.3.14.5
; Language: 		English
; Description: 		Functions for manipulating maps.
; Author(s): 		linkwork85@qq.com(GuangZhou, China)
; ==> Index

; # Global Functions # ==========================================================================================================
; _MapCheck
; _MapClear
; _MapContainsKey
; _MapContainsValue
; _MapCreate
; _MapEqual
; _MapGet
; _MapIsEmpty
; _MapKeys
; _MapPut
; _MapRemove
; _MapSize
; ==> Global Functions

; # Internal Functions # ========================================================================================================
; __ensureMap
; __ensureKey
; __indexOfKey
; __setItem
; ==¡·Internal Functions

; # Global Function # ===========================================================================================================
; Name: 			_MapCheck
; Description: 		To check if $map is a map.
; Parameters:
; Return values: 	boolean
; Author: 			linkwork85@qq.com(GuangZhou, China)
;
Func _MapCheck(Const ByRef $map)
   __ensureMap($map)
   If @error Then
	  SetError(0)
	  Return False
   EndIf
   Return True
EndFunc
; ==> _MapCheck

; # Global Function # ===========================================================================================================
; Name: 			_MapClear
; Description:		To clear the map.
; Parameters:
; Return values:
; Author: 			linkwork85@qq.com(GuangZhou, China)
;
Func _MapClear(ByRef $map)
   Local $size = _MapSize($map)
   If ($size > 0) Then
	  Local $range = StringFormat('%i-%i', 1, $size)
	  _ArrayDelete($map[0], $range)
	  _ArrayDelete($map[1], $range)
   EndIf
EndFunc
; ==> _MapClear

; # Global Function # ===========================================================================================================
; Name: 			_MapContainsKey
; Description: 		To check if $map contains the key.
; Parameters:
; Return values: 	boolean
; Author: 			linkwork85@qq.com(GuangZhou, China)
;
Func _MapContainsKey(Const ByRef $map, $key)
   __ensureMap($map)
   __ensureKey($key)
   Local $index = __indexOfKey($map, $key)
   Return ($index > -1)
EndFunc
; ==> _MapContainsKey

; # Global Function # ===========================================================================================================
; Name: 			_MapContainsValue
; Description: 		To check if $map contains the value.
; Parameters:
; Return values: 	boolean
; Author: 			linkwork85@qq.com(GuangZhou, China)
;
Func _MapContainsValue(Const ByRef $map, $value)
   __ensureMap($map)
   Local $keys = $map[0]
   Local $size = UBound($keys) - 1
   Local $vals = $map[1]
   Local $item
   For $index = 1 To $size
	  $item = $vals[$index]
	  If ( _
		 ((VarGetType($item) == VarGetType($value)) And ($item == $value)) _
		 Or (_MapCheck($item) And _MapCheck($value) And _MapEqual($item, $value)) _
	  ) Then
		 Return True
	  EndIf
   Next
   Return False
EndFunc
; ==> _MapContainsValue

; # Global Function # ===========================================================================================================
; Name: 			_MapCreate
; Description:		To create a new map.
; Parameters:
; Return values: 	map
; Author: 			linkwork85@qq.com(GuangZhou, China)
;
Func _MapCreate()
   Local $keys = [$_UDS_KEY]
   Local $vals = [$_UDS_MAP]
   Local $map = [$keys, $vals]
   Return $map
EndFunc
; ==>_MapCreate

; # Global Function # ===========================================================================================================
; Name: 			_MapEqual
; Description:		To check if the two map is equal.
; Parameters:
;					$a: a map. It must not contains array element.
;					$b: a map. It must not contains array element.
; Return values: 	boolean
; Author: 			linkwork85@qq.com(GuangZhou, China)
;
Func _MapEqual($a, $b)
   Local $aSize = _MapSize($a)
   Local $bSize = _MapSize($b)
   If ($aSize == $bSize) Then
	  If ($aSize == 0) Then
		 Return True
	  Else
		 Local $aKeys = $a[0]
		 Local $aVals = $a[1]
		 Local $key, $aVal, $bVal
		 For $index = 1 To $aSize
			$key = $aKeys[$index]
			$aVal = $aVals[$index]
			$bVal = _MapGet($b, $key)
			If (($aVal == Null) And ($bVal == Null)) Then
			   ContinueLoop
			ElseIf ( _
			   (($aVal == Null) And ($bVal <> Null)) _
			   Or (($aVal <> Null) And ($bVal == Null)) _
			   Or (_MapCheck($aVal) <> _MapCheck($bVal)) _
			   Or (_MapCheck($aVal) And _MapCheck($bVal) And (Not _MapEqual($aVal, $bVal))) _
			   Or (VarGetType($aVal) <> VarGetType($bVal)) _
			   Or ($aVal <> $bVal)
			) Then
			   Return False
			EndIf
		 Next
		 Return True
	  EndIf
   Else
	  Return False
   EndIf
EndFunc
; ==> _MapEqual

; # Global Function # ===========================================================================================================
; Name: 			_MapGet
; Description: 		To get the value by the key.
; Parameters:
; Return values:
; Author: 			linkwork85@qq.com(GuangZhou, China)
;
Func _MapGet(Const ByRef $map, $key)
   __ensureMap($map)
   __ensureKey($key)
   Local $index = __indexOfKey($map, $key)
   If ($index > -1) Then
	  Local $vals = $map[1]
	  Return $vals[$index]
   EndIf
   Return Null
EndFunc
; ==> _MapGet

; # Global Function # ===========================================================================================================
; Name: 			_MapIsEmpty
; Description: 		To check if $map is empty.
; Parameters:
; Return values: 	boolean
; Author: 			linkwork85@qq.com(GuangZhou, China)
;
Func _MapIsEmpty(Const ByRef $map)
   __ensureMap($map)
   Local $keys = $map[0]
   Return (UBound($keys) == 1)
EndFunc
; ==> _MapIsEmpty

; # Global Function # ===========================================================================================================
; Name: 			_MapKeys
; Description: 		To get the array of all the keys.
; Parameters:
; Return values: 	array
; Author: 			linkwork85@qq.com(GuangZhou, China)
;
Func _MapKeys(Const ByRef $map)
   __ensureMap($map)
   Local $keys = $map[0]
   _ArrayDelete($keys, 0)
   Return $keys
EndFunc
; ==> _MapKeys

; # Global Function # ===========================================================================================================
; Name: 			_MapPut
; Description: 		To put the value.
; Parameters:
; Return values:
; Author: 			linkwork85@qq.com(GuangZhou, China)
;
Func _MapPut(ByRef $map, $key, $value)
   __ensureMap($map)
   __ensureKey($key)
   Local $index = __indexOfKey($map, $key)
   If ($index > -1) Then
	  __setItem($map[1], $index, $value)
   Else
	  _ArrayAdd($map[0], $key)
	  _ArrayAdd($map[1], $value)
   EndIf
EndFunc
; ==> _MapPut

; # Global Function # ===========================================================================================================
; Name: 			_MapRemove
; Description: 		To remove the item by the key.
; Parameters:
; Return values:
; Author: 			linkwork85@qq.com(GuangZhou, China)
;
Func _MapRemove(ByRef $map, $key)
   __ensureMap($map)
   __ensureKey($key)
   Local $index = __indexOfKey($map, $key)
   If ($index > -1) Then
	  _ArrayDelete($map[0], $index)
	  _ArrayDelete($map[1], $index)
   EndIf
   Return $index
EndFunc
; ==> _MapRemove

; # Global Function # ===========================================================================================================
; Name: 			_MapSize
; Description: 		To get the size of a map.
; Parameters:
; Return values:
; Author: 			linkwork85@qq.com(GuangZhou, China)
;
Func _MapSize(Const ByRef $map)
   __ensureMap($map)
   Local $keys = $map[0]
   Return (UBound($keys) - 1)
EndFunc
; ==> _MapSize

; # Internal Function # =========================================================================================================
; Name: 			__ensureMap
; Description: 		To ensure $map is a map.
; Parameters:
; Return values:
; Throws Error:		When $map is not a map.
; Author: 			linkwork85@qq.com(GuangZhou, China)
;
Func __ensureMap(Const ByRef $map)
   If (IsArray($map) And (UBound($map) == 2)) Then
	  Local $keys = $map[0]
	  Local $vals = $map[1]
	  If ( _
		 IsArray($keys) _
		 And IsArray($vals) _
		 And (UBound($keys) > 0) _
		 And (UBound($vals) > 0) _
		 And (UBound($keys) == UBound($vals)) _
		 And ($keys[0] == $_UDS_KEY) _
		 And ($vals[0] == $_UDS_MAP) _
	  ) Then
		 Return
	  EndIf
   EndIf
   SetError($_UDS_ERROR_NOT_MAP)
EndFunc

; # Internal Function # =========================================================================================================
; Name: 			__ensureKey
; Description: 		To ensure $key is a string.
; Parameters:
; Return values:
; Throws Error:
; Author: 			linkwork85@qq.com(GuangZhou, China)
;
Func __ensureKey($key)
   If ($key == Null) Or (Not IsString($key)) Then
	  SetError($_UDS_ERROR_ILLEGAL_KEY)
   EndIf
EndFunc

; # Internal Function # =========================================================================================================
; Name: 			__indexOfKey
; Description: 		To get the index by the key.
; Parameters:
;					$map: a legal map.
;					$key: a legal string key.
; Return values:
; Throws Error:
; Author: 			linkwork85@qq.com(GuangZhou, China)
;
Func __indexOfKey(Const ByRef $map, $key)
   Local $keys = $map[0]
   Local $size = UBound($keys) - 1
   Local $item
   For $index = 1 To $size
	  $item = $keys[$index]
	  If ($item == $key) Then
		 Return $index
	  EndIf
   Next
   Return -1;
EndFunc
; ==> __indexOfKey

; # Internal Function # =========================================================================================================
; Name: 			__setItem
; Description: 		To set the item.
; Parameters:
; Return values:
; Throws Error:
; Author: 			linkwork85@qq.com(GuangZhou, China)
;
Func __setItem(ByRef $array, $index, $value)
   $array[$index] = $value
EndFunc
; ==> __setItem

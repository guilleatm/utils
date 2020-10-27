# Utils

## Description

Useful functions for your lua project.

> For using the functions you have to have the utils.lua file in your project folder and remember to use the require 'utils' (with the correct path if the file is not with the main)

---

## Table to string

Converts a table to a string.  

Syntax:

```tableToString(table, separator, brackets)```

* **table**: The table you want to convert to a string.
* **separator**: The character (or string) that will appear between the elements of the table, default is a space ' ', but if you want to store the table into a lua file for loading it after, you might use a comma ',' and the dofile function. **optional**
* **brackets**: If true, the returned string will be like "{1, 2, 3}", if not "1, 2, 3". **optional**

### Example:

```lua
local myTable = {1, 2, 6, 9}
local myTable2 = {56, "Hello", 'world', aKey = 78, t = {4, 7, "Guitm"}}

local converted = tableToString(myTable, ',') -- converted = "1,2,6,9"
local converted2 = tableToString(myTable2, ' / ', true) -- converted2 = "{56 / "Hello" / "world" / aKey=78 / t={4 / 7 / "Guitm"}}"

print(converted)
print(converted2)
```

---

## String to table

Converts a string to a table. **This function does not support keys yet**

Syntax:

```stringToTable(string, separator)```

* **string**: The string that is going to be converted.
* **separator**: If the element between two values of the table is not a space ' ', you will have to specify wich one it is. **optional**

### Example:

```lua
local myString = "1, 2, 6, 9"
local myString2 = "56 'Hello' 'world' 78 {4 7 'Guitm'}"

local converted = stringToTable(myString, ',') -- converted = {1, 2, 6, 9}
local converted2 = stringToTable(myString2) -- converted2 = {56, "Hello", "world", 78, {4, 7, "Guitm"}}

for k, e in pairs(converted) do
	print(e)
end

print()

for k, e in pairs(converted2) do
	print(e)
end
```

---

## Binary search

This function returns the position of an element in an ordered list (table) in O(logN).  

Syntax:

```binarySearch(element, table)```

* **element**: The element we want to know it's position.
* **table**: The table where we are searching.

If you know between what indexes the element is, you can use the iStart and iEnd parameters but be carefull with this. For example if you know that the element is
in the first five elements (including the 5 element):

```binarySearch(myElement, myTable, nil, 5)```

Complete syntax:  
```binarySearch(element, table, iStart, iEnd)```

If there are duplicated elements in the table, the function will return 'randomly' one of the indexes (of the duplicated). If you want always the first in the table, you can use binarySearchAmplified()

### Example:

```lua
local t = {1,2,3,4,5,5,5,7,7,8,8,8,8,8,9,234}

binarySearch(4, t) -- 4
binarySearch(9, t) -- 15
binarySearch(46, t) -- nil
binarySearch(7, t) -- It can be 8 or 9, depending on the table length

```

---

## Amplified binary search

Binary search with some useful parameters. 

Syntax:

```binarySearch(element, table, toInsert, whereToLook)```

* **element**: The element we want to know it's position.
* **table**: The table where we are searching.
* **toInsert**: If true, the function will return the index where the element have to be inserted for keeping the table sorted. You can use table.insert(table, indexReturned, element). **optional**
* **whereToLook**: Imagine you have a sorted list (table) of objects like: objectPerson = {weight = {pounds, kilograms}}. And you want to have it sorted by weight in kilograms (obviusly if you sort by pounds, the result will be the same, it's just an exmple). So *whereToLook* will be a table with the path (keys) where the function have to look. For this example, it will be {'weight', 'kilograms'} **optional**

You can use iStart and iEnd like in binarySearch()

### Example:

```lua
local t = {1,2,3,4,5,5,5,7,7,8,8,8,8,8,9,234}
local t2 = {{a=3}, {a = 3}, {a = 4}}

binarySearchAmplified(4, t) -- 4
binarySearchAmplified(9, t) -- 15
binarySearchAmplified(46, t) -- nil
binarySearchAmplified(46, t, true) -- 16

print(binarySearchAmplified(3, t2, true, {'a'})) -- 1
print(binarySearchAmplified(8, t2, true, {'a'})) -- 4

```
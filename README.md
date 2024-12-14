# secOS
a simple secure amd64 operating system
# How to run?
Windows:
    run
Linux:
    make run
# VGA Display mode
    1.VGA display mode supports 80*25 total characters, 80 character and wide 25 character height.
    2.supports total 16 colors
    3.in vga mode each character is 2 byte(word).
    4.lower byte is character(extented ascii(0-255)) byte
    5.higher byte is color byte
    6. VGA address starts in 0xb8000
<table>
<tr>
<td>Color</td>
<td>Value</td>
</tr>
<tr>
    <td>Black</td>
    <td>0x0</td>
</tr>
<tr>
    <td>Blue</td>
    <td>0x1</td>
</tr>
<tr>
    <td>Green</td>
    <td>0x2</td>
</tr>
<tr>
    <td>Cyan</td>
    <td>0x3</td>
</tr>
<tr>
    <td>Red</td>
    <td>0x4</td>
</tr>
<tr>
    <td>Magenta</td>
    <td>0x5</td>
</tr>
<tr>
    <td>Brown</td>
    <td>0x6</td>
</tr>
<tr>
    <td>Light gray</td>
    <td>0x7</td>
</tr>
<tr>
    <td>Dark gray</td>
    <td>0x8</td>
</tr>
<tr>
    <td>Light blue</td>
    <td>0x9</td>
</tr>
<tr>
    <td>Light green</td>
    <td>0xa</td>
</tr>
<tr>
    <td>Light cyan</td>
    <td>0xb</td>
</tr>
<tr>
    <td>Light red</td>
    <td>0xc</td>
</tr>
<tr>
    <td>Light magenta</td>
    <td>0xd</td>
</tr>
<tr>
    <td>Yellow</td>
    <td>0xe</td>
</tr>
<tr>
    <td>Bright white</td>
    <td>0xf</td>
</tr>
</table>

# string escaping & unescaping
cx = {
    0x00000000      '\0'        "\\0"
    0x00000001      '\x01'      "\\x01"
    0x00000006      '\x06'      "\\x06"
    0x00000007      '\a'        "\\a"
    0x00000008      '\b'        "\\b"
    0x00000009      '\t'        "\\t"
    0x0000000a      '\n'        "\\n"
    0x0000000b      '\v'        "\\v"
    0x0000000c      '\f'        "\\f"
    0x0000000d      '\r'        "\\r"
    0x0000000e      '\x0e'      "\\x0e"
    0x0000001a      '\x1a'      "\\x1a"
    0x0000001b      '\e'        "\\e"
    0x0000001c      '\x1c'      "\\x1c"
    0x0000001f      '\x1f'      "\\x1f"
    0x00000020      ' '         " "
    0x0000002f      '/'         "/"
    0x00000030      '0'         "0"
    0x00000039      '9'         "9"
    0x0000003a      ':'         ":"
    0x00000040      '@'         "@"
    0x00000041      'A'         "A"
    0x0000005a      'Z'         "Z"
    0x0000005b      '['         "["
    0x00000060      '`'         "`"
    0x00000061      'a'         "a"
    0x0000007a      'z'         "z"
    0x0000007b      '{'         "{"
    0x0000007e      '~'         "~"
    0x0000007f      '\x7f'      "\\x7f"
    0x000000bf      '\ubf'      "\\ubf"
    0x000000ff      '\uff'      "\\uff"
    0x00000100      '\u100'     "\\u100"
    0x000001ff      '\u1ff'     "\\u1ff"
    0x00000fff      '\ufff'     "\\ufff"
    0x00001000      '\u1000'    "\\u1000"
    0x00001fff      '\u1fff'    "\\u1fff"
    0x0000ffff      '\uffff'    "\\uffff"
    0x00010000      '\U10000'   "\\U10000"
    0x0001ffff      '\U1ffff'   "\\U1ffff"
    0x0002ffff      '\U2ffff'   "\\U2ffff"
    0x00030000      '\U30000'   "\\U30000"
    0x000dffff      '\Udffff'   "\\Udffff"
    0x000e0000      '\Ue0000'   "\\Ue0000"
    0x000effff      '\Ueffff'   "\\Ueffff"
    0x000f0000      '\Uf0000'   "\\Uf0000"
    0x000fffff      '\Ufffff'   "\\Ufffff"
    0x00100000      '\U100000'  "\\U100000"
    0x0010ffff      '\U10ffff'  "\\U10ffff"
}

for i = 1:size(cx,1)
    @test cx[i,1] == cx[i,2]
    @test string(cx[i,2]) == unescape_string(cx[i,3])
    if isascii(cx[i,2]) || !isprint(cx[i,2])
        @test cx[i,3] == escape_string(string(cx[i,2]))
    end
    for j = 1:size(cx,1)
        str = string(cx[i,2], cx[j,2])
        @test str == unescape_string(escape_string(str))
    end
end

for i = 0:0x7f, p = {"","\0","x","xxx","\x7f","\uFF","\uFFF",
                     "\uFFFF","\U10000","\U10FFF","\U10FFFF"}
    c = char(i)
    cp = string(c,p)
    op = string(char(div(i,8)), oct(i%8), p)
    hp = string(char(div(i,16)), hex(i%16), p)
    @test string(unescape_string(string("\\",oct(i,1),p))) == cp
    @test string(unescape_string(string("\\",oct(i,2),p))) == cp
    @test string(unescape_string(string("\\",oct(i,3),p))) == cp
    @test string(unescape_string(string("\\",oct(i,4),p))) == op
    @test string(unescape_string(string("\\x",hex(i,1),p))) == cp
    @test string(unescape_string(string("\\x",hex(i,2),p))) == cp
    @test string(unescape_string(string("\\x",hex(i,3),p))) == hp
end

@test "\z" == unescape_string("\z") == "z"
@test "\X" == unescape_string("\X") == "X"
@test "\AbC" == unescape_string("\AbC") == "AbC"

@test "\0" == unescape_string("\\0")
@test "\1" == unescape_string("\\1")
@test "\7" == unescape_string("\\7")
@test "\0x" == unescape_string("\\0x")
@test "\1x" == unescape_string("\\1x")
@test "\7x" == unescape_string("\\7x")
@test "\00" == unescape_string("\\00")
@test "\01" == unescape_string("\\01")
@test "\07" == unescape_string("\\07")
@test "\70" == unescape_string("\\70")
@test "\71" == unescape_string("\\71")
@test "\77" == unescape_string("\\77")
@test "\00x" == unescape_string("\\00x")
@test "\01x" == unescape_string("\\01x")
@test "\07x" == unescape_string("\\07x")
@test "\70x" == unescape_string("\\70x")
@test "\71x" == unescape_string("\\71x")
@test "\77x" == unescape_string("\\77x")
@test "\000" == unescape_string("\\000")
@test "\001" == unescape_string("\\001")
@test "\007" == unescape_string("\\007")
@test "\070" == unescape_string("\\070")
@test "\071" == unescape_string("\\071")
@test "\077" == unescape_string("\\077")
@test "\170" == unescape_string("\\170")
@test "\171" == unescape_string("\\171")
@test "\177" == unescape_string("\\177")
@test "\0001" == unescape_string("\\0001")
@test "\0011" == unescape_string("\\0011")
@test "\0071" == unescape_string("\\0071")
@test "\0701" == unescape_string("\\0701")
@test "\0711" == unescape_string("\\0711")
@test "\0771" == unescape_string("\\0771")
@test "\1701" == unescape_string("\\1701")
@test "\1711" == unescape_string("\\1711")
@test "\1771" == unescape_string("\\1771")

@test "\x0" == unescape_string("\\x0")
@test "\x1" == unescape_string("\\x1")
@test "\xf" == unescape_string("\\xf")
@test "\xF" == unescape_string("\\xF")
@test "\x0x" == unescape_string("\\x0x")
@test "\x1x" == unescape_string("\\x1x")
@test "\xfx" == unescape_string("\\xfx")
@test "\xFx" == unescape_string("\\xFx")
@test "\x00" == unescape_string("\\x00")
@test "\x01" == unescape_string("\\x01")
@test "\x0f" == unescape_string("\\x0f")
@test "\x0F" == unescape_string("\\x0F")

# integer parsing
@test is(parseint(Int32,"0",36),int32(0))
@test is(parseint(Int32,"1",36),int32(1))
@test is(parseint(Int32,"9",36),int32(9))
@test is(parseint(Int32,"A",36),int32(10))
@test is(parseint(Int32,"a",36),int32(10))
@test is(parseint(Int32,"B",36),int32(11))
@test is(parseint(Int32,"b",36),int32(11))
@test is(parseint(Int32,"F",36),int32(15))
@test is(parseint(Int32,"f",36),int32(15))
@test is(parseint(Int32,"Z",36),int32(35))
@test is(parseint(Int32,"z",36),int32(35))

@test parseint("0") == 0
@test parseint("-0") == 0
@test parseint("1") == 1
@test parseint("-1") == -1
@test parseint("9") == 9
@test parseint("-9") == -9
@test parseint("10") == 10
@test parseint("-10") == -10
@test parseint(Int64,"3830974272") == 3830974272
@test parseint(Int64,"-3830974272") == -3830974272
@test parseint('3') == 3
@test parseint('3', 8) == 3

parsebin(s) = parseint(s,2)
parseoct(s) = parseint(s,8)
parsehex(s) = parseint(s,16)

@test parsebin("0") == 0
@test parsebin("-0") == 0
@test parsebin("1") == 1
@test parsebin("-1") == -1
@test parsebin("10") == 2
@test parsebin("-10") == -2
@test parsebin("11") == 3
@test parsebin("-11") == -3
@test parsebin("1111000011110000111100001111") == 252645135
@test parsebin("-1111000011110000111100001111") == -252645135

@test parseoct("0") == 0
@test parseoct("-0") == 0
@test parseoct("1") == 1
@test parseoct("-1") == -1
@test parseoct("7") == 7
@test parseoct("-7") == -7
@test parseoct("10") == 8
@test parseoct("-10") == -8
@test parseoct("11") == 9
@test parseoct("-11") == -9
@test parseoct("72") == 58
@test parseoct("-72") == -58
@test parseoct("3172207320") == 434704080
@test parseoct("-3172207320") == -434704080

@test parsehex("0") == 0
@test parsehex("-0") == 0
@test parsehex("1") == 1
@test parsehex("-1") == -1
@test parsehex("9") == 9
@test parsehex("-9") == -9
@test parsehex("a") == 10
@test parsehex("-a") == -10
@test parsehex("f") == 15
@test parsehex("-f") == -15
@test parsehex("10") == 16
@test parsehex("-10") == -16
@test parsehex("0BADF00D") == 195948557
@test parsehex("-0BADF00D") == -195948557
@test parseint(Int64,"BADCAB1E",16) == 3135023902
@test parseint(Int64,"-BADCAB1E",16) == -3135023902
@test parseint(Int64,"CafeBabe",16) == 3405691582
@test parseint(Int64,"-CafeBabe",16) == -3405691582
@test parseint(Int64,"DeadBeef",16) == 3735928559
@test parseint(Int64,"-DeadBeef",16) == -3735928559

@test parseint("2\n") == 2
@test parseint("   2 \n ") == 2
@test parseint(" 2 ") == 2
@test parseint("2 ") == 2
@test parseint(" 2") == 2
@test parseint("+2\n") == 2
@test parseint("-2") == -2
@test_throws parseint("   2 \n 0")
@test_throws parseint("2x")
@test_throws parseint("-")

@test parseint("1234") == 1234
@test parseint("0x1234") == 0x1234
@test parseint("0o1234") == 0o1234
@test parseint("0b1011") == 0b1011
@test parseint("-1234") == -1234
@test parseint("-0x1234") == -int(0x1234)
@test parseint("-0o1234") == -int(0o1234)
@test parseint("-0b1011") == -int(0b1011)

for T in (Int8,Uint8,Int16,Uint16,Int32,Uint32,Int64,Uint64)#,Int128,Uint128) ## FIXME: #4905
    @test parseint(T,string(typemin(T))) == typemin(T)
    @test parseint(T,string(typemax(T))) == typemax(T)
    @test_throws parseint(T,string(big(typemin(T))-1))
    @test_throws parseint(T,string(big(typemax(T))+1))
end

# string manipulation
@test strip("\t  hi   \n") == "hi"

# some test strings
astr = "Hello, world.\n"
u8str = "∀ ε > 0, ∃ δ > 0: |x-y| < δ ⇒ |f(x)-f(y)| < ε"

# ascii search
for str in {astr, Base.GenericString(astr)}
    @test search(str, 'x') == 0
    @test search(str, '\0') == 0
    @test search(str, '\u80') == 0
    @test search(str, '∀') == 0
    @test search(str, 'H') == 1
    @test search(str, 'l') == 3
    @test search(str, 'l', 4) == 4
    @test search(str, 'l', 5) == 11
    @test search(str, 'l', 12) == 0
    @test search(str, ',') == 6
    @test search(str, ',', 7) == 0
    @test search(str, '\n') == 14
    @test search(str, '\n', 15) == 0
end

# ascii rsearch
for str in {astr}
    @test rsearch(str, 'x') == 0
    @test rsearch(str, '\0') == 0
    @test rsearch(str, '\u80') == 0
    @test rsearch(str, '∀') == 0
    @test rsearch(str, 'H') == 1
    @test rsearch(str, 'H', 0) == 0
    @test rsearch(str, 'l') == 11
    @test rsearch(str, 'l', 5) == 4
    @test rsearch(str, 'l', 4) == 4
    @test rsearch(str, 'l', 3) == 3
    @test rsearch(str, 'l', 2) == 0
    @test rsearch(str, ',') == 6
    @test rsearch(str, ',', 5) == 0
    @test rsearch(str, '\n') == 14
end

# utf-8 search
for str in {u8str, Base.GenericString(u8str)}
    @test search(str, 'z') == 0
    @test search(str, '\0') == 0
    @test search(str, '\u80') == 0
    @test search(str, '∄') == 0
    @test search(str, '∀') == 1
    @test search(str, '∀', 2) == 0
    @test search(str, '∃') == 13
    @test search(str, '∃', 14) == 0
    @test search(str, 'x') == 26
    @test search(str, 'x', 27) == 43
    @test search(str, 'x', 44) == 0
    @test search(str, 'δ') == 17
    @test search(str, 'δ', 18) == 33
    @test search(str, 'δ', 34) == 0
    @test search(str, 'ε') == 5
    @test search(str, 'ε', 6) == 54
    @test search(str, 'ε', 55) == 0
end

# utf-8 rsearch
for str in {u8str}
    @test rsearch(str, 'z') == 0
    @test rsearch(str, '\0') == 0
    @test rsearch(str, '\u80') == 0
    @test rsearch(str, '∄') == 0
    @test rsearch(str, '∀') == 1
    @test rsearch(str, '∀', 0) == 0
    @test rsearch(str, '∃') == 13
    @test rsearch(str, '∃', 14) == 13
    @test rsearch(str, '∃', 13) == 13
    @test rsearch(str, '∃', 12) == 0
    @test rsearch(str, 'x') == 43
    @test rsearch(str, 'x', 42) == 26
    @test rsearch(str, 'x', 25) == 0
    @test rsearch(str, 'δ') == 33
    @test rsearch(str, 'δ', 32) == 17
    @test rsearch(str, 'δ', 16) == 0
    @test rsearch(str, 'ε') == 54
    @test rsearch(str, 'ε', 53) == 5
    @test rsearch(str, 'ε', 4) == 0
end

# string search with a single-char string
@test search(astr, "x") == 0:-1
@test search(astr, "H") == 1:1
@test search(astr, "H", 2) == 0:-1
@test search(astr, "l") == 3:3
@test search(astr, "l", 4) == 4:4
@test search(astr, "l", 5) == 11:11
@test search(astr, "l", 12) == 0:-1
@test search(astr, "\n") == 14:14
@test search(astr, "\n", 15) == 0:-1

@test search(u8str, "z") == 0:-1
@test search(u8str, "∄") == 0:-1
@test search(u8str, "∀") == 1:1
@test search(u8str, "∀", 4) == 0:-1
@test search(u8str, "∃") == 13:13
@test search(u8str, "∃", 16) == 0:-1
@test search(u8str, "x") == 26:26
@test search(u8str, "x", 27) == 43:43
@test search(u8str, "x", 44) == 0:-1
@test search(u8str, "ε") == 5:5
@test search(u8str, "ε", 7) == 54:54
@test search(u8str, "ε", 56) == 0:-1

# string rsearch with a single-char string
@test rsearch(astr, "x") == 0:-1
@test rsearch(astr, "H") == 1:1
@test rsearch(astr, "H", 2) == 1:1
@test rsearch(astr, "H", 0) == 0:-1
@test rsearch(astr, "l") == 11:11
@test rsearch(astr, "l", 10) == 4:4
@test rsearch(astr, "l", 4) == 4:4
@test rsearch(astr, "l", 3) == 3:3
@test rsearch(astr, "l", 2) == 0:-1
@test rsearch(astr, "\n") == 14:14
@test rsearch(astr, "\n", 13) == 0:-1

@test rsearch(u8str, "z") == 0:-1
@test rsearch(u8str, "∄") == 0:-1
@test rsearch(u8str, "∀") == 1:1
@test rsearch(u8str, "∀", 0) == 0:-1
#TODO: setting the limit in the middle of a wide char
#      makes search fail but rsearch succeed.
#      Should rsearch fail as well?
#@test rsearch(u8str, "∀", 2) == 0:-1 # gives 1:3
@test rsearch(u8str, "∃") == 13:13
@test rsearch(u8str, "∃", 12) == 0:-1
@test rsearch(u8str, "x") == 43:43
@test rsearch(u8str, "x", 42) == 26:26
@test rsearch(u8str, "x", 25) == 0:-1
@test rsearch(u8str, "ε") == 54:54
@test rsearch(u8str, "ε", 53) == 5:5
@test rsearch(u8str, "ε", 4) == 0:-1

# string search with a single-char regex
@test search(astr, r"x") == 0:-1
@test search(astr, r"H") == 1:1
@test search(astr, r"H", 2) == 0:-1
@test search(astr, r"l") == 3:3
@test search(astr, r"l", 4) == 4:4
@test search(astr, r"l", 5) == 11:11
@test search(astr, r"l", 12) == 0:-1
@test search(astr, r"\n") == 14:14
@test search(astr, r"\n", 15) == 0:-1
@test search(u8str, r"z") == 0:-1
@test search(u8str, r"∄") == 0:-1
@test search(u8str, r"∀") == 1:1
@test search(u8str, r"∀", 4) == 0:-1
@test search(u8str, r"∀") == search(u8str, r"\u2200")
@test search(u8str, r"∀", 4) == search(u8str, r"\u2200", 4)
@test search(u8str, r"∃") == 13:13
@test search(u8str, r"∃", 16) == 0:-1
@test search(u8str, r"x") == 26:26
@test search(u8str, r"x", 27) == 43:43
@test search(u8str, r"x", 44) == 0:-1
@test search(u8str, r"ε") == 5:5
@test search(u8str, r"ε", 7) == 54:54
@test search(u8str, r"ε", 56) == 0:-1
for i = 1:endof(astr)
    @test search(astr, r"."s, i) == i:i
end
for i = 1:endof(u8str)
    if isvalid(u8str,i)
        @test search(u8str, r"."s, i) == i:i
    end
end

# string search with a zero-char string
for i = 1:endof(astr)
    @test search(astr, "", i) == i:i-1
end
for i = 1:endof(u8str)
    @test search(u8str, "", i) == i:i-1
end
@test search("", "") == 1:0

# string rsearch with a zero-char string
for i = 1:endof(astr)
    @test rsearch(astr, "", i) == i:i-1
end
for i = 1:endof(u8str)
    @test rsearch(u8str, "", i) == i:i-1
end
@test rsearch("", "") == 1:0

# string search with a zero-char regex
for i = 1:endof(astr)
    @test search(astr, r"", i) == i:i-1
end
for i = 1:endof(u8str)
    # TODO: should regex search fast-forward invalid indices?
    if isvalid(u8str,i)
        @test search(u8str, r""s, i) == i:i-1
    end
end

# string search with a two-char string literal
@test search("foo,bar,baz", "xx") == 0:-1
@test search("foo,bar,baz", "fo") == 1:2
@test search("foo,bar,baz", "fo", 3) == 0:-1
@test search("foo,bar,baz", "oo") == 2:3
@test search("foo,bar,baz", "oo", 4) == 0:-1
@test search("foo,bar,baz", "o,") == 3:4
@test search("foo,bar,baz", "o,", 5) == 0:-1
@test search("foo,bar,baz", ",b") == 4:5
@test search("foo,bar,baz", ",b", 6) == 8:9
@test search("foo,bar,baz", ",b", 10) == 0:-1
@test search("foo,bar,baz", "az") == 10:11
@test search("foo,bar,baz", "az", 12) == 0:-1

# string rsearch with a two-char string literal
@test rsearch("foo,bar,baz", "xx") == 0:-1
@test rsearch("foo,bar,baz", "fo") == 1:2
@test rsearch("foo,bar,baz", "fo", 1) == 0:-1
@test rsearch("foo,bar,baz", "oo") == 2:3
@test rsearch("foo,bar,baz", "oo", 2) == 0:-1
@test rsearch("foo,bar,baz", "o,") == 3:4
@test rsearch("foo,bar,baz", "o,", 1) == 0:-1
@test rsearch("foo,bar,baz", ",b") == 8:9
@test rsearch("foo,bar,baz", ",b", 6) == 4:5
@test rsearch("foo,bar,baz", ",b", 3) == 0:-1
@test rsearch("foo,bar,baz", "az") == 10:11
@test rsearch("foo,bar,baz", "az", 10) == 0:-1

# array rsearch
@test rsearch(Uint8[1,2,3],Uint8[2,3],3) == 2:3
@test rsearch(Uint8[1,2,3],Uint8[2,3],1) == 0:-1

# string search with a two-char regex
@test search("foo,bar,baz", r"xx") == 0:-1
@test search("foo,bar,baz", r"fo") == 1:2
@test search("foo,bar,baz", r"fo", 3) == 0:-1
@test search("foo,bar,baz", r"oo") == 2:3
@test search("foo,bar,baz", r"oo", 4) == 0:-1
@test search("foo,bar,baz", r"o,") == 3:4
@test search("foo,bar,baz", r"o,", 5) == 0:-1
@test search("foo,bar,baz", r",b") == 4:5
@test search("foo,bar,baz", r",b", 6) == 8:9
@test search("foo,bar,baz", r",b", 10) == 0:-1
@test search("foo,bar,baz", r"az") == 10:11
@test search("foo,bar,baz", r"az", 12) == 0:-1

# split
@test isequal(split("foo,bar,baz", 'x'), ["foo,bar,baz"])
@test isequal(split("foo,bar,baz", ','), ["foo","bar","baz"])
@test isequal(split("foo,bar,baz", ","), ["foo","bar","baz"])
@test isequal(split("foo,bar,baz", r","), ["foo","bar","baz"])
@test isequal(split("foo,bar,baz", ',', 0), ["foo","bar","baz"])
@test isequal(split("foo,bar,baz", ',', 1), ["foo,bar,baz"])
@test isequal(split("foo,bar,baz", ',', 2), ["foo","bar,baz"])
@test isequal(split("foo,bar,baz", ',', 3), ["foo","bar","baz"])
@test isequal(split("foo,bar", "o,b"), ["fo","ar"])

@test isequal(split("", ','), [""])
@test isequal(split(",", ','), ["",""])
@test isequal(split(",,", ','), ["","",""])
@test isequal(split("", ',', false), [])
@test isequal(split(",", ',', false), [])
@test isequal(split(",,", ',', false), [])

@test isequal(split("a b c"), ["a","b","c"])
@test isequal(split("a  b \t c\n"), ["a","b","c"])

@test isequal(rsplit("foo,bar,baz", 'x'), ["foo,bar,baz"])
@test isequal(rsplit("foo,bar,baz", ','), ["foo","bar","baz"])
@test isequal(rsplit("foo,bar,baz", ","), ["foo","bar","baz"])
@test isequal(rsplit("foo,bar,baz", ',', 0), ["foo","bar","baz"])
@test isequal(rsplit("foo,bar,baz", ',', 1), ["foo,bar,baz"])
@test isequal(rsplit("foo,bar,baz", ',', 2), ["foo,bar","baz"])
@test isequal(rsplit("foo,bar,baz", ',', 3), ["foo","bar","baz"])
@test isequal(rsplit("foo,bar", "o,b"), ["fo","ar"])

@test isequal(rsplit("", ','), [""])
@test isequal(rsplit(",", ','), ["",""])
@test isequal(rsplit(",,", ','), ["","",""])
@test isequal(rsplit(",,", ',', 2), [",",""])
@test isequal(rsplit("", ',', false), [])
@test isequal(rsplit(",", ',', false), [])
@test isequal(rsplit(",,", ',', false), [])

#@test isequal(rsplit("a b c"), ["a","b","c"])
#@test isequal(rsplit("a  b \t c\n"), ["a","b","c"])

let str = "a.:.ba..:..cba.:.:.dcba.:."
@test isequal(split(str, ".:."), ["a","ba.",".cba",":.dcba",""])
@test isequal(split(str, ".:.", false), ["a","ba.",".cba",":.dcba"])
@test isequal(split(str, ".:."), ["a","ba.",".cba",":.dcba",""])
@test isequal(split(str, r"\.(:\.)+"), ["a","ba.",".cba","dcba",""])
@test isequal(split(str, r"\.(:\.)+", false), ["a","ba.",".cba","dcba"])
@test isequal(split(str, r"\.+:\.+"), ["a","ba","cba",":.dcba",""])
@test isequal(split(str, r"\.+:\.+", false), ["a","ba","cba",":.dcba"])

@test isequal(rsplit(str, ".:."), ["a","ba.",".cba.:","dcba",""])
@test isequal(rsplit(str, ".:.", false), ["a","ba.",".cba.:","dcba"])
@test isequal(rsplit(str, ".:.", 2), ["a.:.ba..:..cba.:.:.dcba", ""])
@test isequal(rsplit(str, ".:.", 3), ["a.:.ba..:..cba.:", "dcba", ""])
@test isequal(rsplit(str, ".:.", 4), ["a.:.ba.", ".cba.:", "dcba", ""])
@test isequal(rsplit(str, ".:.", 5), ["a", "ba.", ".cba.:", "dcba", ""])
@test isequal(rsplit(str, ".:.", 6), ["a", "ba.", ".cba.:", "dcba", ""])
end

# zero-width splits
@test isequal(rsplit("", ""), [""])

@test isequal(split("", ""), [""])
@test isequal(split("", r""), [""])
@test isequal(split("abc", ""), ["a","b","c"])
@test isequal(split("abc", r""), ["a","b","c"])
@test isequal(split("abcd", r"b?"), ["a","c","d"])
@test isequal(split("abcd", r"b*"), ["a","c","d"])
@test isequal(split("abcd", r"b+"), ["a","cd"])
@test isequal(split("abcd", r"b?c?"), ["a","d"])
@test isequal(split("abcd", r"[bc]?"), ["a","","d"])
@test isequal(split("abcd", r"a*"), ["","b","c","d"])
@test isequal(split("abcd", r"a+"), ["","bcd"])
@test isequal(split("abcd", r"d*"), ["a","b","c",""])
@test isequal(split("abcd", r"d+"), ["abc",""])
@test isequal(split("abcd", r"[ad]?"), ["","b","c",""])

# replace
@test replace("foobar", 'o', '0') == "f00bar"
@test replace("foobar", 'o', '0', 1) == "f0obar"
@test replace("foobar", 'o', "") == "fbar"
@test replace("foobar", 'o', "", 1) == "fobar"
@test replace("foobar", 'f', 'F') == "Foobar"
@test replace("foobar", 'r', 'R') == "foobaR"

@test replace("foofoofoo", "foo", "bar") == "barbarbar"
@test replace("foobarfoo", "foo", "baz") == "bazbarbaz"
@test replace("barfoofoo", "foo", "baz") == "barbazbaz"

@test replace("", "", "") == ""
@test replace("", "", "x") == "x"
@test replace("", "x", "y") == ""

@test replace("abcd", "", "^") == "^a^b^c^d^"
@test replace("abcd", "b", "^") == "a^cd"
@test replace("abcd", r"b?", "^") == "^a^c^d^"
@test replace("abcd", r"b+", "^") == "a^cd"
@test replace("abcd", r"b?c?", "^") == "^a^d^"
@test replace("abcd", r"[bc]?", "^") == "^a^^d^"

@test replace("foobarfoo", r"(fo|ba)", "xx") == "xxoxxrxxo"
@test replace("foobarfoo", r"(foo|ba)", "bar") == "barbarrbar"

@test replace("foobar", 'o', 'ø') == "føøbar"
@test replace("foobar", 'o', 'ø', 1) == "føobar"
@test replace("føøbar", 'ø', 'o') == "foobar"
@test replace("føøbar", 'ø', 'o', 1) == "foøbar"
@test replace("føøbar", 'ø', 'ö') == "fööbar"
@test replace("føøbar", 'ø', 'ö', 1) == "föøbar"
@test replace("føøbar", 'ø', "") == "fbar"
@test replace("føøbar", 'ø', "", 1) == "føbar"
@test replace("føøbar", 'f', 'F') == "Føøbar"
@test replace("ḟøøbar", 'ḟ', 'F') == "Føøbar"
@test replace("føøbar", 'f', 'Ḟ') == "Ḟøøbar"
@test replace("ḟøøbar", 'ḟ', 'Ḟ') == "Ḟøøbar"
@test replace("føøbar", 'r', 'R') == "føøbaR"
@test replace("føøbaṙ", 'ṙ', 'R') == "føøbaR"
@test replace("føøbar", 'r', 'Ṙ') == "føøbaṘ"
@test replace("føøbaṙ", 'ṙ', 'Ṙ') == "føøbaṘ"

@test replace("ḟøøḟøøḟøø", "ḟøø", "bar") == "barbarbar"
@test replace("ḟøøbarḟøø", "ḟøø", "baz") == "bazbarbaz"
@test replace("barḟøøḟøø", "ḟøø", "baz") == "barbazbaz"

@test replace("foofoofoo", "foo", "ƀäṙ") == "ƀäṙƀäṙƀäṙ"
@test replace("fooƀäṙfoo", "foo", "baz") == "bazƀäṙbaz"
@test replace("ƀäṙfoofoo", "foo", "baz") == "ƀäṙbazbaz"

@test replace("foofoofoo", "foo", "bar") == "barbarbar"
@test replace("foobarfoo", "foo", "ƀäż") == "ƀäżbarƀäż"
@test replace("barfoofoo", "foo", "ƀäż") == "barƀäżƀäż"

@test replace("ḟøøḟøøḟøø", "ḟøø", "ƀäṙ") == "ƀäṙƀäṙƀäṙ"
@test replace("ḟøøƀäṙḟøø", "ḟøø", "baz") == "bazƀäṙbaz"
@test replace("ƀäṙḟøøḟøø", "ḟøø", "baz") == "ƀäṙbazbaz"

@test replace("ḟøøḟøøḟøø", "ḟøø", "bar") == "barbarbar"
@test replace("ḟøøbarḟøø", "ḟøø", "ƀäż") == "ƀäżbarƀäż"
@test replace("barḟøøḟøø", "ḟøø", "ƀäż") == "barƀäżƀäż"

@test replace("ḟøøḟøøḟøø", "ḟøø", "ƀäṙ") == "ƀäṙƀäṙƀäṙ"
@test replace("ḟøøƀäṙḟøø", "ḟøø", "ƀäż") == "ƀäżƀäṙƀäż"
@test replace("ƀäṙḟøøḟøø", "ḟøø", "ƀäż") == "ƀäṙƀäżƀäż"

@test replace("", "", "ẍ") == "ẍ"
@test replace("", "ẍ", "ÿ") == ""

@test replace("äƀçđ", "", "π") == "πäπƀπçπđπ"
@test replace("äƀçđ", "ƀ", "π") == "äπçđ"
@test replace("äƀçđ", r"ƀ?", "π") == "πäπçπđπ"
@test replace("äƀçđ", r"ƀ+", "π") == "äπçđ"
@test replace("äƀçđ", r"ƀ?ç?", "π") == "πäπđπ"
@test replace("äƀçđ", r"[ƀç]?", "π") == "πäππđπ"

@test replace("foobarfoo", r"(fo|ba)", "ẍẍ") == "ẍẍoẍẍrẍẍo"

@test replace("ḟøøbarḟøø", r"(ḟø|ba)", "xx") == "xxøxxrxxø"
@test replace("ḟøøbarḟøø", r"(ḟøø|ba)", "bar") == "barbarrbar"

@test replace("fooƀäṙfoo", r"(fo|ƀä)", "xx") == "xxoxxṙxxo"
@test replace("fooƀäṙfoo", r"(foo|ƀä)", "ƀäṙ") == "ƀäṙƀäṙṙƀäṙ"

@test replace("ḟøøƀäṙḟøø", r"(ḟø|ƀä)", "xx") == "xxøxxṙxxø"
@test replace("ḟøøƀäṙḟøø", r"(ḟøø|ƀä)", "ƀäṙ") == "ƀäṙƀäṙṙƀäṙ"


# {begins,ends}with
@test beginswith("abcd", 'a')
@test beginswith("abcd", "a")
@test beginswith("abcd", "ab")
@test !beginswith("ab", "abcd")
@test !beginswith("abcd", "bc")
@test endswith("abcd", 'd')
@test endswith("abcd", "d")
@test endswith("abcd", "cd")
@test !endswith("abcd", "dc")
@test !endswith("cd", "abcd")

# RepStrings and SubStrings
u8str2 = u8str^2
len_u8str = length(u8str)
slen_u8str = length(u8str)
len_u8str2 = length(u8str2)
slen_u8str2 = length(u8str2)

@test len_u8str2 == 2 * len_u8str
@test slen_u8str2 == 2 * slen_u8str

u8str2plain = utf8(u8str2)

for i1 = 1:length(u8str2)
    if !isvalid(u8str2, i1); continue; end
    for i2 = i1:length(u8str2)
        if !isvalid(u8str2, i2); continue; end
        @test length(u8str2[i1:i2]) == length(u8str2plain[i1:i2])
        @test length(u8str2[i1:i2]) == length(u8str2plain[i1:i2])
        @test u8str2[i1:i2] == u8str2plain[i1:i2]
    end
end

str = "aa\u2200\u2222bb"
u = SubString(str, 3, 6)
@test length(u)==2
b = IOBuffer()
write(b, u)
@test takebuf_string(b) == "\u2200\u2222"

str = "føøbar"
u = SubString(str, 4, 3)
@test length(u)==0
b = IOBuffer()
write(b, u)
@test takebuf_string(b) == ""

str = "føøbar"
u = SubString(str, 10, 10)
@test length(u)==0
b = IOBuffer()
write(b, u)
@test takebuf_string(b) == ""

@test replace("\u2202", '*', '\0') == "\u2202"

# quotes + interpolation (issue #455)
@test "$("string")" == "string"
arr = ["a","b","c"]
@test "[$(join(arr, " - "))]" == "[a - b - c]"

# string iteration, and issue #1454
str = "é"
str_a = [str...]
@test length(str_a)==1
@test str_a[1] == str[1]

str = "s\u2200"
@test str[1:end] == str

# triple-quote delimited strings
@test """abc""" == "abc"
@test """ab"c""" == "ab\"c"
@test """ab""c""" == "ab\"\"c"
@test """ab"\"c""" == "ab\"\"c"
@test """abc\"""" == "abc\""
n = 3
@test """$n\n""" == "$n\n"
@test """$(n)""" == "3"
@test """$(2n)""" == "6"
@test """$(n+4)""" == "7"
@test """$("string")""" == "string"
a = [3,1,2]
@test """$(a[2])""" == "1"
@test """$(a[3]+7)""" == "9"
@test """$(ifloor(4.5))""" == "4"
nl = "
"
@test """
     a
     b

     c
     """ == "a$(nl)b$(nl)$(nl)c$(nl)"
@test """
      """ == ""
@test """x
     a
    """ == "x$(nl) a$(nl)"
@test """
     $n
   """ == "  $n$(nl)"
@test """
      a
     b
       c""" == " a$(nl)b$(nl)  c"
# note tab/space mixing
@test """
	a
     b
     """ == "   a$(nl)b$(nl)"
@test """
      a
       """ == "a$(nl)"
s = "   p"
@test """
      $s""" == "$s"
@test """
       $s
      """ == " $s$(nl)"

# bytes2hex and hex2bytes
hex_str = "d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592"
bin_val = hex2bytes(hex_str)

@test div(length(hex_str), 2) == length(bin_val)
@test hex_str == bytes2hex(bin_val)

bin_val = hex2bytes("07bf")
@test bin_val[1] == 7
@test bin_val[2] == 191
@test typeof(bin_val) == Array{Uint8, 1}
@test length(bin_val) == 2

# all valid hex chars
@test "0123456789abcdefabcdef" == bytes2hex(hex2bytes("0123456789abcdefABCDEF"))

# odd size
@test_throws hex2bytes("0123456789abcdefABCDEF0")

#non-hex characters
@test_throws hex2bytes("0123456789abcdefABCDEFGH")

# sizeof
@test sizeof("abc") == 3
@test sizeof("\u2222") == 3
@test sizeof(SubString("abc\u2222def",4,4)) == 3
@test sizeof(RopeString("abc","def")) == 6

# issue #3597
@test string(UTF32String(['T', 'e', 's', 't'])[1:1], "X") == "TX"

# issue #3710
@test prevind(SubString("{var}",2,4),4) == 3

# printf
# int
@test (@sprintf "%d" typemax(Int64)) == "9223372036854775807"
@test (@sprintf "%i" 42) == "42"
@test (@sprintf "%u" 42) == "42"
@test (@sprintf "Test: %i" 42) == "Test: 42"
@test (@sprintf "%#x" 42) == "0x2a"
@test (@sprintf "%#o" 42) == "052"
@test (@sprintf "%X" 42) == "2A"
@test (@sprintf "%X" 42) == "2A"
@test (@sprintf "% i" 42) == " 42"
@test (@sprintf "%+i" 42) == "+42"
@test (@sprintf "%4i" 42) == "  42"
@test (@sprintf "%-4i" 42) == "42  "
# float
@test (@sprintf "%7.2f" 1.2345) == "   1.23"
@test (@sprintf "%-7.2f" 1.2345) == "1.23   "
@test (@sprintf "%07.2f" 1.2345) == "0001.23"
@test (@sprintf "%.0f" 1.2345) == "1"
@test (@sprintf "%#.0f" 1.2345) == "1."
# Inf / NaN handling
@test (@sprintf "%f" Inf) == "Inf"
@test (@sprintf "%f" NaN) == "NaN"
# scientific notation
@test (@sprintf "%.4e" 1.2345) == "1.2345e+00"
@test (@sprintf "%.0e" 3e142) == "3e+142"
@test (@sprintf "%#.0e" 3e142) == "3.e+142"
# chars
@test (@sprintf "%c" 65) == "A"
@test (@sprintf "%c" 'A') == "A"
@test (@sprintf "%c" 248) == "ø"
@test (@sprintf "%c" 'ø') == "ø"
# strings
@test (@sprintf "%s" "test") == "test"
@test (@sprintf "%s" "tést") == "tést"
# reasonably complex
@test (@sprintf "Test: %s%c%C%c%#-.0f." "t" 65 66 67 -42) == "Test: tABC-42.."

# issue #4183
@test split(SubString(ascii("x"), 2, 0), "y") == String[""]
@test split(SubString(utf8("x"), 2, 0), "y") == String[""]

# issue #4586
@test rsplit(RevString("ailuj"),'l') == {"ju","ia"}
@test_throws float64(RevString("64"))

for T = (Uint8,Int8,Uint16,Int16,Uint32,Int32,Uint64,Int64,Uint128,Int128,BigInt),
    b = 2:62, _ = 1:10
    n = T != BigInt ? rand(T) : BigInt(rand(Int128))
    @test parseint(T,base(b,n),b) == n
end

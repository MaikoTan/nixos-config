import re

with open('src/runtime_probe/getter_decoder.cc', 'r') as f:
    content = f.read()

# 1. Add XOR decoding in DecodeX64 after kRet handling
xor_code = '''
  // Check for XOR reg, reg (opcode 0x31 or 0x33 with mod=3) - no REX prefix needed
  // This handles Node.js 22+'s builtin_module_require which has `xor edi, edi`
  if (remaining >= 2 && (p[0] == 0x31 || p[0] == 0x33)) {
    const uint8_t modrm = p[1];
    if ((modrm >> 6) == 0x3) {  // mod == 3 (register mode)
      insn.op = X64Op::kXorRegReg;
      insn.length = 2;
      insn.reg = (modrm >> 3) & 0x7;
      insn.base = modrm & 0x7;
      return insn;
    }
  }
'''

ret_block = r'(  if \(p\[0\] == 0xc3\) \{\n    insn\.op = X64Op::kRet;\n    insn\.length = 1;\n    return insn;\n  \}\n\n  // The remaining forms are all REX\.W \(0x48\) MOV r/m64 instructions\. Restrict)'
content = re.sub(ret_block, r'\1' + xor_code, content)

# 2. Add kXorRegReg to WalkX64Getter switch
content = content.replace(
    'case X64Op::kMovRegReg:\n        break;  // prologue / epilogue / register shuffling: no effect on offset',
    'case X64Op::kMovRegReg:\n      case X64Op::kXorRegReg:\n        break;  // prologue / epilogue / register shuffling: no effect on offset'
)

with open('src/runtime_probe/getter_decoder.cc', 'w') as f:
    f.write(content)

print("Manual patches applied successfully")
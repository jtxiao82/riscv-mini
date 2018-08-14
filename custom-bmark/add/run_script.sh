rm *.ll
rm *.o
rm *.s

# Main LLVM IR Generation
/opt/riscv/bin/riscv32-unknown-elf-clang++ -stdlib=libstdc++ -emit-llvm -fno-builtin -fno-inline -fno-vectorize -fno-slp-vectorize -S main.c

# LLVM IR Instrumentation
/opt/riscv/bin/opt -load=/home/jtxiao/NTHU/Research/Git/FaultInjectionPlatform/src/instrumentBasicBlock/tests/adaline/../../build/instrument_bb/libInstrumentBB.so -instrument-bb -dont_touch /home/jtxiao/NTHU/Research/Git/FaultInjectionPlatform/src/instrumentBasicBlock/tests/adaline/dont_touch.txt -S < main.ll > main.trace_bb.ll

# Main ASM Generation
/opt/riscv/bin/llc -march=riscv32 main.trace_bb.ll

# Main Object File Generation
~/NTHU/Research/Git/riscv_tool_for_riscv_mini/bin/riscv32-unknown-elf-gcc main.trace_bb.s -c -o main.trace_bb.o

# Syscall.c, Crt.S  Object File Generation 
~/NTHU/Research/Git/riscv_tool_for_riscv_mini/bin/riscv32-unknown-elf-gcc -static -std=gnu99 -fno-common -fno-builtin-printf -I/home/jtxiao/NTHU/Research/Git/riscv-mini/riscv-tools-priv1.7/riscv-tests/env -I/home/jtxiao/NTHU/Research/Git/riscv-mini/riscv-tools-priv1.7/riscv-tests/benchmarks/common -c -o syscalls.o syscalls.c
~/NTHU/Research/Git/riscv_tool_for_riscv_mini/bin/riscv32-unknown-elf-gcc -static -std=gnu99 -fno-common -fno-builtin-printf -I/home/jtxiao/NTHU/Research/Git/riscv-mini/riscv-tools-priv1.7/riscv-tests/env -I/home/jtxiao/NTHU/Research/Git/riscv-mini/riscv-tools-priv1.7/riscv-tests/benchmarks/common -D__ASSEMBLY__=1 -c -o crt.o crt.S
~/NTHU/Research/Git/riscv_tool_for_riscv_mini/bin/riscv32-unknown-elf-gcc -static -std=gnu99 -fno-common -fno-builtin-printf -I/home/jtxiao/NTHU/Research/Git/riscv-mini/riscv-tools-priv1.7/riscv-tests/env -I/home/jtxiao/NTHU/Research/Git/riscv-mini/riscv-tools-priv1.7/riscv-tests/benchmarks/common -D__ASSEMBLY__=1 -c -o add.o add.S

# Run time library Object File Generation
~/NTHU/Research/Git/riscv_tool_for_riscv_mini/bin/riscv32-unknown-elf-gcc -static -std=gnu99 -fno-common -fno-builtin-printf -I/home/jtxiao/NTHU/Research/Git/riscv-mini/riscv-tools-priv1.7/riscv-tests/env -I/home/jtxiao/NTHU/Research/Git/riscv-mini/riscv-tools-priv1.7/riscv-tests/benchmarks/common -c -o rtlib.o rtlib.c


# Link ELF
~/NTHU/Research/Git/riscv_tool_for_riscv_mini/bin/riscv32-unknown-elf-gcc -T /home/jtxiao/NTHU/Research/Git/riscv-mini/riscv-tools-priv1.7/riscv-tests/benchmarks/common/test.ld -I/home/jtxiao/NTHU/Research/Git/riscv-mini/riscv-tools-priv1.7/riscv-tests/env -I/home/jtxiao/NTHU/Research/Git/riscv-mini/riscv-tools-priv1.7/riscv-tests/benchmarks/common -o main.trace_bb main.trace_bb.o syscalls.o crt.o add.o rtlib.o -nostdlib -nostartfiles -lc -lgcc

# ELF transforms to HEX
~/NTHU/Research/Git/riscv_tool_for_riscv_mini/bin/elf2hex 16 32768 main.trace_bb > main.trace_bb.hex
~/NTHU/Research/Git/riscv_tool_for_riscv_mini/bin/riscv32-unknown-elf-objdump \
--disassemble-all --disassemble-zeroes --section=.text --section=.text.startup --section=.data \
main.trace_bb > main.trace_bb.dump

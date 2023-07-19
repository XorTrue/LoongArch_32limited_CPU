# LoongArch_32limited_CPU

采用 同步复位 的方式，实现了一个精简版32位 LoongArch CPU，支持的指令集如下：
add(i).w、sub.w、lu12i.w、pcaddu12i.w、or(i)、and(i)、xor
srli.w、slli.w、srl.w
sltui[]



the reset value of PC is 0x80000000

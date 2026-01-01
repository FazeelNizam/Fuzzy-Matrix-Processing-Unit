onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib reg_a_opt

do {wave.do}

view wave
view structure
view signals

do {reg_a.udo}

run -all

quit -force

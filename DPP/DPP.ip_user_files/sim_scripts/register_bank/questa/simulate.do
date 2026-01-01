onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib register_bank_opt

do {wave.do}

view wave
view structure
view signals

do {register_bank.udo}

run -all

quit -force

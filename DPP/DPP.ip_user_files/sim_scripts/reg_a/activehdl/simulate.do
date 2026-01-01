onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+reg_a -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.reg_a xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {reg_a.udo}

run -all

endsim

quit -force

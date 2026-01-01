onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+register_bank -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.register_bank xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {register_bank.udo}

run -all

endsim

quit -force

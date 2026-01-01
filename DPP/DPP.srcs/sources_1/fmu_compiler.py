import re
import sys
import math

class FmuCompiler:
    """
    Compiler for the Fuzzy Matrix Unit (FMU), updated to match the
    provided state diagrams and instruction set architecture.
    """
    def __init__(self):
        self.program_memory = []
        self.data_memory = {}
        
        # Opcodes based on the state diagrams
        self.opcodes = {
            "SETMX": 0x01, "MOVEME": 0x02, "LDMX": 0x03, "STRMX": 0x04,
            "FADD": 0x05, "FSUB": 0x06, "FMUL": 0x07,
            "CLR": 0x08, "CLRM": 0x09, "HALT": 0x0F
        }

        # Maps a matrix's base RAM address to the temp register (0-15) holding its metadata
        self.matrix_metadata_registers = {}
        self.next_available_reg = 0

        self.patterns = {
            'matrix_definition': re.compile(r'^\s*(0x[0-9a-fA-F]+)\s*=\s*\{(.+)\};'),
            'update': re.compile(r'^\s*update\s*(0x[0-9a-fA-F]+)\s*\((\d+),(\d+)\)\s*=\s*([\d.]+);'),
            'delete': re.compile(r'^\s*del\s*(0x[0-9a-fA-F]+);'),
            'operation': re.compile(r'^\s*(add|mul|sub)\s*\((0x[0-9a-fA-F]+)\s*,\s*(0x[0-9a-fA-F]+)\);'),
            'store': re.compile(r'^\s*store\s*(0x[0-9a-fA-F]+);')
        }

    def fuzzy_to_int(self, f_val):
        """
        Converts a float (0.0-1.0) to an 8-bit integer (0-255) by
        scaling (Q0.8 style) and rounding to the nearest integer.
        """
        scaled_val = f_val * 255.0
        rounded_val = int(scaled_val + 0.5)
        return min(255, rounded_val)

    def build_instruction(self, opcode, reg1=0, row=0, col=0, ram_addr=0, value=0):
        """Builds a 32-bit instruction based on the specific bit-field format."""
        instr = (opcode & 0xF)
        instr |= (reg1 & 0x1F) << 4
        
        if ram_addr > 0:
            instr |= (ram_addr & 0xFFFF) << 9
            
        instr |= (row & 0x1F) << 9
        instr |= (col & 0x1F) << 14
        instr |= (value & 0xFF) << 19
        self.program_memory.append(instr)

    def handle_matrix_definition(self, match):
        """
        Expands a high-level matrix definition into a sequence of SETMX
        and MOVEME machine instructions.
        """
        addr = int(match.group(1), 16)
        val_str = match.group(2)

        row_contents = re.findall(r'\((.*?)\)', val_str)
        matrix = []
        for row_c in row_contents:
            elements = [float(v.strip()) for v in row_c.split(',')]
            matrix.append(elements)

        rows, cols = len(matrix), len(matrix[0]) if matrix else (0, 0)

        if addr in self.matrix_metadata_registers:
            reg_idx = self.matrix_metadata_registers[addr]
        else:
            if self.next_available_reg > 15:
                print(f"Error: No more temporary registers available for matrix at {hex(addr)}")
                return
            reg_idx = self.next_available_reg
            self.matrix_metadata_registers[addr] = reg_idx
            self.next_available_reg += 1
        
        print(f"Compiling matrix definition at {hex(addr)} ({rows}x{cols}) using Temp Register R{reg_idx}")

        print(f"  -> Generating SETMX (R{reg_idx}, Addr={hex(addr)}, Rows={rows}, Cols={cols})")
        self.build_instruction(self.opcodes["SETMX"], reg1=reg_idx, ram_addr=addr, row=rows, col=cols)

        for r_idx, row_data in enumerate(matrix):
            for c_idx, val in enumerate(row_data):
                int_val = self.fuzzy_to_int(val)
                self.build_instruction(self.opcodes["MOVEME"], reg1=reg_idx, row=r_idx, col=c_idx, value=int_val)

    def handle_update(self, match):
        """Generates a single MOVEME instruction to update an element."""
        addr = int(match.group(1), 16)
        row, col = int(match.group(2)), int(match.group(3))
        value = self.fuzzy_to_int(float(match.group(4)))
        
        if addr not in self.matrix_metadata_registers:
            print(f"Error: Cannot update matrix at {hex(addr)}. It has not been defined with SETMX.")
            return
            
        reg_idx = self.matrix_metadata_registers[addr]
        print(f"Compiling update for {hex(addr)}({row},{col}) using Temp Register R{reg_idx}")
        self.build_instruction(self.opcodes["MOVEME"], reg1=reg_idx, row=row, col=col, value=value)

    def handle_delete(self, match):
        """Generates a CLRM instruction."""
        addr = int(match.group(1), 16)
        self.build_instruction(self.opcodes["CLRM"], ram_addr=addr)
        print(f"Compiled delete (CLRM) for memory starting at {hex(addr)}")

    def handle_operation(self, match):
        """Generates LDMX (to A) and an F-OP instruction."""
        op_type = match.group(1).upper()
        addr1 = int(match.group(2), 16)
        addr2 = int(match.group(3), 16)

        if addr1 not in self.matrix_metadata_registers or addr2 not in self.matrix_metadata_registers:
            print(f"Error: Both matrices for operation must be defined first.")
            return

        reg1_idx = self.matrix_metadata_registers[addr1]
        reg2_idx = self.matrix_metadata_registers[addr2]
        
        a_reg_code = 16 

        print(f"Compiling {op_type} operation between {hex(addr1)} (R{reg1_idx}) and {hex(addr2)} (R{reg2_idx})")
        
        print(f"  -> Generating LDMX from RAM pointed by R{reg1_idx} into A Register")
        self.build_instruction(self.opcodes["LDMX"], reg1=a_reg_code, ram_addr=addr1)
        
        op_code = self.opcodes[f'F{op_type}']
        print(f"  -> Generating 'F{op_type}' using matrix metadata from R{reg2_idx}")
        self.build_instruction(op_code, reg1=reg2_idx)
        print("NOTE: Result is in the accumulator (A Register). Use 'store' to save it.")

    def handle_store(self, match):
        """Generates a STRMX (Store from A Register to RAM) instruction."""
        addr = int(match.group(1), 16)
        self.build_instruction(self.opcodes["STRMX"], ram_addr=addr)
        print(f"Compiled store (STRMX) result to {hex(addr)}")
        
    def parse_line(self, line):
        for name, pattern in self.patterns.items():
            if pattern.match(line):
                getattr(self, f'handle_{name}')(pattern.match(line))
                return True
        return False

    def compile(self, input_filename):
        print(f"--- Starting compilation of {input_filename} ---")
        with open(input_filename, 'r') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('#'): continue
                if not self.parse_line(line):
                    print(f"Syntax Error: {line}")
        
        self.build_instruction(self.opcodes["HALT"])
        print("Added HALT instruction to end of program.")
        print("--- Compilation Finished ---")

    def write_coe_files(self, program_file, data_file, mem_depth=65536):
        """
        Writes the compiled data to .coe files in BINARY format,
        padding to the full memory depth.
        """
        # --- Write program.coe ---
        with open(program_file, 'w') as f:
            f.write("memory_initialization_radix=2;\n")
            f.write("memory_initialization_vector=")
            
            # Format instructions as 32-bit binary strings
            program_bin = [f"{instr:032b}" for instr in self.program_memory]
            
            # Pad the rest of the memory with 32-bit binary zeros
            if len(program_bin) < mem_depth:
                program_bin.extend(['0' * 32] * (mem_depth - len(program_bin)))

            f.write(",".join(program_bin))
            f.write(";")
        print(f"Successfully wrote {len(program_bin)} lines to {program_file}")

        # --- Write data.coe ---
        with open(data_file, 'w') as f:
            f.write("memory_initialization_radix=2;\n")
            f.write("memory_initialization_vector=")
            
            # Format data as 8-bit binary strings
            data_bin = [f"{self.data_memory.get(i, 0):08b}" for i in range(mem_depth)]
            
            f.write(",".join(data_bin))
            f.write(";")
        print(f"Successfully wrote {len(data_bin)} lines to {data_file}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python fmu_compiler.py <input_file.txt>")
        sys.exit(1)
        
    compiler = FmuCompiler()
    compiler.compile(sys.argv[1])
    compiler.write_coe_files("program.coe", "data.coe")
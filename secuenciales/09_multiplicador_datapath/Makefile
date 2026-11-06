# Testbench a simular
TB ?= tb_multiplicador

# Herramientas
IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = surfer

# Directorios
SRC_DIR   = .
BUILD_DIR = work

# Archivos fuente
SOURCES = $(wildcard $(SRC_DIR)/*.v)

# Archivos generados
SIM = $(BUILD_DIR)/$(TB).vvp
VCD = $(TB).vcd

.PHONY: all compile run view clean

all: run


# Crear directorio de trabajo
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)


# Compilar
compile: $(BUILD_DIR)
	$(IVERILOG) -g2012 -o $(SIM) -s $(TB) $(SOURCES)


# Ejecutar simulación
run: compile
	$(VVP) $(SIM)


# Abrir GTKWave
view: run
	$(GTKWAVE) $(VCD) &


# Eliminar archivos generados
clean:
	rm -rf $(BUILD_DIR)
	rm -f *.vcd
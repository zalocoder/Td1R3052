# Testbench a simular
TB ?= tb_comparador

# Herramientas
IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

# Directorios
SRC_DIR   = src
BUILD_DIR = work

# Archivos fuente
SOURCES = $(wildcard $(SRC_DIR)/*.v)

# Archivos generados
SIM = $(BUILD_DIR)/$(TB).vvp
VCD = $(TB).vcd

# Parámetros GTKWAVE
GTK_ARGS = --rcvar 'fontname_signals Monospace 14' --rcvar 'fontname_waves Monospace 14'

.PHONY: all compile run view clean

all: run


# Crear directorio de trabajo
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)


# Compilar
compile: $(BUILD_DIR)
	$(IVERILOG) -g2012 -o $(SIM) -s $(TB) $(SOURCES) $(TB).v


# Ejecutar simulación
run: compile
	$(VVP) $(SIM)


# Abrir GTKWave
view: run
	$(GTKWAVE) $(VCD) $(GTK_ARGS)


# Eliminar archivos generados
clean:
	rm -rf $(BUILD_DIR)
	rm -f *.vcd
ifndef MININSTALL
# Service user ID
USER = autoclave
# System user ID
ROOT_USER = root
# For saved state
VAR_DIR = /var/lib/autoclave
# For configuration
ETC_DIR = /etc/autoclave
# HAL configs
HAL_DIR = $(ETC_DIR)/hal
# Executables
BIN_DIR = /usr/bin
# Python lib
PYTHON_DIR = /usr/lib/python$(shell \
    python -c \
	'from sys import version_info as v; print "%s.%s" % (v.major, v.minor)')
# QML files
SHARE_DIR = /usr/share/autoclave
else # MININSTALL
# Service user ID
USER = $(SUDO_USER)
# System user ID
ROOT_USER = $(SUDO_USER)
# For saved state
VAR_DIR = $(CURDIR)/rrd
# For configuration
ETC_DIR = $(CURDIR)/etc
# HAL configs
HAL_DIR = $(CURDIR)/hal
# Executables
BIN_DIR = $(CURDIR)/bin
# Python lib
PYTHON_DIR = $(CURDIR)/lib/python
# QML files
SHARE_DIR = $(CURDIR)
endif


HAL_FILES = common.hal bb.hal sim.hal
BIN_FILES = autoclave autoclave-control autoclave-logger autoclave-remote \
	autoclave-sim-temp
PYTHON_FILES = autoclave.py
SHARE_FILES = \
	images/icon.png \
	launcher.ini \
	qml/autoclave-remote/Goldistat/ExitButton.qml \
	qml/autoclave-remote/Goldistat/Goldistat.qml \
	qml/autoclave-remote/Goldistat/PowerButton.qml \
	qml/autoclave-remote/Goldistat/Private/GoldistatIn.qml \
	qml/autoclave-remote/Goldistat/Private/GoldistatOut.qml \
	qml/autoclave-remote/Goldistat/Private/GoldistatSet.qml \
	qml/autoclave-remote/Goldistat/TimeSeries.qml \
	qml/autoclave-remote/assets/background.png \
	qml/autoclave-remote/assets/locks.png \
	qml/autoclave-remote/description.ini \
	qml/autoclave-remote/autoclave-remote.qml \
	qml/autoclave-remote.pro \
	qml/main.cpp \
	qml/main.qml \
	qml/qml.qrc

.PHONY: default
default:
	@echo "Please specify a target; choices:" 1>&2
	@echo "    install [ MININSTALL=1 ]"
	@echo "    build"
	@echo "  - Use MININSTALL=1 to run from source directory"

.PHONY: add_user
add_user:
ifndef MININSTALL
	@ if ! id $(USER) 2>/dev/null >/dev/null; then \
	    echo "Creating user $(USER)"; \
	    adduser \
		--home $(VAR_DIR) \
		--no-create-home \
		--shell /usr/sbin/nologin \
		--gecos autoclave \
		--disabled-password \
		$(USER) >/dev/null; \
	fi
endif

$(patsubst %,$(HAL_DIR)/%,$(HAL_FILES)): $(HAL_DIR)/%: hal/%
	@mkdir -p $(HAL_DIR)
	install -m 644 $< $@

$(patsubst %,$(PYTHON_DIR)/%,$(PYTHON_FILES)): $(PYTHON_DIR)/%: lib/python/%
	@mkdir -p $(dir $@)
	install -m 644 $< $@

$(patsubst %,$(BIN_DIR)/%,$(BIN_FILES)): $(BIN_DIR)/%: bin/%
	install -m 755 $< $@

$(patsubst %,$(SHARE_DIR)/%,$(SHARE_FILES)): $(SHARE_DIR)/%: %
	@mkdir -p $(dir $@)
	install -m 644 $< $@

/etc/apache2/mods-enabled/cgi.load:
	ln -sf ../mods-available/cgi.load $@

/etc/apache2/conf-available/autoclave.conf: \
	    templates/apache.conf \
	    /etc/apache2/mods-enabled/cgi.load
	@mkdir -p $(dir $@)
	sed < $< > $@ \
	    -e 's,@VAR_DIR@,$(VAR_DIR),'
	ln -sf ../conf-available/autoclave.conf \
	    /etc/apache2/conf-enabled/autoclave.conf

$(VAR_DIR)/graphs/index.html: templates/index.html $(VAR_DIR)/saved_state.yaml
	@install -d -o $(USER) $(VAR_DIR)
	@install -d -o $(USER) -g www-data -m 775 $(dir $@)
	install -o $(ROOT_USER) -m 755 $< $@

$(VAR_DIR)/graphs/uichart.png.cgi: templates/uichart.png.cgi
	@install -d -o $(USER) $(VAR_DIR)
	@install -d -o $(USER) -g www-data -m 775 $(dir $@)
	install -o $(ROOT_USER) -m 755 $< $@

$(VAR_DIR)/saved_state.yaml:
	@install -d -o $(USER) $(VAR_DIR)
	touch $(VAR_DIR)/saved_state.yaml
	chown $(USER) $(VAR_DIR)/saved_state.yaml

$(ETC_DIR)/overlay-bb.bbio: etc/overlay-bb.bbio
	@install -o $(ROOT_USER) -d $(ETC_DIR)
	install -m 644 $< $@

$(ETC_DIR)/config.yaml: templates/config.yaml
	@install -o $(USER) -d $(ETC_DIR)
	sed < $< > $@ \
	    -e 's,@HAL_DIR@,$(HAL_DIR),' \
	    -e 's,@VAR_DIR@,$(VAR_DIR),' \
	    -e 's,@ETC_DIR@,$(ETC_DIR),' \
	    -e 's,@BIN_DIR@,$(BIN_DIR),' \
	    -e 's,@SHARE_DIR@,$(SHARE_DIR),'
	@chown $(ROOT_USER) $@

/etc/systemd/system/autoclave.service: templates/autoclave.service
	sed < $< > $@ \
	    -e 's,@USER@,$(USER),'
	ln -sf $@ /lib/systemd/autoclave.service

# System-installed files needed to run from source directory
ALL_FILES += \
	$(patsubst %,$(PYTHON_DIR)/%,$(PYTHON_FILES)) \
	$(ETC_DIR)/config.yaml \
	/etc/apache2/conf-available/autoclave.conf \
	$(VAR_DIR)/graphs/index.html \
	$(VAR_DIR)/graphs/uichart.png.cgi

# Full system install, started at boot time
ifndef MININSTALL
ALL_FILES += \
	$(MIN_INSTALL_FILES) \
	$(patsubst %,$(HAL_DIR)/%,$(HAL_FILES)) \
	$(patsubst %,$(BIN_DIR)/%,$(BIN_FILES)) \
	$(patsubst %,$(SHARE_DIR)/%,$(SHARE_FILES)) \
	$(ETC_DIR)/overlay-bb.bbio \
	$(VAR_DIR)/saved_state.yaml \
	/etc/systemd/system/autoclave.service
endif
.PHONY: install
install: add_user $(ALL_FILES)

ifndef MININSTALL
.PHONY: uninstall
uninstall:
	@ for i in $(ALL_FILES); do \
	    echo "Removing $$i"; \
	    rm -f $$i; \
	done
endif


.PHONY: build
build:
	mkdir -p build
	( cd build; qmake ../qml )
	make -C build

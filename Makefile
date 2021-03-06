PLUGIN_NAME=cloudfunctions

all: protos build install

protos:
	@echo ""
	@echo "Building Protos"

	protoc -I . --go_opt=paths=source_relative --go_out=. ./registry/output.proto ./platform/output.proto ./release/output.proto

build:
	@echo ""
	@echo "Compiling Plugin"

	go build -o ./bin/waypoint-plugin-${PLUGIN_NAME} ./main.go

install: build
	@echo ""
	@echo "Installing Plugin"

	cp ./bin/waypoint-plugin-${PLUGIN_NAME} ${HOME}/.config/waypoint/plugins/
	# For MacOS Big Sur, error ignored
	cp ./bin/waypoint-plugin-${PLUGIN_NAME} /Users/${USER}/Library/Preferences/waypoint/plugins/ || true

doc: install
	@echo ""
	@echo "Autogenerating Documentation"

	@cd examples && \
	 waypoint docs -plugin=cloudfunctions -markdown > ../doc/README.md && \
	 sed '1s;^;[comment]: <> (!!! AUTO GENERATED, DO NOT EDIT !!!)\n\n;' ../doc/README.md > tmp && \
	 mv tmp ../doc/README.md

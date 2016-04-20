PLATFORMS := x86-win32 x86-darwin x86-linux armv7-darwin armv7-android js-web

SCRIPTS := $(shell find . -type f \( -name '*.lua' -or  -name '*.*script' \) -not -path '*lua_install*')

ICON_APP := resources/app_icon.png

WIN32_ICON_APP := resources/win32/app_icon.ico
OSX_ICONSET_APP := resources/osx/app_icon.iconset
OSX_ICON_APP := resources/osx/app_icon.icns
LINUX_ICON_APP := resources/linux/app_icon.png
IOS_ICON_APP := resources/ios/app_icon_57x57.png
ANDROID_ICON_APP := resources/android/app_icon_ldpi.png

ICONS := $(WIN32_ICON_APP) $(OSX_ICON_APP) $(LINUX_ICON_APP) $(IOS_ICON_APP) $(ANDROID_ICON_APP)

BOB_JAR := tmp/bob.jar
BOB_URL := http://d.defold.com/archive/c7176baed6df55d32c3286ce27c84e1fe45406c4/bob/bob.jar

BUILDS := $(addsuffix -build,$(PLATFORMS))

.PHONY: help clean lint test coveralls icons bob $(BUILDS)

all: clean lint test

help:
	@$(MAKE) -pq | \
		awk -F: '/^[a-zA-Z0-9][^$$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /); for (i in A) print A[i]}' | \
		sort

clean:
	rm -rf build/ luacov.*

lint:
	luacheck $(SCRIPTS)

test:
	busted --coverage --verbose

coveralls:
	luacov-coveralls

$(WIN32_ICON_APP): $(ICON_APP)
	mkdir -p $(dir $@)
	convert $< \
		-resize 256x256 \
		-define icon:auto-resize='256,48,32,16' \
		$@

$(OSX_ICONSET_APP): $(ICON_APP)
	mkdir -p $@
	convert $< \
		-set filename:target '$@/icon' \
		\( -clone 0 -resize 1024x1024 -write '%[filename:target]_512x512@2x.png' \) \
		\( -clone 0 -resize 512x512 -write '%[filename:target]_512x512.png' \) \
		\( -clone 0 -resize 512x512 -write '%[filename:target]_256x256@2x.png' \) \
		\( -clone 0 -resize 256x256 -write '%[filename:target]_256x256.png' \) \
		\( -clone 0 -resize 256x256 -write '%[filename:target]_128x128@2x.png' \) \
		\( -clone 0 -resize 128x128 -write '%[filename:target]_128x128.png' \) \
		\( -clone 0 -resize 64x64 -write '%[filename:target]_32x32@2x.png' \) \
		\( -clone 0 -resize 32x32 -write '%[filename:target]_32x32.png' \) \
		\( -clone 0 -resize 32x32 -write '%[filename:target]_16x16@2x.png' \) \
		\( -clone 0 -resize 16x16 -write '%[filename:target]_16x16.png' \) \
		null:
	touch $@

$(OSX_ICON_APP): $(OSX_ICONSET_APP)
	mkdir -p $(dir $@)
	iconutil -c icns -o $@ $<

$(LINUX_ICON_APP): $(ICON_APP)
	mkdir -p $(dir $@)
	convert $< \
		-resize 256x256 \
		$@

$(IOS_ICON_APP): $(ICON_APP)
	mkdir -p $(dir $@)
	convert $< \
		-set filename:target '$(dir $@)/app_icon' \
		\( -clone 0 -resize 167x167 -write '%[filename:target]_83.5x83.5@2x.png' \) \
		\( -clone 0 -resize 180x180 -write '%[filename:target]_60x60@3x.png' \) \
		\( -clone 0 -resize 120x120 -write '%[filename:target]_60x60@2x.png' \) \
		\( -clone 0 -resize 152x152 -write '%[filename:target]_76x76@2x.png' \) \
		\( -clone 0 -resize 76x76 -write '%[filename:target]_76x76.png' \) \
		\( -clone 0 -resize 144x144 -write '%[filename:target]_72x72@2x.png' \) \
		\( -clone 0 -resize 72x72 -write '%[filename:target]_72x72.png' \) \
		\( -clone 0 -resize 114x114 -write '%[filename:target]_57x57@2x.png' \) \
		\( -clone 0 -resize 57x57 -write '%[filename:target]_57x57.png' \) \
		null:
	touch $@

$(ANDROID_ICON_APP): $(ICON_APP)
	mkdir -p $(dir $@)
	convert $< \
		-set filename:target '$(dir $@)/app_icon' \
		\( -clone 0 -resize 192x192 -write '%[filename:target]_xxxhdpi.png' \) \
		\( -clone 0 -resize 144x144 -write '%[filename:target]_xxhdpi.png' \) \
		\( -clone 0 -resize 96x96 -write '%[filename:target]_xhdpi.png' \) \
		\( -clone 0 -resize 72x72 -write '%[filename:target]_hdpi.png' \) \
		\( -clone 0 -resize 48x48 -write '%[filename:target]_mdpi.png' \) \
		\( -clone 0 -resize 36x36 -write '%[filename:target]_ldpi.png' \) \
		null:
	touch $@

icons: $(ICONS)

$(BOB_JAR):
	mkdir -p $(dir $@)
	curl -o $@ $(BOB_URL)

bob: $(BOB_JAR)

$(BUILDS): %-build: icons bob
	java -jar $(BOB_JAR) --archive --platform $* resolve distclean build bundle

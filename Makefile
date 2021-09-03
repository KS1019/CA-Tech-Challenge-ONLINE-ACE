MINT_VERSION = 0.16.0

bootstrap: mint

mint:
	git clone https://github.com/yonaskolb/Mint.git -b $(MINT_VERSION)
	cd Mint
	make
	cd ..
	rm -rf Mint/

mint-install-ci:
	git clone https://github.com/yonaskolb/Mint.git -b $(MINT_VERSION)
	ls
	cd Mint/
	ls
	swift build --disable-sandbox -c release --arch x86_64
	mkdir -p /usr/local/bin
	cp -f .build/apple/Products/Release/mint /usr/local/bin/mint
	cd ..
	rm -rf Mint/

xcodeproj:
	mint run xcodegen

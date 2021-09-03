MINT_VERSION = 0.16.0

bootstrap: mint

mint:
	git clone https://github.com/yonaskolb/Mint.git -b $(MINT_VERSION)
	cd Mint
	make
	cd ..
	rm -rf Mint/

xcodeproj:
	xcodegen

test:
	mint run xcodegen

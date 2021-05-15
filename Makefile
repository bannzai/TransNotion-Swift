


.PHONY: secret
secret:
	echo $(DEVELOPMENT_GOOGLE_SERVICE_INFO_PLIST) | base64 -D > TransNotion/GoogleService-Info-dev.plist
	echo $(DEBUG_SECRET_XCCONFIG) | base64 -D > TransNotion/Debug-Secret.xcconfig
	echo $(RELEASE_SECRET_XCCONFIG) | base64 -D > TransNotion/Release-Secret.xcconfig
	./scripts/secret.sh

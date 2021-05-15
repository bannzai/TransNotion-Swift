


.PHONY: secret
secret:
	echo $(DEVELOPMENT_GOOGLE_SERVICE_INFO_PLIST) | base64 -D > TransNotion/Dev/GoogleService-Info.plist
	./scripts/secret.sh




.PHONY: secret
secret:
	echo $(DEVELOPMENT_GOOGLE_SERVICE_INFO_PLIST) | base64 -D > TransNotion/GoogleService-Info-dev.plist
	./scripts/secret.sh

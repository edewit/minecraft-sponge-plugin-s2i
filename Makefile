IMAGE_NAME = edewit/minecraft-plugin-centos

build:
	mkdir -p build
	../minecraft-storeys-maker/gradlew build
	cp ../minecraft-storeys-maker/web/build/libs/web-*-all.jar build/
	docker build -t $(IMAGE_NAME) .

.PHONY: build test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run test-app
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run test-app-mvnw

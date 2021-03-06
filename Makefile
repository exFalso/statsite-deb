VERSION=0.7.1
BUILD_NUMBER=2

all: build/statsite_$(VERSION)-$(BUILD_NUMBER)_source.deb

build/:
	mkdir -p build

.PHONY: clean
clean: docker-remove-exited
	rm -rf build

.PHONY: docker-present
docker-present:
	which docker

.PHONY: docker-pull
docker-pull:
	docker pull ubuntu:trusty

.PHONY: docker-remove-exited
docker-remove-exited:
	docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm 2> /dev/null || true

build/statsite_$(VERSION)-$(BUILD_NUMBER)_source.deb: build/ docker-present docker-pull
	docker run -v $$PWD/src/docker:/home/statsite-deb/docker -v $$PWD/build:/home/statsite-deb/build -w /home/statsite-deb -i ubuntu:trusty docker/scripts/build.sh $(VERSION) $(BUILD_NUMBER)

PHP_UNIT_LATEST = 8
PHP_UNIT_VERSIONS = 8:7.3 7:7.1
PATTERN = 's/:/\n/g'
REPO_NAME = "pimlab/phpunit"

.PHONY: all clean template build test tag

all: clean template build test tag

build:
	@echo "=== START BUILD ==="; \
	for index in $(PHP_UNIT_VERSIONS) ; do \
	    versions=(`echo $$index | sed $(PATTERN)`); \
	    phpunit=$${versions[0]}; \
	    php=$${versions[1]}; \
	    echo "Make Docker image for PHPUnit: $$phpunit with PHP: $$php" ; \
	    docker image rm -f $(REPO_NAME):$$phpunit phpunit:$$phpunit phpunit:latest; \
	    if [ $$phpunit = $(PHP_UNIT_LATEST) ]; then \
	        docker build --tag phpunit:$$phpunit --tag phpunit:latest ./$$phpunit; \
	    else \
	        docker build --tag phpunit:$$phpunit ./$$phpunit; \
	    fi \
	done \

test:
	@echo "=== START TEST ==="; \
	for index in $(PHP_UNIT_VERSIONS) ; do \
	    versions=(`echo $$index | sed $(PATTERN)`); \
	    phpunit=$${versions[0]}; \
	    docker run --rm --tty phpunit:$$phpunit | grep "PHPUnit $$phpunit"; \
	done \

template:
	@echo "=== START TEMPLATE ==="; \
	for index in $(PHP_UNIT_VERSIONS) ; do \
	    versions=(`echo $$index | sed $(PATTERN)`); \
	    phpunit=$${versions[0]}; \
	    php=$${versions[1]}; \
	    mkdir -p ./$$phpunit; \
	    cp docker-entrypoint.sh $$phpunit; \
	    cp Dockerfile.template $$phpunit/Dockerfile; \
	    sed -i \
           --expression 's@%PHP_VERSION%@'$$php'@' \
           --expression 's@%PHPUNIT_VERSION%@'$$phpunit'@' \
           $$phpunit/Dockerfile; \
	done \

clean:
	@echo "=== START CLEAR ==="; \
	for index in $(PHP_UNIT_VERSIONS) ; do \
	    versions=(`echo $$index | sed $(PATTERN)`); \
	    phpunit=$${versions[0]}; \
	    rm -R ./$$phpunit; \
	done \

tag:
	@echo "=== START TAG ==="; \
	for index in $(PHP_UNIT_VERSIONS) ; do \
	    versions=(`echo $$index | sed $(PATTERN)`); \
	    phpunit=$${versions[0]}; \
	    if [ $$phpunit = $(PHP_UNIT_LATEST) ]; then \
	        docker tag phpunit:$$phpunit $(REPO_NAME):$$phpunit; \
	        docker push $(REPO_NAME):$$phpunit; \
	        docker tag phpunit:$$phpunit $(REPO_NAME):latest; \
	        docker push $(REPO_NAME):latest; \
	    else \
	        docker tag phpunit:$$phpunit $(REPO_NAME):$$phpunit; \
	        docker push $(REPO_NAME):$$phpunit; \
	    fi \
	done \
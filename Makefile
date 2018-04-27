.PHONY: hashing http json

projectpath = ${PWD}
glidepath = ${PWD}/vendor/github.com/Masterminds/glide

gobench2csv:
	go build -o build/gobench2csv cmd/gobench2csv/main.go
 
hashing:
	@cd hashing;go test -benchmem -bench . > hashing.results

json: generate
	@cd json;go test -benchmem -bench . > json.results

http:
	go build -o build/http/evio http/evio.go

target:
	@go build

test:
	@go test

$(glidepath)/glide:
	@git clone https://github.com/Masterminds/glide.git $(glidepath)
	@cd $(glidepath);make build
	@cp $(glidepath)/glide .

$(GOPATH)/bin/easyjson:
	@go get -u github.com/mailru/easyjson/...

libs: $(glidepath)/glide
	@$(glidepath)/glide install
	@R CMD BATCH plotting/setup.r

deps: libs

generate: $(GOPATH)/bin/easyjson
	@go generate ./...

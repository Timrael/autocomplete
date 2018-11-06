package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/valyala/fasthttp"
)

var (
	addr     = flag.String("addr", ":3001", "TCP address to listen to")
	compress = flag.Bool("compress", false, "Whether to enable transparent response compression")
)

func main() {
	flag.Parse()

	h := requestHandler
	if *compress {
		h = fasthttp.CompressHandler(h)
	}

	if err := fasthttp.ListenAndServe(*addr, h); err != nil {
		log.Fatalf("Error in ListenAndServe: %s", err)
	}
}

func requestHandler(ctx *fasthttp.RequestCtx) {
	result := make(map[string]interface{})
	term := string(ctx.QueryArgs().Peek("term"))

	body, err := autocompleteResponse(term)
	if err != nil {
		result["status"] = "error"
		result["reason"] = err.Error()
		respond(ctx, result)
		return
	}

	options, err := retrieveOptions(body)
	if err != nil {
		result["status"] = "error"
		result["reason"] = err.Error()
		respond(ctx, result)
		return
	}

	result["status"] = "ok"
	result["result"] = options
	respond(ctx, result)
}

func respond(ctx *fasthttp.RequestCtx, result map[string]interface{}) {
	ctx.SetContentType("application/json")
	jsonString, err := json.Marshal(result)
	if err != nil {
		log.Println(err.Error())
	}
	fmt.Fprintf(ctx, string(jsonString))
}

func retrieveOptions(body []byte) ([]map[string]interface{}, error) {
	var result []map[string]interface{}
	var jsonBody map[string]interface{}
	err := json.Unmarshal(body, &jsonBody)
	if err != nil {
		return nil, err
	}
	birds := jsonBody["suggest"].(map[string]interface{})
	companies := birds["companies"].([]interface{})[0].(map[string]interface{})
	options := companies["options"].([]interface{})
	for _, option := range options {
		source := option.(map[string]interface{})["_source"].(map[string]interface{})
		names := source["name"].([]interface{})
		resultOption := map[string]interface{}{
			"id":    source["id"],
			"title": names[0],
		}
		result = append(result, resultOption)
	}
	return result, nil
}

func autocompleteResponse(term string) ([]byte, error) {
	autoJson := `{"suggest":{"companies":{"prefix":"%v","completion":{"field":"name.suggest","fuzzy":{"fuzziness":"AUTO"},"size":10}}},"_source":["id","name"]}`
	jsonData := fmt.Sprintf(autoJson, term)
	url := "http://elasticsearch:9200/companies/_search"
	autoRequest, err := http.NewRequest("GET", url, bytes.NewBuffer([]byte(jsonData)))
	if err != nil {
		return nil, err
	}
	autoRequest.Header.Set("Content-Type", "application/json")
	client := &http.Client{}
	resp, err := client.Do(autoRequest)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	return ioutil.ReadAll(resp.Body)
}

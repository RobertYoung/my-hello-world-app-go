package main

import (
	"encoding/json"
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestHandlerReturnsServerIsRunning(t *testing.T) {
	res := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "URL", nil)

	handler(res, req)

	assert.Equal(t, "Server is running!", readBody(res))
}

func TestHandlerEchosInformation(t *testing.T) {
	var response EchoResponse
	expectedHostname, _ := os.Hostname()
	expectedPath := "/testPath"

	res := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", expectedPath, nil)

	echoHandler(res, req)
	json.Unmarshal([]byte(readBody(res)), &response)

	assert.Equal(t, expectedHostname, response.Hostname)
	assert.Equal(t, expectedPath, response.Path)
}

func TestHandlerPassesHealthCheck(t *testing.T) {
	res := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "URL", nil)

	healthHandler(res, req)

	assert.Equal(t, "Passed", readBody(res))
}

func readBody(res *httptest.ResponseRecorder) string {
	content, _ := ioutil.ReadAll(res.Body)
	return string(content)
}

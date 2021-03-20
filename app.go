package main

import (
         "fmt"
         "html"
	     "log"
		 "net/http"
	)

func findTheUserName(id uint32) string {
	return "JamesZhang"
}
func getNameLen(id uint32) int {
	return len(findTheUserName(id))
}

func main() {

	    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		            fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
            })

	    http.HandleFunc("/hi", func(w http.ResponseWriter, r *http.Request){
	            fmt.Fprintf(w, "Hi")
            })

            log.Fatal(http.ListenAndServe(":8085", nil))

}

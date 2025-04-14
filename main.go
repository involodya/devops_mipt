package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	message := os.Getenv("MESSAGE")
	if message == "" {
		message = "Привет из Docker!"
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		html := fmt.Sprintf(`
			<!DOCTYPE html>
			<html>
			<head>
				<title>Docker Multi-Stage Demo</title>
				<meta charset="UTF-8">
				<style>
					body { font-family: Arial, sans-serif; margin: 40px; line-height: 1.6; }
					h1 { color:
					.container { max-width: 800px; margin: 0 auto; padding: 20px; border: 1px solid
					.info { background-color:
					.footer { margin-top: 20px; font-size: 0.8em; color:
				</style>
			</head>
			<body>
				<div class="container">
					<h1>%s</h1>
					<div class="info">
						<p>Запущено на порту: <strong>%s</strong></p>
						<p>Имя хоста: <strong>%s</strong></p>
					</div>
					<div class="footer">
						<p>Многоэтапная сборка Docker - Лабораторная работа</p>
					</div>
				</div>
			</body>
			</html>
		`, message, port, os.Getenv("HOSTNAME"))
		fmt.Fprint(w, html)
	})

	log.Printf("Сервер запущен на порту %s", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}

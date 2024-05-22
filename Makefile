
.PHONY: all build run docker-build docker-run clean deploy undeploy minikube-start

# Genel hedef
all: build docker-build deploy

# Go uygulamasını derle
build:
	go mod init hello-world || true
	go mod tidy
	go build -o hello-world main.go

# Uygulamayı çalıştır
run:
	./hello-world

# Docker imajını oluştur
docker-build:
	docker build -t hello-world:latest .

# Docker Compose kullanarak uygulamayı çalıştır
docker-run:
	docker-compose up -d

# Minikube'yi başlat ve Docker environment'ını ayarla
minikube-start:
	minikube start
	eval $$(minikube -p minikube docker-env)

# Kubernetes kaynaklarını dağıt
deploy: docker-build minikube-start
	kubectl apply -f deployment.yaml
	kubectl apply -f service.yaml
	kubectl apply -f hpa.yaml

# Kubernetes kaynaklarını kaldır
undeploy:
	kubectl delete -f deployment.yaml
	kubectl delete -f service.yaml
	kubectl delete -f hpa.yaml

# Uygulamayı temizle
clean:
	rm -f hello-world
	docker-compose down
	minikube delete

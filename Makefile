vm:
	vagrant up

images:
	cd docker-build
	docker build --rm -f Dockerfile_host -t evpnlab-host:latest .
	docker build --rm -f Dockerfile_net -t evpnlab-net:latest .	

lab:
	containerlab deploy --topo evpnlab.yml

clean: 
	containerlab destroy --topo evpnlab.yml


all: images lab
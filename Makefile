vm:
	vagrant up

images:
	cd docker-build && docker build --rm -f Dockerfile_host -t evpnlab-host:latest .
	cd docker-build && docker build --rm -f Dockerfile_net -t evpnlab-net:latest .	

lab:
	containerlab deploy --topo evpnlab.yml

clean: 
	containerlab destroy --topo evpnlab.yml

leaf1:
	docker exec -it clab-evpnlab-leaf1 /bin/bash

leaf2:
	docker exec -it clab-evpnlab-leaf2 /bin/bash

spline1:
	docker exec -it clab-evpnlab-spline1 /bin/bash

all: images lab

vm:
	vagrant up

images:
	ntpd -gq
	cd docker-build && docker build --rm -f Dockerfile_host -t evpnlab-host:latest .
	cd docker-build && docker build --rm -f Dockerfile_net -t evpnlab-net:latest .	

lab:
	containerlab deploy --topo evpnlab.yml

down: 
	containerlab destroy --topo evpnlab.yml

#clean: 
#	docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) &&  docker rmi $(docker images -q)

ansible:
	ansible-playbook -i clab-evpnlab/ansible-inventory.yml playbook.yml

leaf1:
	docker exec -it clab-evpnlab-leaf1 /bin/bash

leaf2:
	docker exec -it clab-evpnlab-leaf2 /bin/bash

spline1:
	docker exec -it clab-evpnlab-spline1 /bin/bash

h11:
	docker exec -it clab-evpnlab-h11 /bin/bash

h21:
	docker exec -it clab-evpnlab-h21 /bin/bash

h12:
	docker exec -it clab-evpnlab-h12 /bin/bash

h13:
	docker exec -it clab-evpnlab-h13 /bin/bash

h14:
	docker exec -it clab-evpnlab-h14 /bin/bash

h22:
	docker exec -it clab-evpnlab-h22 /bin/bash

h31:
	docker exec -it clab-evpnlab-h31 /bin/bash



all: images lab
up: lab

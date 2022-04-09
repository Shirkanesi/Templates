#!/bin/bash
echo "Terminating portainer-instance"
docker stop portainer
echo "Removing portainer"
docker rm portainer
echo "Pull & rerun container"
# You might need to customize --net <network> and --ip <ip>!
docker run -d --net proxy --ip 172.18.0.3 --name=portainer --restart=always --pull=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
echo "Done!"

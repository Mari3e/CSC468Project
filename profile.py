import geni.portal as portal
import geni.rspec.pg as pg
import geni.rspec.igext as IG

pc = portal.Context()
request = pc.makeRequestRSpec()

tourDescription = \
"""
This profile provides the template for a compute node with Docker installed on Ubuntu 18.04
"""

#
# Setup the Tour info with the above description and instructions.
#  
tour = IG.Tour()
tour.Description(IG.Tour.TEXT,tourDescription)
request.addTour(tour)

prefixForIP = "192.168.1."
link = request.LAN("lan")

num_nodes = 4
for i in range(num_nodes):
  if i == 0:
    node = request.XenVM("head")
  else:
    node = request.XenVM("worker-" + str(i))
  node.cores = 4
  node.ram = 8192
  node.routable_control_ip = "true" 
  node.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU18-64-STD"
  iface = node.addInterface("if" + str(i))
  iface.component_id = "eth1"
  iface.addAddress(pg.IPv4Address(prefixForIP + str(i + 1), "255.255.255.0"))
  link.addInterface(iface)

  node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/install_kubernetes.sh"))
  node.addService(pg.Execute(shell="sh", command="sudo swapoff -a"))
  node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/install_docker.sh"))

  if i == 0:
    node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/install_jenkins.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/kube_manager.sh"))
  else:
    node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/kube_worker.sh"))
    
pc.printRequestRSpec(request)

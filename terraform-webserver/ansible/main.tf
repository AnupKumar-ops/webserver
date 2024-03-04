resource "null_resource" "ansible_provisioner" {
  provisioner "local-exec" {
    command     = <<-EOT
      ./get_ec2_publicip.sh
      /usr/bin/ansible-playbook -i inventory   --private-key /home/ec2-user/$keypairname.pem deploy-webserver.yml
    EOT
    working_dir = path.module
    environment = {
      region      = var.instance_region
      keypairname = var.keypairname
    }
  }
}

resource "null_resource" "key-provisioner" {
  provisioner "local-exec" {
    command     = "./generate_key.sh $keypairname $region $profile_name"
    working_dir = "ec2keypair/"

    environment = {
      keypairname  = var.keypairname
      region       = var.region
      profile_name = var.profile_name
    }
  }
}

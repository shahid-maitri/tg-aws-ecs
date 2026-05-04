include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "ec2_common" {
  # path   = "${get_repo_root()}/_envcommon/ec2.hcl"
  path = find_in_parent_folders("_envcommon/ec2.hcl")
  expose = true
}

inputs = {
  # EC2 config for dev
  instance_name = "operation"
  instance_type = "t3a.micro"
  volume_size   =  20
  volume_type   = "gp3"
}
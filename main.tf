module "module-ec2" {
    source = "./module-ec2/"
    ami = "ami-0f88e80871fd81e91"
    pub_subnet_id = "subnet-0c3fa97cc087dded4"             
    security_grp   = ["sg-0a68926f2b3336cf5"]
    instance_count    = 4 
    root_volume_size = 10
    extra_volume = [
        {
            device_name = "/dev/sdf"
            size = 20
            type = "gp2"
        },
        {
            device_name = "/dev/sdg"
            size = 30
            type = "gp3"
        }
    ]
    tags = {
  Project = "MyProject"
  Owner   = "Mahitha"
}

  aws_ec2 = {
    
}
}




resource "aws_instance" "ec2" {
  for_each        = var.aws_ec2
  ami             = each.value.ami
  instance_type   = each.value.instance_type
  subnet_id       = var.pub_subnet_id
  security_groups = var.security_grp
  tags = merge(var.tags, {
    Name = "ins-${each.key}"   
  })
}
resource "aws_launch_template" "ec2_template" {
    name_prefix = "ec2"
    image_id = var.ami
    instance_type = var.instance_type
    block_device_mappings {
      device_name = "/dev/xvda"
      ebs {
        volume_size = var.root_volume_size
        volume_type = var.root_volume_type
      }
    }
    dynamic "block_device_mappings" {
      for_each = var.extra_volume
      content {
        device_name = block_device_mappings.value.device_name
        ebs {
          volume_size = block_device_mappings.value.size
          volume_type = block_device_mappings.value.type
          delete_on_termination = false
        }
      }
      
    }
    tag_specifications {
      resource_type = "instance"
      tags = merge(var.tags,{
        Name = "ec2_ins"

      })
      }
    }

resource "aws_autoscaling_group" "scaling" {
  for_each = { for i in range(var.instance_count) : tostring(i) => i }

    desired_capacity = var.instance_count
    max_size = var.instance_count +6
    min_size = 1
    vpc_zone_identifier = [var.pub_subnet_id]
    launch_template {
      id = aws_launch_template.ec2_template.id
      version = "$Latest"
    }
  tag {
     key                 = "Name"
    value               = "ins-${var.dev_env}-${each.value}" 
    propagate_at_launch = true
  }
}

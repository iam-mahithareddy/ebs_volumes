## Terraform Setup: EC2 Auto Scaling with Extra Volumes
### ✅ Goal:
1. Provision an Auto Scaling Group (ASG) with EC2 instances that include:

2. A root volume

3. One or more extra EBS volumes

4. Controlled scale-out behavior (optional scale-in disabling)

5. Tagged and environment-based configuration

### 🛠️ Step-by-Step: Terraform Setup
### 🔹 Step 1: Define Input Variables (variables.tf)
Set up variables for AMI, instance type, volume sizes, subnet, and security groups ,root_volume_size, extra_volume (list of maps), instance_count, tags, aws_ec2 map, Optional: dev_env for dynamic naming
### 🔹 Step 2: Create EC2 Resources (Optional)
1. Use aws_instance with for_each = var.aws_ec2 if you want static EC2s as well.

Example:
```
resource "aws_instance" "ec2" {
  for_each = var.aws_ec2
  ami = each.value.ami
  instance_type = each.value.instance_type
  ...
}
```

### 🔹Step 3: Create Launch Template (aws_launch_template)
1. Add root volume config:
```
block_device_mappings {
  device_name = "/dev/xvda"
  ebs {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }
}

```
2. Add dynamic extra volumes:
```
dynamic "block_device_mappings" {
  for_each = var.extra_volume
  content {
    device_name = block_device_mappings.value.device_name
    ebs {
      volume_size = block_device_mappings.value.size
      volume_type = block_device_mappings.value.type
      delete_on_termination = false  # To persist extra volumes after termination
    }
  }
}

```
3. Set tags like Name = ec2_ins
### 🔹 Step 4: Create Auto Scaling Group(aws_autoscaling_group)
1. Use the launch template created in step 2.

2. Use for_each to support multiple ASGs (optional).

#### Configure:
```
desired_capacity = var.instance_count
max_size         = var.instance_count + 6
min_size         = 1
vpc_zone_identifier = [var.pub_subnet_id]
```
3. Add tag block with propagate_at_launch = true to attach name tags.
### 🔹 Step 5: Module Invocation (main.tf)
#### Reference the reusable module:
```
module "module-ec2" {
  source = "./module-ec2/"
  ami = "ami-xxxxxxxx"
  instance_count = 4
  ...
}
```
### Important Notes
1. Set "delete_on_termination = false" only if you want volumes to persist.

2. Otherwise, set to true to automatically clean up volumes after termination.

3. Be cautious: extra volumes will accumulate and increase storage costs if not deleted.




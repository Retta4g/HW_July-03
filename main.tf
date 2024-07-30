
resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = var.vpc_name
    
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = var.subnet_name
  }
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

variable "deploy_to-dev" {
  default = false
}
variable "instance_type" {
  default = "t2.miro"
}
variable "enviroment_type" {
  default = "dev"
}

resource "aws_instance" "my_instance" {
  count = (
    var.environment_type =="dev"
    ?
    1
    :
    (
      var.enviroment_type == "test"
      ?
      2
      :
      3
    )
  )
  ami           = "ami-01b799c439fd5516a"  
  instance_type = var.instance_type
  network_interface {
    network_interface_id = aws_network_interface.foo.network_interface_id
    device_index         = 0
  }
  tags = {
    Name = (
      var.enviroment_type == "dev"
      ?
      "dev_instance"
      :
      (
        var.enviroment_type == "test"
        ?
        "test_instance"
        :
        "prod_instance"
      )
    )
  }
}

resource "aws_s3_bucket" "default" {
  count = (
    var.enviroment_type == "dev"
    ?
    1
    :
    (
      var.enviroment_type == "test"
      ||
      var.enviroment_type == "prod"
      ?
      2
      :
      0
    )
  )
  bucket = "my-tf-test-bucket"

  tags = {
    Name       = "my bucket"
    Enviroment = var.enviroment_type
  }
}

resource "aws_iam_user" "user" {
  count = (
    var.enviroment_type == "dev" 
    ? 
    1
    :
    (
      var.enviroment_type == "test"
      ||
     var.enviroment_type == "prod"
     ?
     2
     :
     0
    )
  )
  name = (
    var.enviroment_type == "dev"
    ?
    var.enviroment_type
    :
    "${var.enviroment_type}${count.index}"
  )
}


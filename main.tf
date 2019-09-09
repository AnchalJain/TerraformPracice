provider "aws" {
	region="us-east-1"
}
resource "aws_instance" "example" {
	ami="ami-40d28157"
	instance_type="t2.micro"
	vpc_security_group_ids=["${aws_security_group.instance.id}"]
	user_data = "${file("script.sh")}"
	tags {
		Name="terraform-example"
	}
}
resource "aws_security_group" "instance"{
	name="terraform-example-instance"
	ingress {
		from_port = "${var.server_port}"
		to_port = "${var.server_port}"
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	egress {
        	from_port=0
        	to_port=0
       		protocol="-1"
        	cidr_blocks=["0.0.0.0/0"]
 	}

}

variable "server_port" {
	description = "The port the server will use for HTTP requests"
	default = 8080
}

output "public_ip" {
	value="${aws_instance.example.public_ip}"
}

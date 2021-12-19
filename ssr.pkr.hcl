source "tencentcloud-cvm" "tencent" {
  region                      = "ap-hongkong"
  zone                        = "ap-hongkong-1"
  instance_type               = "S1.SMALL1"
  source_image_id             = var.source_image_id
  secret_id                   = var.secret_id
  secret_key                  = var.secret_key
  image_name                  = var.image_name
  ssh_username                = "root"
  ssh_password                = var.ssh_password
  ssh_port                    = 22
  associate_public_ip_address = true
}

build {
  sources = ["tencentcloud-cvm.tencent"]

  provisioner "shell" {
    inline = [
      "sudo yum install -y git python34.x86_64",
      "sudo git clone https://github.com/shadowsocksr-backup/shadowsocksr.git",
      "cd ~/shadowsocksr",
      "sudo git checkout manyuser",
      "sudo bash initcfg.sh",
      "sudo sed -i -e '$asudo python ~/shadowsocksr/shadowsocks/server.py -p ${var.port} -k ${var.sspassword} -m ${var.cryptor_method} -O ${var.auth_method} -o ${var.obfs_method} -d start' /etc/rc.d/rc.local",
      "sudo chmod +x /etc/rc.d/rc.local",
    ]
  }
}

variable "sspassword" {
  type = string
}

variable "port" {
  type    = number
  default = 443
}

variable "cryptor_method" {
  type    = string
  default = "aes-256-cfb"
}

variable "auth_method" {
  type    = string
  default = "auth_aes128_md5"
}

variable "obfs_method" {
  type    = string
  default = "tls1.2_ticket_auth"
}

// need centos 6
variable "source_image_id" {
  type = string
}

variable "image_name" {
  type    = string
  default = "sss"
}

variable "secret_id" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "ssh_password" {
  type = string
}
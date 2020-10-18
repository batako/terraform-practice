/**
 * variable
 **/
variable "key_name" {
  type        = string
  description = "keypair name"
}

/**
 * resource
 **/
# キーペアを作る
resource "tls_private_key" "keygen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

/**
 * file
 **/
# 秘密鍵ファイルを作る
resource "local_file" "private_key_pem" {
  filename = "./${var.key_name}.id_rsa"
  content  = tls_private_key.keygen.private_key_pem

  provisioner "local-exec" {
    command = "chmod 600 ./${var.key_name}.id_rsa"
  }
}

resource "local_file" "public_key_openssh" {
  filename = "./${var.key_name}.id_rsa.pub"
  content  = tls_private_key.keygen.public_key_openssh

  provisioner "local-exec" {
    command = "chmod 600 ./${var.key_name}.id_rsa.pub"
  }
}

/**
 * output
 **/
# 秘密鍵ファイルPATH（このファイルを利用してサーバへアクセスする。）
output "private_key_file" {
  value = "./${var.key_name}.id_rsa"
}

# 秘密鍵内容
output "private_key_pem" {
  value = tls_private_key.keygen.private_key_pem
}

# 公開鍵ファイルPATH
output "public_key_file" {
  value = "./${var.key_name}.id_rsa.pub"
}

# 公開鍵内容（サーバの~/.ssh/authorized_keysに登録して利用する。）
output "public_key_openssh" {
  value = tls_private_key.keygen.public_key_openssh
}

data template_file "etcd" {
  template = "${file("${path.module}/templates/etcd.tpl")}"
  
  vars {
    discovery_url = "${var.discovery_url}"
    key           = "${var.do_read_token}"
  }
}

resource digitalocean_droplet "etcd" {
  count              = "${var.count}"
  image              = "${var.image}"
  region             = "${var.region}"
  size               = "${var.size}"
  name               = "${format("%setcd-%02d-%s", var.resource_prefix, count.index + 1, var.cluster_id)}"
  ssh_keys           = ["${split(",", var.ssh_keys)}"]
  tags               = ["${var.cluster_tag}"]
  private_networking = true

  user_data = "${data.template_file.etcd.rendered}"
}

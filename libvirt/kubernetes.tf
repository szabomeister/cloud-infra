resource "null_resource" "deploy_kubernetes" {
  depends_on = [
    null_resource.control_plane_reboot,
    null_resource.worker_reboot
  ]
  count = var.kubernetes_enable ? 1 : 0

  provisioner "local-exec" {
    environment = {
      TR_STACK      = var.stack_name
      TR_USERNAME   = var.username
      TR_MASTER_IPS = join(" ", libvirt_domain.control_plane.*.network_interface.0.addresses.0)
      TR_WORKER_IPS = join(" ", libvirt_domain.worker.*.network_interface.0.addresses.0)
      CNI_PLUGIN    = var.cni_plugin
      KUBERNETES_VER = var.kubernetes_version
      K8S_POD_SUBNET = var.k8s_pod_subnet
      CNI_PLUGIN_VERSION = var.cni_plugin_version
    }

    command = "bash deploy-kubernetes.sh"
  }
}

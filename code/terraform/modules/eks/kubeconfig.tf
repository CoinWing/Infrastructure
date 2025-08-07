# Bastion host에서 kubeconfig 업데이트 (SSM 사용)
resource "terraform_data" "update_kubeconfig_on_bastion" {
  provisioner "local-exec" {
    command = <<-EOT
      aws ssm send-command \
        --instance-ids ${var.bastion_host_id} \
        --document-name "AWS-RunShellScript" \
        --parameters 'commands=["aws eks update-kubeconfig --region ${var.region} --name ${var.project_name}-${var.env}-eks"]' \
        --region ${var.region}
    EOT
  }
  
  depends_on = [aws_eks_cluster.eks_cluster]
}
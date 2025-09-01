terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
    }
  }
}

# S3 버킷 생성
# Velero용 버킷
resource "aws_s3_bucket" "velero" {
  bucket = "${var.project_name}-velero-backup"

  tags = {
    Name = "${var.project_name}-velero-backup"
  }
}

# 퍼블릭 엑세스 차단
resource "aws_s3_bucket_public_access_block" "velero" {
  bucket = aws_s3_bucket.velero.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 서버사이드 암호화
resource "aws_s3_bucket_server_side_encryption_configuration" "velero" {
  bucket = aws_s3_bucket.velero.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 버전 관리 활성화
resource "aws_s3_bucket_versioning" "velero" {
  bucket = aws_s3_bucket.velero.id
  versioning_configuration {
    status = "Enabled"
  }
}

# IAM 역할 생성
resource "aws_iam_role" "velero" {
    name               = "eks-velero-role"
    assume_role_policy = data.aws_iam_policy_document.velero_assume.json
}

# IAM 정책 정의
resource "aws_iam_policy" "velero" {
  name        = "${var.project_name}-velero-backup-policy"
  description = "Velero aceess to S3 and EBS"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:AbortMultipartUpload",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.velero.arn,
          "${aws_s3_bucket.velero.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:DescribeSnapshots",
          "ec2:DescribeVolumes",
          "ec2:CreateTags"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "velero" {
  role       = aws_iam_role.velero.name
  policy_arn = aws_iam_policy.velero.arn
}

data "aws_iam_policy_document" "velero_assume" {
    statement {
        actions = ["sts:AssumeRoleWithWebIdentity"]
        effect  = "Allow"

        condition {
          test     = "StringEquals"
          variable = "${replace(var.cluster_dualstack_oidc_issuer_url, "https://", "")}:sub"
          values   = ["system:serviceaccount:${var.namespace}:velero"]
        }

        principals {
          type        = "Federated"
          identifiers = [var.oidc_provider_arn]
        }
    }
}

# Velero Helm 차트 설치
resource "helm_release" "velero" {
  name             = "velero"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://vmware-tanzu.github.io/helm-charts"
  chart            = "velero"
  version          = var.helm_chart_version

  values = [
    templatefile("${path.module}/velero-values.yaml.tmpl", {
      namespace            = var.namespace
      bucket_name          = aws_s3_bucket.velero.bucket
      region               = var.region
      velero_role_arn      = aws_iam_role.velero.arn
      velero_image_version = var.velero_image_version
    }),
    # 백업 스케줄 설정
    yamlencode({
      schedules = {
        "daliy-backup" = {
          schedule        = "0 12 * * *"
          template = {
            ttl              = "168h"
            includedNamespaces = ["*"]
            includedResources  = ["*"]
            snapshotVolumes    = true
            storageLocation    = "default"
          }
        }
      }
    })
  ]

  depends_on = [
    aws_iam_role.velero,
    aws_s3_bucket.velero
  ]
}
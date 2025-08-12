variable "project_name" {
  type        = string
  description = "Project name"
  default     = "sqs"
}

variable "env" {
  type        = string
  description = "Environment"
  default     = "prod"
}

variable "queue_name" {
  type        = string
  description = "Base name of the SQS queue (without env prefix)"
}

variable "fifo" {
  type        = bool
  description = "Whether the queue is FIFO"
  default     = true
}

variable "content_based_deduplication" {
  type        = bool
  description = "Enable content based deduplication for FIFO queue"
  default     = false # producer가 중복방지 역할을 하기 때문에 이 옵션은 끔.
}

variable "visibility_timeout_seconds" {
  type        = number
  description = "Visibility timeout in seconds"
  default     = 30 # 대부분 금방 처리하나 혹시 모를 오류 방지를 위해 30초 설정
}

variable "message_retention_seconds" {
  type        = number
  description = "Message retention period in seconds"
  default     = 18000 # 5시간
}

variable "delay_seconds" {
  type        = number
  description = "Delay for messages in seconds"
  default     = 0
}

variable "max_message_size" {
  type        = number
  description = "Maximum message size in bytes"
  default     = 1024
}

variable "receive_wait_time_seconds" {
  type        = number
  description = "Long polling wait time in seconds"
  default     = 5
}
variable "name" {
	type = string
}

variable "fifo_queue" {
	type    = bool
	default = true
}

variable "content_based_deduplication" {
	type    = bool
	default = false
}

variable "visibility_timeout_seconds" {
	type    = number
	default = 30
}

variable "message_retention_seconds" {
	type    = number
	default = 18000
}

variable "delay_seconds" {
	type    = number
	default = 0
}

variable "max_message_size" {
	type    = number
	default = 1024
}

variable "receive_wait_time_seconds" {
	type    = number
	default = 5
}

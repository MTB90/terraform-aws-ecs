output "database" {
  value =  module.dynamodb.database
}

output "file_storage" {
  value = module.storage.file_storage
}

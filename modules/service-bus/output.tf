##############################################################
# This module allows the creation of a Service Bus
##############################################################

output "id" {
  value       = azurerm_servicebus_namespace.main.id
  description = "The ID of the service bus namespace."
}

output "name" {
  value       = azurerm_servicebus_namespace.main.name
  description = "The name of the service bus namespace."
}

output "authorization_rules" {
  value = merge({
    for rule in azurerm_servicebus_namespace_authorization_rule.main :
    rule.name => {
      name                        = rule.name
      primary_key                 = rule.primary_key
      primary_connection_string   = rule.primary_connection_string
      secondary_key               = rule.secondary_key
      secondary_connection_string = rule.secondary_connection_string
    }
    }, {
    default = local.default_authorization_rule
  })
  description = "Map of authorization rules."
  sensitive   = true
}

output "topics" {
  value = {
    for topic in azurerm_servicebus_topic.main :
    topic.name => {
      id   = topic.id
      name = topic.name
      authorization_rules = {
        for rule in azurerm_servicebus_topic_authorization_rule.main :
        rule.name => {
          name                        = rule.name
          primary_key                 = rule.primary_key
          primary_connection_string   = rule.primary_connection_string
          secondary_key               = rule.secondary_key
          secondary_connection_string = rule.secondary_connection_string
        } if topic.name == rule.topic_name
      }
    }
  }
  description = "Map of topics."
}

output "queues" {
  value = {
    for queue in azurerm_servicebus_queue.main :
    queue.name => {
      id   = queue.id
      name = queue.name
      authorization_rules = {
        for rule in azurerm_servicebus_queue_authorization_rule.main :
        rule.name => {
          name                        = rule.name
          primary_key                 = rule.primary_key
          primary_connection_string   = rule.primary_connection_string
          secondary_key               = rule.secondary_key
          secondary_connection_string = rule.secondary_connection_string
        } if queue.name == rule.queue_name
      }
    }
  }
  description = "Map of queues."
}
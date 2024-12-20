# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START gke_qdrant_standard_private_regional_cluster]
module "qdrant_cluster" {

# The provided Terraform configuration defines a module for setting up a Google Kubernetes Engine (GKE) cluster specifically tailored 
# for deploying a Qdrant database. The module is sourced from the Terraform Google Modules repository, specifically the private-cluster module, 
# and is versioned at ~> 31.0.
  source                        = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster" # https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/blob/master/docs/private_clusters.md
  
  # The configuration begins by specifying the project_id, name, region, network, and subnetwork for the GKE cluster. 
  # The name is dynamically generated using the cluster_prefix variable. 
  version                       = "~> 31.0"
  project_id                    = var.project_id
  name                          = "${var.cluster_prefix}-cluster"
  regional                      = false
  zones                         = var.zones
  region                        = var.region
  network                       = var.network
  subnetwork                    = var.subnetwork
  ip_range_pods                 = "k8s-pod-range"
  ip_range_services             = "k8s-service-range"
  create_service_account        = true
  grant_registry_access         = true
  enable_private_endpoint       = false
  enable_private_nodes          = true
  master_ipv4_cidr_block        = "172.16.0.0/28"
  network_policy                = true
  logging_enabled_components    = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  monitoring_enabled_components = ["SYSTEM_COMPONENTS"]
  enable_cost_allocation        = true
  deletion_protection           = false
  initial_node_count            = 1
  kubernetes_version            = "latest"
  release_channel               = "RAPID"
  stateful_ha                   = true

  # cluster_resource_labels section assigns labels to the cluster resources for identification and management purposes
  cluster_resource_labels = {
    name      = "${var.cluster_prefix}-cluster"
    component = "${var.cluster_prefix}-operator"
  }

  monitoring_enable_managed_prometheus = false # before true
  gke_backup_agent_config              = false # before true

  node_pools        = var.node_pools
  node_pools_labels = var.node_pools_labels
  node_pools_taints = var.node_pools_taints
  gce_pd_csi_driver = true
}
# [END gke_qdrant_standard_private_regional_cluster]


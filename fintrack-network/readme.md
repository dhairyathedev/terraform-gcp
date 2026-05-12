### **Problem Statement by AI**

**Company:** FinTrack — a fintech startup building a payment processing platform.

**Infrastructure:** Hosted on **GCP**, single region: `us-central1`, single environment: **Production**.

**Services to host:**

* A **public-facing Load Balancer** (entry point for all traffic)  
* **3 application servers** (payment API backend)  
* **1 GKE cluster** (microservices — fraud detection, notification service)  
* **1 Cloud SQL instance** (PostgreSQL — stores transaction data)  
* **1 Bastion Host** (for secure SSH access to internal resources)  
* **Internal tooling** (monitoring/logging agents — Prometheus, Grafana)

**Constraints:**

* No resource should have a public IP except the Load Balancer and Bastion Host  
* GKE pods and services need their own IP ranges  
* Future VPC peering with a partner company is planned — so **avoid `10.0.0.0/16`** (they use it)  
* Must be production-grade, tag-based firewall rules

## **Solution (by myself):**

* **VPC CIDR:** 172.16.0.0/16  
* **Subnets:**  
  * Subnet \#1:  
    * Name: public-a  
    * Purpose: Public facing traffic  
    * CIDR: 172.16.1.0/24 (254 usable IPv4 addresses)  
  * Subnet \#2:  
    * Name: private-backend  
    * Purpose: Backend and application servers  
    * CIDR: 172.16.2.0/24 (254 usable IPv4 addresses)  
  * Subnet \#3:  
    * Name: private-gke  
    * Purpose: GKE cluster  
    * CIDR: 172.16.32.0/20 (4094 usable IPv4 addresses)  
  * Subnet \#4:  
    * Name: private-database  
    * Purpose: Database  
    * CIRD: 172.16.16.0/28 (14 usable IPv4 addresses)  
  * Subnet \#5:  
    * Name: private-internal-monitoring  
    * Purpose: Monitoring and miscellaneous  
    * CIDR: 172.16.17.0/24  
* **Firewall rules:**  
  * Allow HTTP (tag: load-balancer)  
  * Allow HTTPS (tag: load-balancer)  
  * Allow SSH via Bastion Host  
  * Allow Cloud SQL access via private subnet only  
  * Allow monitoring and misc from private subnet only  
* **Pod secondary: 10.4.0.0/14**   
* **Service secondary: 10.8.0.0/20**  
* **Cloud NAT in ~~public~~ private subnet**

	(I made the error because, in AWS NATGW sits in a public subnet, but that’s not the    case in GCP).

* **Private Google Access on for Private subnets**

### Diagram
![Rough System Diagram](https://static-cdn.dhairyashah.dev/imgs/static/cloud/gcp/fintrack-diagram.jpg)

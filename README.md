# SWE40006 AWS WordPress Deployment

This repository contains supporting scripts and documentation for Task 3 of SWE40006 Software Deployment and Evolution.

## Deployment Overview

A WordPress application was deployed on AWS using:

- Amazon EC2 for WordPress web servers
- Amazon RDS MariaDB for the database
- Amazon S3 for application and database backups
- Application Load Balancer for public HTTP traffic
- EC2 Auto Scaling across two Availability Zones
- Amazon CloudWatch and SNS for monitoring and email notifications
- AWS Systems Manager Session Manager for secure administration

## Configuration Summary

- Region: Asia Pacific (Sydney), `ap-southeast-2`
- EC2 instance type: `t3.micro`
- Auto Scaling capacity: minimum 2, desired 2, maximum 4
- Target tracking: average CPU utilisation at 50%
- Load balancer listener: HTTP port 80
- Target health check: `/health.html`
- Database connection: Amazon RDS MariaDB using SSL/TLS
- Administration: Session Manager without an inbound SSH rule

## Live Application

Application Load Balancer URL:

http://swe40006-wordpress-alb-1402361517.ap-southeast-2.elb.amazonaws.com

## Repository Contents

- `scripts/user-data.sh` – EC2 startup script used by the launch template
- `documentation/backup-restore-commands.md` – S3 backup and restore procedure
- `documentation/deployment-summary.md` – summary of the AWS deployment

## Security

This repository does not contain AWS credentials, private keys, database passwords, WordPress configuration files or database backups.

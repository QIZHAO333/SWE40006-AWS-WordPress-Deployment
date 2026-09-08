# AWS WordPress Deployment Summary

## Project Scope

This project deploys a WordPress application on AWS using separate web, database, backup, load balancing, scaling, monitoring and administration services.

## AWS Services

| Service | Purpose |
|---|---|
| Amazon EC2 | Hosts the WordPress application |
| Amazon RDS MariaDB | Provides a private application database |
| Amazon S3 | Stores application and database backups |
| Application Load Balancer | Provides the public HTTP entry point |
| EC2 Auto Scaling | Maintains and scales the WordPress instances |
| Amazon CloudWatch | Monitors CPU utilisation |
| Amazon SNS | Sends alarm notifications by email |
| Systems Manager Session Manager | Provides secure EC2 administration |

## Deployment Configuration

- Region: Asia Pacific (Sydney), `ap-southeast-2`
- EC2 instance type: `t3.micro`
- WordPress AMI used by the launch template
- Application Load Balancer listener: HTTP port 80
- Target group port: HTTP port 80
- Health-check path: `/health.html`
- Auto Scaling minimum capacity: 2
- Auto Scaling desired capacity: 2
- Auto Scaling maximum capacity: 4
- Availability Zones: `ap-southeast-2a` and `ap-southeast-2b`
- Target tracking value: average CPU utilisation at 50%
- CloudWatch alarm threshold: CPU utilisation at 70%
- RDS engine: MariaDB
- RDS network access: private
- Database port: 3306
- Database connection: SSL/TLS
- EC2 administration: Session Manager without inbound SSH port 22

## Deployment Workflow

1. A WordPress application was installed and tested on an Amazon Linux EC2 instance.
2. The local WordPress database was exported and imported into Amazon RDS MariaDB.
3. WordPress was reconfigured to connect to RDS using SSL/TLS.
4. WordPress files and the RDS database were backed up to Amazon S3.
5. A reusable WordPress AMI and EC2 launch template were created.
6. An Application Load Balancer and target group were configured.
7. An Auto Scaling group launched two EC2 instances across two Availability Zones.
8. Both instances passed the `/health.html` target group health check.
9. A CloudWatch CPU alarm and SNS email subscription were configured.
10. Systems Manager Session Manager was verified after removing inbound SSH access.

## Security Controls

- The RDS database is not publicly accessible.
- RDS port 3306 accepts traffic from the web server security group.
- Web server port 80 accepts application traffic from the load balancer security group.
- Inbound SSH port 22 was removed.
- Session Manager is used for EC2 administration.
- Database passwords and AWS credentials are not stored in this repository.
- The S3 backup bucket is private.

## Verification Results

- WordPress was accessible through the Application Load Balancer DNS name.
- Two Auto Scaling instances were registered as healthy targets.
- The RDS database connection worked using SSL/TLS.
- WordPress application and database backups were uploaded to S3.
- The WordPress file backup was downloaded, extracted and verified.
- The SNS topic successfully delivered a test email.
- Session Manager provided terminal access without an inbound SSH rule.

## Repository Files

- `README.md` – project overview
- `scripts/user-data.sh` – launch template startup script
- `documentation/backup-restore-commands.md` – backup and restoration procedure
- `documentation/deployment-summary.md` – deployment configuration and results

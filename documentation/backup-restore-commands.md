# WordPress Backup and Restore Procedure

This document records the commands used to back up the WordPress application files and Amazon RDS MariaDB database.

Values inside angle brackets must be replaced with the relevant deployment values. Passwords must not be written directly in commands or stored in this repository.

## 1. Create the Backup Directory

```bash
mkdir -p /home/ec2-user/backups
```

## 2. Back Up the RDS Database

```bash
mysqldump -h <RDS_ENDPOINT> -P 3306 -u <DB_USER> -p --ssl-verify-server-cert --ssl-ca=/home/ec2-user/global-bundle.pem --single-transaction <DB_NAME> > /home/ec2-user/backups/wordpress_db_rds.sql
```

The database password is entered interactively when prompted.

## 3. Back Up the WordPress Files

```bash
sudo tar -czf /home/ec2-user/backups/wordpress_files.tar.gz -C /var/www/html .
```

## 4. Set File Ownership

```bash
sudo chown ec2-user:ec2-user /home/ec2-user/backups/wordpress_files.tar.gz
```

## 5. Verify the Backup Files

```bash
ls -lh /home/ec2-user/backups/wordpress_db_rds.sql
```

```bash
ls -lh /home/ec2-user/backups/wordpress_files.tar.gz
```

## 6. Generate SHA-256 Checksums

```bash
sha256sum /home/ec2-user/backups/wordpress_db_rds.sql
```

```bash
sha256sum /home/ec2-user/backups/wordpress_files.tar.gz
```

## 7. Upload the Backups to Amazon S3

The two backup files were uploaded to a private S3 bucket:

- `wordpress_db_rds.sql`
- `wordpress_files.tar.gz`

The following AWS CLI commands can also be used when the EC2 IAM role has permission to access the bucket.

```bash
aws s3 cp /home/ec2-user/backups/wordpress_db_rds.sql s3://<S3_BUCKET_NAME>/
```

```bash
aws s3 cp /home/ec2-user/backups/wordpress_files.tar.gz s3://<S3_BUCKET_NAME>/
```

## 8. Download the Backups for Restoration

```bash
aws s3 cp s3://<S3_BUCKET_NAME>/wordpress_db_rds.sql /home/ec2-user/backups/
```

```bash
aws s3 cp s3://<S3_BUCKET_NAME>/wordpress_files.tar.gz /home/ec2-user/backups/
```

## 9. Restore the WordPress Files

```bash
mkdir -p /home/ec2-user/wordpress-restore-test
```

```bash
tar -xzf /home/ec2-user/backups/wordpress_files.tar.gz -C /home/ec2-user/wordpress-restore-test
```

## 10. Verify the Restored Files

```bash
test -f /home/ec2-user/wordpress-restore-test/index.php
```

```bash
test -d /home/ec2-user/wordpress-restore-test/wp-content
```

```bash
ls -la /home/ec2-user/wordpress-restore-test
```

## 11. Database Restore Command

The following command can restore the SQL backup to an empty database when required.

```bash
mysql -h <RDS_ENDPOINT> -P 3306 -u <DB_USER> -p --ssl-verify-server-cert --ssl-ca=/home/ec2-user/global-bundle.pem <DB_NAME> < /home/ec2-user/backups/wordpress_db_rds.sql
```

## Security Notes

- Do not store database passwords in scripts.
- Do not commit `wp-config.php`.
- Do not upload private keys or AWS credentials.
- Keep the S3 backup bucket private.

# SQL & PowerShell Scripts
Collection of small scripts for SQL Server, PowerShell, VBScript and VBA.

## Directory Structure

```
├── sql/                          # SQL Server Scripts
│   ├── database-information/     # Database Information
│   │   ├── change-database-owner.sql
│   │   ├── get-all-users-all-databases.sql
│   │   ├── get-backup-sizes.sql
│   │   ├── get-cluster-hostname.sql
│   │   ├── get-column-data-types.sql
│   │   ├── get-database-owners.sql
│   │   ├── get-database-sizes.sql
│   │   ├── get-database-space-detail.sql
│   │   ├── get-datafile-sizes.sql
│   │   ├── get-instance-users.sql
│   │   ├── get-job-owners.sql
│   │   ├── get-last-database-access.sql
│   │   ├── get-permissions.sql
│   │   └── get-tempdb-information.sql
│   ├── date-dimension/           # Date Dimension
│   │   ├── create-date-dimension.sql
│   │   └── german-public-holidays.sql
│   ├── jobs/                     # SQL Server Agent Jobs
│   │   ├── job-enable-disable-template.sql
│   │   └── query-job-steps-with-commands.sql
│   ├── linked-server/            # Linked Server
│   │   ├── create-linked-server-template.sql
│   │   └── get-remote-data-template.sql
│   ├── maintenance/              # Maintenance
│   │   ├── get-index-fragmentation.sql
│   │   └── get-table-sizes.sql
│   ├── recovery-model/           # Recovery Model
│   │   └── set-recovery-model-all-databases.sql
│   ├── security/                 # Security
│   │   ├── enable-agent-xps.sql
│   │   ├── evaluate-login-security.sql
│   │   ├── grant-activity-monitor.sql
│   │   ├── grant-default-permissions.sql
│   │   └── grant-errorlog-job-permissions.sql
│   ├── ssas/                     # SSAS
│   │   ├── calculated-members-examples.sql
│   │   └── cube-cell-calculations-template.sql
│   └── tools/                    # Tools
│       ├── generate-number-table.sql
│       ├── pivot-table-template.sql
│       └── transfer-table-template.sql
├── powershell/                   # PowerShell Scripts
│   └── backup/
│       └── backup.ps1
└── vbscript/                     # VBScript & VBA
    └── Check_ADGroup.vbs
```

## Usage

All scripts are universal and can be used on any SQL Server instance. 
Replace the placeholder values (marked with `YOUR_...`) with your actual values.

## Requirements

- SQL Server 2016 or later (for most scripts)
- PowerShell with SQL Server SMO libraries (for backup scripts)
- VBScript support (for administration scripts)
# scalr-ignite

<img src="/images/scc-logo.jpg"  width="50%" height="50%">

## [Sierra-Cedar DevOps Services](https://www.sierra-cedar.com/devops) help you effectively operate at scale in your Cloud Service Provider(s).  Sierra-Cedar is a [Scalr](https://scalr.com) partner.  Check out our [FlexOps](https://www.sierra-cedar.com/devops-services/) framework for getting your [Terraform](https://www.terraform.io/) code, version control, CI/CD, and cloud infrastructure under control!

## The Ignite project by [Sierra-Cedar](http://www.sierra-cedar.com/flexops/) is designed to get you started quickly by deploying a sample business structure, including Environments, Workspaces, IAM Roles, IAM Access Policies, and IAM Teams to kickstart your [Scalr](https://scalr.com) experience, and to demonstrate the [Scalr provider](https://docs.scalr.com/en/latest/scalr-terraform-provider/) capabilities, further extending your ability to manage infrastructure as code at-scale.  The Terraform code is designed to be used in a Free-Tier Scalr account.  

Requirements:

<table>
<tr>
<td width="60%">
Terraform Version
</td>
<td width="40%">
>= 1.1.4
</td>
</tr>
<tr>
<td width="60%">
Scalr Provider
</td>
<td width="40%">
1.0.0-rc36
</td>
</tr>
</table>

### What's Delivered

- Terraform resources that use the Scalr provider to build Environments, Workspaces, IAM Roles, IAM Teams, and Access Policies
- A sample organizational structure, including CCOE, Security, HR, Finance, Manufacturing and Marketing Environments
   - Each Team is split into SDLC phases (Production and non-Production), and further separated into projects in the Environment Workspaces
- An "iam" folder, where you can add, remove, and update...
   - Permissions:

```yaml
base:
  - accounts:read
  - roles:read
  - teams:read
  - software-versions:read
  - users:read
...
```

   - Teams:

```yaml
- name: Ignite-Security-Admin-Team
  description: Security Team with full access to their environment, plus access to the 000-Security Workspace in each Environment
...
```

   - and Roles:

```yaml
- name: Ignite-Environment-Admin-Role
  description: Read/Write access to all resources in the Environment
  permissions:
  - base
  - wsadmin
...
```

- An "environments" folder where you can add, remove, or update environments, workspaces, and security mappings:

```yaml
- name: Sandbox
  secmaps:
  - roles:
    - Ignite-Environment-Admin-Role
    team: Ignite-CCOE-Admin-Team
  - roles:
    - Ignite-Environment-ReadOnly-Role
    team: Ignite-Security-Admin-Team
  workspaces:
  - name: 000-Security
    secmaps:
    - roles:
      - Ignite-Workspace-Admin-Role
      team: Ignite-Security-Admin-Team
    - roles:
      - Ignite-Workspace-ReadOnly-Role
      team: Ignite-CCOE-Admin-Team
  - name: 010-Network
    secmaps:
    - roles:
      - Ignite-Workspace-ReadOnly-Role
      team: Ignite-Security-Admin-Team
    - roles:
      - Ignite-Workspace-Admin-Role
      team: Ignite-CCOE-Admin-Team
```

### Setup Instructions

1. Go to https://scalr.com and sign up for a Free Tier account, if you haven't already.

2. Collect Scalr information:
   1. ACCOUNT_ID     -> Found on the Scalr Account Dashboard (Green Menu Context)
   2. URL            -> Your personalized URL to access Scalr (your-account.scalr.io), including the .scalr.io

2. Install Terraform v1.1.4 or later (earlier releases may work, but are not tested or supported)

3. Clone/Fork this repository (https://github.com/sierra-cedar/scalr-ignite)

4. Edit the files labeled _UPDATE_ME_ in each sub-folder with the Scalr Information from Step 2 (above)

5. Setup your Scalr API credentials:
   1. Change to the **1 - OrgSDLC** sub-folder
   2. Using the URL from step 2.ii, run **terraform login _\<URL>_** and answer **yes** to storing your credentials.  
   3. A new browser window will open to create an API key in Scalr.  Give it a description (e.g., Scalr-Ignite) and click _Create_.  
   4. Copy the generated Token, and return to the command line where you ran **terraform login** and paste the Token.  

6. Navigate to the **1 - OrgSDLC** subfolder.
7. Run a **terraform init** to pull down the Scalr Provider and initialize the backend in Scalr. 

8. Run a **terraform plan**. 
   1. The terraform plan will provide a link to access the "dry run" in Scalr.  
   2. Output from the run will also be shown locally.  
   3. If successful, continue to step 7.  If there is a failure, double check that you edited the **_UPDATE_ME_** files appropriately.  

9. Run a **terraform apply**.  

Congratulations - you have deployed the Ignite template in Scalr!  



*If you want to learn more about [Sierra-Cedar DevOps](https://www.sierra-cedar.com/devops) Services, please visit our website at https://www.sierra-cedar.com/devops-services/*


Copyright (C) 2022 - Sierra-Cedar

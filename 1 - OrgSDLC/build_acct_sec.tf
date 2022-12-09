# Scalr Ignite - Quick Start Demo for Scalr
# Copyright (C) 2022 Sierra-Cedar

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Contact: devops@sierra-cedar.com

locals {
    adminsec = [
        for each_sec in var.scalr_acct_security : {
            team_name = each_sec.team
            team_id   = scalr_iam_team.ignite_teams[each_sec.team].id
            roles     = flatten([
                for each_role in each_sec.roles :[
                    scalr_role.ignite_roles[each_role].id
                ]
            ])
        }
    ]
}

resource scalr_access_policy "scalr_admin" {
    for_each = {
        for admin in local.adminsec : admin.team_name => admin
    }
    subject {
        type = "team"
        id = each.value.team_id
    }
    scope {
        type = "account"
        id = var.account_id
    }

    role_ids = each.value.roles   
}